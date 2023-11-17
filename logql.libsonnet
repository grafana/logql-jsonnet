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

local range(interval, resolution) = (
  // check to see if the passed interval contains the resolution already i.e. 1h:1m, also strip out any accidental spaces, [, or ]
  local iList = std.split(std.stripChars(std.strReplace(std.strReplace(interval, '[', ''), ']', ''), " "), ':');
  local i = if std.length(iList) == 2 then iList[0] else interval;
  local r = if std.length(iList) == 2 then iList[1] else resolution;
  if r == null then
    std.format('[%s]', [i])
  else
    std.format('[%s:%s]', [i, r])
);

{
  local root = self,
  new():: {
    local it = self,
    _query:: '',
    _labels:: [],
    _funcs:: [],
    _statements:: [], // holds the statements added, as we might need to reference the previous command to know what to do

    // selectors
    selector(label):: {
      eq(predicate):: it.selectorLabelEq(label, predicate),
      neq(predicate):: it.selectorLabelNeq(label, predicate),
      re(predicate):: it.selectorLabelRe(label, predicate),
      nre(predicate):: it.selectorLabelNre(label, predicate),
    },

    selectorLabelEq(label, predicate):: self.withLabel(label, '=', predicate),
    selectorLabelNeq(label, predicate):: self.withLabel(label, '!=', predicate),
    selectorLabelRe(label, predicate):: self.withLabel(label, '=~', predicate),
    selectorLabelNre(label, predicate):: self.withLabel(label, '!~', predicate),

    withLabels(labels):: self {
      _statements+:: [{ type: 'withLabels', args: [labels] }],
      _labels+:: [{ label: k, op: "=", value: labels[k] } for k in std.objectFields(labels)],
    },

    withLabel(label, op='=', value=null):: self {
      local add_label = (
        if std.type(label) == 'object' then
          [label]
        else
          [{ label: label, op: op, value: value }]
      ),
      _statements+:: [{ type: 'withLabels', args: [add_label] }],
      _labels+:: add_label,
    },

    _labelExpr()::
      if self._labels == [] then
        ""
      else
        std.format('{%s}', std.join(', ', [std.format('%s%s"%s"', [label.label, label.op, label.value]) for label in self._labels])),

    // line filters
    _lineFilter(operator, text):: self {
      _statements+:: [{ type: 'lineFilter', args: [operator, text] }],
      _query+:: '\n' + std.format('%s `%s`', [operator, text]),
    },

    lineEq(text):: self._lineFilter('|=', text),
    lineNeq(text):: self._lineFilter('!=', text),
    lineRe(text):: self._lineFilter('|~', text),
    lineNre(text):: self._lineFilter('!~', text),

    line():: {
      eq(text):: it.lineEq(text),
      neq(text):: it.lineNeq(text),
      re(text):: it.lineRe(text),
      nre(text):: it.lineNre(text),
      format(format):: it.line_format(format),
    },

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
    pattern(pattern):: self._parser(std.format('pattern `%s`', pattern)),
    regex(regex):: self._parser(std.format('regex `%s`', regex)),

    // label filters
    _labelFilter(operator, label, value):: self {
      // check the predicate type and convert it to a string with quotes if it's a string
      local formatted = if std.isString(value) then
        if isDuration(value) || isBytes(value) then
          value
        else
          std.format('`%s`', value)
      else
        std.toString(value),
      _statements+:: [{ type: 'labelFilter', args: [operator, label, value] }],
      _query+:: pipe +
        if operator == '' then
          std.format('%s', [label])
        else
          std.format('%s %s %s', [label, operator, formatted]),
    },
    labelNoop(label):: self._labelFilter('', label, ''),
    labelEq(label, value):: self._labelFilter('==', label, value),
    labelNeq(label, value):: self._labelFilter('!=', label, value),
    labelGt(label, value):: self._labelFilter('>', label, value),
    labelGte(label, value):: self._labelFilter('>=', label, value),
    labelLt(label, value):: self._labelFilter('<', label, value),
    labelLte(label, value):: self._labelFilter('<=', label, value),
    labelRe(label, value):: self._labelFilter('=~', label, value),
    labelNre(label, value):: self._labelFilter('!~', label, value),

    label(label=''):: {
      noop():: it.labelNoop(label),
      eq(value):: it.labelEq(label, value),
      neq(value):: it.labelNeq(label, value),
      gt(value):: it.labelGt(label, value),
      gte(value):: it.labelGte(label, value),
      lt(value):: it.labelLt(label, value),
      lte(value):: it.labelLte(label, value),
      re(value):: it.labelRe(label, value),
      nre(value):: it.labelNre(label, value),
    },

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
      local formattedExprs = std.strReplace(std.join(' %s ' % operator, [if std.isString(expr) then expr else std.toString(expr) for expr in exprs]), stripNewLines(pipe), ' '),
      _statements+:: [{ type: 'logical', args: [operator, exprs] }],
      _query+:: std.strReplace(std.strReplace(std.format('%s(%s)', [prefix, formattedExprs]), '( ', '('), '  ', ' '),
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
    lineFormat(format):: self.line_format(format),
    label_format(label, path):: self {
      _statements+:: [{ type: 'labelFormat', args: [label, path] }],
      _query+:: pipe + std.format('label_format %s=`%s`', [label, path]),
    },
    labelFormat(label, path):: self.label_format(label, path),
    decolorize():: self {
      _statements+:: [{ type: 'decolorize', args: [] }],
      _query+:: pipe + 'decolorize',
    },

    _dropKeep(type, labels):: self {
      local formattedLabels = std.strReplace(std.strReplace(std.strReplace(std.strReplace(std.strReplace(std.strReplace(std.join(', ', labels), stripNewLines(pipe), ''), ' == ', '=='), ' != ', '!='), ' =~ ', '=~'), ' !~ ', '!~'), '\n| ', ''),
      _statements+:: [{ type: type, args: [labels] }],
      _query+:: pipe + std.format('%s %s', [type, formattedLabels]),
    },
    drop(labels):: self._dropKeep('drop', labels),
    keep(labels):: self._dropKeep('keep', labels),

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

    // unwrapped range and aggregations
    _range_agg(func, interval, resolution=null, offset=null):: self {
      local paddedOffset = if offset != null && offset != '' then ' offset %s' % offset else '',
      _statements+:: [{ type: 'overTime', args: [func, interval, resolution, offset] }],
      // functions are not built until the build() method is called, so we need to add the function to the _funcs array
      // the leading %s is not immediately replaced and is a placeholder where the rendered inner query will utlimately
      // be rendered at build time
      _funcs+::
        if std.startsWith(func, 'quantile_over_time') then
          // the quantile_over_time is the only _over_time that has 2 arguments and is passed in with the leading ( already
          [func + '%s ' + range(interval, resolution) + '%s)' % paddedOffset]
        else
          [func + '(%s ' + range(interval, resolution) + '%s)' % paddedOffset],
    },
    // TODO: add support for offset
    // TODO: add support for grouping
    rate(interval, resolution=null, offset=null):: it._range_agg('rate', interval, resolution, offset),
    rate_counter(interval, resolution=null, offset=null):: it._range_agg('rate_counter', interval, resolution, offset),
    rateCounter(interval, resolution=null, offset=null):: it.rate_counter(interval, resolution, offset),
    bytes_rate(interval, resolution=null, offset=null):: it._range_agg('bytes_rate', interval, resolution, offset),
    bytesRate(interval, resolution=null, offset=null):: it.bytes_rate(interval, resolution, offset),
    bytes_over_time(interval, resolution=null, offset=null):: it._range_agg('bytes_over_time', interval, resolution, offset),
    bytesOverTime(interval, resolution=null, offset=null):: it.bytes_over_time(interval, resolution, offset),
    count_over_time(interval, resolution=null, offset=null):: it._range_agg('count_over_time', interval, resolution, offset),
    countOverTime(interval, resolution=null, offset=null):: it.count_over_time(interval, resolution, offset),
    sum_over_time(interval, resolution=null, offset=null):: it._range_agg('sum_over_time', interval, resolution, offset),
    sumOverTime(interval, resolution=null, offset=null):: it.sum_over_time(interval, resolution, offset),
    absent_over_time(interval, resolution=null, offset=null):: it._range_agg('absent_over_time', interval, resolution, offset),
    absentOverTime(interval, resolution=null, offset=null):: it.absent_over_time(interval, resolution, offset),
    // the following unwrapped range aggregations support optional aggreation using by/without
    avg_over_time(interval, resolution=null, offset=null):: it._range_agg('avg_over_time', interval, resolution, offset),
    avgOverTime(interval, resolution=null, offset=null):: it.avg_over_time(interval, resolution, offset),
    min_over_time(interval, resolution=null, offset=null):: it._range_agg('min_over_time', interval, resolution, offset),
    minOverTime(interval, resolution=null, offset=null):: it.min_over_time(interval, resolution, offset),
    max_over_time(interval, resolution=null, offset=null):: it._range_agg('max_over_time', interval, resolution, offset),
    maxOverTime(interval, resolution=null, offset=null):: it.max_over_time(interval, resolution, offset),
    first_over_time(interval, resolution=null, offset=null):: it._range_agg('first_over_time', interval, resolution, offset),
    firstOverTime(interval, resolution=null, offset=null):: it.first_over_time(interval, resolution, offset),
    last_over_time(interval, resolution=null, offset=null):: it._range_agg('last_over_time', interval, resolution, offset),
    lastOverTime(interval, resolution=null, offset=null):: it.last_over_time(interval, resolution, offset),
    stdvar_over_time(interval, resolution=null, offset=null):: it._range_agg('stdvar_over_time', interval, resolution, offset),
    stdVarOverTime(interval, resolution=null, offset=null):: it.stdvar_over_time(interval, resolution, offset),
    stddev_over_time(interval, resolution=null, offset=null):: it._range_agg('stddev_over_time', interval, resolution, offset),
    stdDevOverTime(interval, resolution=null, offset=null):: it.stddev_over_time(interval, resolution, offset),
    quantile_over_time(quantile, interval, resolution=null, offset=null):: it._range_agg(std.format('quantile_over_time(%s, ', quantile), interval, resolution, offset),
    quantileOverTime(quantile, interval, resolution=null, offset=null):: it.quantile_over_time(quantile, interval, resolution, offset),

    // aggregation functions
    // TODO: Support string or array
    _agg(func, by='', without=''):: self {
      local aggBy = if by != '' then std.format(' by (%s) ', [by]) else '',
      local aggWithout = if without != '' then std.format(' without (%s) ', [without]) else '',
      _statements+:: [{ type: 'agg', args: [func, by, without] }],
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
