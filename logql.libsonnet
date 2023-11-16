local pipe = '\n| ';

// helper functions
local stripNewLines(str) = std.strReplace(str, '\n', ' ');

local findPreviousStatementIndex(currentStatement, statements) = (
  // std.find does not support searching for objects, so we need to stringify the objects first
  local stringifiedStatements = [std.manifestJsonMinified(statement) for statement in statements];
  local currentStatementStr = std.manifestJsonMinified(currentStatement);
  // find the index of the current statement in the stringified statements
  local results = std.find(currentStatementStr, stringifiedStatements);
  // std.find returns an array of results, so we need to get the first result and subtract 1 to get the index of the previous statement
  if std.length(results) > 0 then results[0] - 1 else -1
);

// checks to see if an input string is a duration
local isDuration(str) =
  if std.endsWith(str, 'ns')
    || std.endsWith(str, 'us')
    || std.endsWith(str, 'µs')
    || std.endsWith(str, 'ms')
    || std.endsWith(str, 's')
    || std.endsWith(str, 'm')
    || std.endsWith(str, 'h')
    || std.endsWith(str, 'd')
  then
    true
  else
    false;

// checks to see if an input string is a bytes
local isBytes(str) =
  local lowered_str = std.asciiLower(str);
  if std.endsWith(lowered_str, 'b')
    || std.endsWith(lowered_str, 'kib')
    || std.endsWith(lowered_str, 'kb')
    || std.endsWith(lowered_str, 'mib')
    || std.endsWith(lowered_str, 'mb')
    || std.endsWith(lowered_str, 'gib')
    || std.endsWith(lowered_str, 'gb')
    || std.endsWith(lowered_str, 'tib')
    || std.endsWith(lowered_str, 'tb')
    || std.endsWith(lowered_str, 'pib')
    || std.endsWith(lowered_str, 'pb')
    || std.endsWith(lowered_str, 'eib')
    || std.endsWith(lowered_str, 'eb')
  then
    true
  else
    false;

local range(interval, resolution='') = (
  if resolution == '' then
    std.format('[%s]', [interval])
  else
    std.format('[%s:%s]', [interval, resolution])
);

{
  new():: {
    local it = self,
    _query:: '',
    _labels:: [],
    _funcs:: [],
    _statements:: [], // holds the statements added, as we might need to reference the previous command to know what to do

    withLabels(labels):: self {
      _statements+:: [{ type: 'withLabels', args: [labels] }],
      _labels+:: [{ key: k, op: "=", value: labels[k] } for k in std.objectFields(labels)],
    },

    _labelExpr()::
      if self._labels == [] then
        ""
      else
        std.format('{%s}', std.join(', ', [std.format('%s%s"%s"', [label.key, label.op, label.value]) for label in self._labels])),

    // line filters
    _lineFilter(operator, text):: self {
      _statements+:: [{ type: 'lineFilter', args: [operator, text] }],
      _query+:: ' ' + std.format('%s `%s`', [operator, text]),
    },
    lineEq(text):: self._lineFilter('|=', text),
    lineNeq(text):: self._lineFilter('!=', text),
    lineRe(text):: self._lineFilter('|~', text),
    lineNre(text):: self._lineFilter('!~', text),

    // parsers
    _parser(parser, pattern=''):: self {
      _statements+:: [{ type: 'parser', args: [parser] }],
      _query+:: pipe + parser + (
        if pattern == '' then
          ''
        else
          ' ' + pattern
      ),
    },
    json(labels=''):: self._parser('json', labels),
    logfmt(labels=''):: self._parser('logfmt', labels),
    pattern(pattern):: self._parser(std.format('pattern %s', pattern)),
    regex(regex):: self._parser(std.format('regex %s', regex)),

    // label filters
    _labelFilter(operator, label, predicate):: self {
      // check the predicate type and convert it to a string with quotes if it's a string
      local formatted = if std.isString(predicate) then
        if isDuration(predicate) || isBytes(predicate) then
          predicate
        else
          std.format('`%s`', predicate)
      else
        std.toString(predicate),
      _statements+:: [{ type: 'labelFilter', args: [operator, label, predicate] }],
      _query+:: pipe +
        if operator == '' then
          std.format('%s', [label])
        else
          std.format('%s%s%s', [label, operator, formatted]),
    },
    label(label):: self._labelFilter('', label, ''),
    labelEq(label, predicate):: self._labelFilter('=', label, predicate),
    labelNeq(label, predicate):: self._labelFilter('!=', label, predicate),
    labelGt(label, predicate):: self._labelFilter('>', label, predicate),
    labelGte(label, predicate):: self._labelFilter('>=', label, predicate),
    labelLt(label, predicate):: self._labelFilter('<', label, predicate),
    labelLte(label, predicate):: self._labelFilter('<=', label, predicate),
    labelRe(label, predicate):: self._labelFilter('=~', label, predicate),
    labelNre(label, predicate):: self._labelFilter('!~', label, predicate),

    // operators
    _op(operator, exprs):: self {
      local currentStatement = { type: 'logical', args: [operator, exprs] },
      local prevStatementIndex = findPreviousStatementIndex(currentStatement, self._statements),
      local prevStatement = if prevStatementIndex >= 0 then self._statements[prevStatementIndex] else '',

      // set the prefix to a space if the last statement was a logical operator, otherwise set it to a pipe
      local prefix = if prevStatement.type == 'logical' then
        if prevStatement.args[0] != operator then
          std.format(' %s ', operator)
        else
          if (std.length(exprs) > 1 && operator == 'and') then
            std.format(' %s ', operator)
          else
          ''
      else
        pipe,
      local formattedExprs = [if std.isString(expr) then expr else std.toString(expr) for expr in exprs],
      _statements+:: [{ type: 'logical', args: [operator, exprs] }],
      _query+:: std.format('%s(%s)', [prefix, std.strReplace(std.join(' %s ' % operator, formattedExprs), stripNewLines(pipe), '')]),
    },

    and(exprs):: self._op('and', exprs),
    or(exprs):: self._op('or', exprs),

    // Method to wrap expressions in parentheses (useful for nested expressions)
    group(expr):: self {
      _query+:: ' (' + expr + ')',
    },

    // formatting
    line_format(format):: self {
      _statements+:: [{ type: 'lineFormat', args: [format] }],
      _query+:: pipe + std.format('line_format `%s`', [format]),
    },
    label_format(label, path):: self {
      _statements+:: [{ type: 'labelFormat', args: [label, path] }],
      _query+:: pipe + std.format('label_format %s=`%s`', [label, path]),
    },
    drop(labels):: self {
      _statements+:: [{ type: 'drop', args: [labels] }],
      _query+:: pipe + std.format('drop %s', [std.strReplace(std.join(', ', labels), stripNewLines(pipe), '')]),
    },
    keep(labels):: self {
      _statements+:: [{ type: 'keep', args: [labels] }],
      _query+:: pipe + std.format('keep %s', [std.strReplace(std.join(', ', labels), stripNewLines(pipe), '')]),
    },

    // unwrap
    unwrap(label):: self {
      _statements+:: [{ type: 'unwrap', args: [label] }],
      _query+:: pipe + 'unwrap %s' % label,
    },
    unwrapDuration(label):: self.unwrap('duration_seconds(%s)' % label),
    unwrapBytes(label):: self.unwrap('bytes(%s)' % label),

    // metric query helpers
    applyTemplate(query, func):: std.format(func, query),
    applyFunctions(query):: std.foldl(self.applyTemplate, self._funcs, query),

    // unwrapped range aggregations
    _over_time(func, interval, resolution=''):: self {
      _statements+:: [{ type: 'overTime', args: [func, interval, resolution] }],
      _funcs+:: if std.startsWith(func, 'quantile_over_time') then
          [func + '%s ' + range(interval, resolution) + ')']
        else
          [func + '(%s ' + range(interval, resolution) + ')'],
    },
    rate(interval, resolution=''):: self._over_time('rate', interval, resolution),
    rate_counter(interval, resolution=''):: self._over_time('rate_counter', interval, resolution),
    sum_over_time(interval, resolution=''):: self._over_time('sum_over_time', interval, resolution),
    avg_over_time(interval, resolution=''):: self._over_time('avg_over_time', interval, resolution),
    min_over_time(interval, resolution=''):: self._over_time('min_over_time', interval, resolution),
    max_over_time(interval, resolution=''):: self._over_time('max_over_time', interval, resolution),
    first_over_time(interval, resolution=''):: self._over_time('max_over_time', interval, resolution),
    last_over_time(interval, resolution=''):: self._over_time('max_over_time', interval, resolution),
    stdvar_over_time(interval, resolution=''):: self._over_time('stdvar_over_time', interval, resolution),
    stddev_over_time(interval, resolution=''):: self._over_time('stddev_over_time', interval, resolution),
    quantile_over_time(quantile, interval, resolution=''):: self._over_time(std.format('quantile_over_time(%s, ', quantile), interval, resolution),
    absent_over_time(interval, resolution=''):: self._over_time('absent_over_time', interval, resolution),

    // aggregation functions
    _agg(func, by='', without=''):: self {
      local aggBy = if by != '' then std.format(' by(%s) ', [by]) else '',
      local aggWithout = if without != '' then std.format(' without(%s) ', [without]) else '',
      _statements+:: [{ type: 'overTime', args: [func, by, without] }],
      _funcs+:: [func + aggBy + aggWithout + '(%s)']
    },
    sum(by='', without=''):: self._agg('sum', by, without),
    sumBy(by):: self.sum(by, ''),
    sumWithout(without):: self.sum('', without),
    avg(by='', without=''):: self._agg('avg', by, without),
    avgBy(by):: self.avg(by, ''),
    avgWithout(without):: self.avg('', without),
    min(by='', without=''):: self._agg('min', by, without),
    minBy(by):: self.min(by, ''),
    minWithout(without):: self.min('', without),
    max(by='', without=''):: self._agg('max', by, without),
    maxBy(by):: self.max(by, ''),
    maxWithout(without):: self.max('', without),
    stddev(by='', without=''):: self._agg('stddev', by, without),
    stddevBy(by):: self.stddev(by, ''),
    stddevWithout(without):: self.stddev('', without),
    stdvar(by='', without=''):: self._agg('stdvar', by, without),
    stdvarBy(by):: self.stdvar(by, ''),
    stdvarWithout(without):: self.stdvar('', without),
    count(by='', without=''):: self._agg('count', by, without),
    countBy(by):: self.count(by, ''),
    countWithout(without):: self.count('', without),

    // builds the query
    build(formatted=true)::
      local baseQuery = if !formatted then
        stripNewLines(self._labelExpr() + self._query)
      else
        self._labelExpr() + self._query;
      self.applyFunctions(baseQuery),
  },
}
