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

local stringToList(input, delimiter=',', stripSpaces=true) = (
  if input == null then
    []
  else if std.isString(input) then
    if stripSpaces then
      std.split(std.strReplace(input, ' ', ''), delimiter)
    else
      std.split(input, delimiter)
  else
    input
);

{
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
    unwrap_duration(label):: it.unwrap('duration_seconds(%s)' % label),
    unwrapDuration(label):: it.unwrap_duration(label),
    unwrap_bytes(label):: it.unwrap('bytes(%s)' % label),
    unwrapBytes(label):: it.unwrap_bytes(label),

    // metric query helpers
    applyTemplate(query, func):: std.format(func, query),
    applyFunctions(query):: std.foldl(self.applyTemplate, self._funcs, query),

    // unwrapped range and aggregations
    _range_agg(func, interval, resolution=null, offset=null, by=null, without=null):: self {
      local paddedOffset = if offset != null && offset != '' then ' offset %s' % offset else '',
      local byList = stringToList(by),
      local aggBy = if std.length(byList) > 0 then std.format(' by (%s)', [std.join(', ', byList)]) else '',
      local withoutList = stringToList(without),
      local aggWithout = if std.length(withoutList) > 0 then std.format(' without (%s)', [std.join(', ', withoutList)]) else '',
      _statements+:: [{ type: 'overTime', args: [func, interval, resolution, offset] }],
      // functions are not built until the build() method is called, so we need to add the function to the _funcs array
      // the leading %s is not immediately replaced and is a placeholder where the rendered inner query will utlimately
      // be rendered at build time
      _funcs+::
        // the first %s is a placeholder for where the query will be inserted at
        if std.startsWith(func, 'quantile_over_time') then
          // the quantile_over_time is the only _over_time that has 2 arguments and is passed in with the leading ( already
          [func + '%s ' + range(interval, resolution) + ('%s)' % paddedOffset) + aggBy + aggWithout]
        else
          [func + '(%s ' + range(interval, resolution) + ('%s)' % paddedOffset) + aggBy + aggWithout],
    },
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
    avg_over_time(interval, resolution=null, offset=null, by=[], without=[]):: it._range_agg(func='avg_over_time', interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    avg_over_time_by(interval, by, resolution=null, offset=null):: it.avg_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    avg_over_time_without(interval, without, resolution=null, offset=null):: it.avg_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    avgOverTime(interval, resolution=null, offset=null, by=[], without=[]):: it.avg_over_time(interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    avgOverTimeBy(interval, by, resolution=null, offset=null):: it.avg_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    avgOverTimeWithout(interval, without, resolution=null, offset=null):: it.avg_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    min_over_time(interval, resolution=null, offset=null, by=[], without=[]):: it._range_agg(func='min_over_time', interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    min_over_time_by(interval, by, resolution=null, offset=null):: it.min_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    min_over_time_without(interval, without, resolution=null, offset=null):: it.min_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    minOverTime(interval, resolution=null, offset=null, by=[], without=[]):: it.min_over_time(interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    minOverTimeBy(interval, by, resolution=null, offset=null):: it.min_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    minOverTimeWithout(interval, without, resolution=null, offset=null):: it.min_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    max_over_time(interval, resolution=null, offset=null, by=[], without=[]):: it._range_agg(func='max_over_time', interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    max_over_time_by(interval, by, resolution=null, offset=null):: it.max_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    max_over_time_without(interval, without, resolution=null, offset=null):: it.max_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    maxOverTime(interval, resolution=null, offset=null, by=[], without=[]):: it.max_over_time(interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    maxOverTimeBy(interval, by, resolution=null, offset=null):: it.max_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    maxOverTimeWithout(interval, without, resolution=null, offset=null):: it.max_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    first_over_time(interval, resolution=null, offset=null, by=[], without=[]):: it._range_agg(func='first_over_time', interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    first_over_time_by(interval, by, resolution=null, offset=null):: it.first_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    first_over_time_without(interval, without, resolution=null, offset=null):: it.first_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    firstOverTime(interval, resolution=null, offset=null, by=[], without=[]):: it.first_over_time(interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    firstOverTimeBy(interval, by, resolution=null, offset=null):: it.first_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    firstOverTimeWithout(interval, without, resolution=null, offset=null):: it.first_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    last_over_time(interval, resolution=null, offset=null, by=[], without=[]):: it._range_agg(func='last_over_time', interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    last_over_time_by(interval, by, resolution=null, offset=null):: it.last_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    last_over_time_without(interval, without, resolution=null, offset=null):: it.last_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    lastOverTime(interval, resolution=null, offset=null, by=[], without=[]):: it.last_over_time(interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    lastOverTimeBy(interval, by, resolution=null, offset=null):: it.last_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    lastOverTimeWithout(interval, without, resolution=null, offset=null):: it.last_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    stdvar_over_time(interval, resolution=null, offset=null, by=[], without=[]):: it._range_agg(func='stdvar_over_time', interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    stdvar_over_time_by(interval, by, resolution=null, offset=null):: it.stdvar_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    stdvar_over_time_without(interval, without, resolution=null, offset=null):: it.stdvar_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    stdvarOverTime(interval, resolution=null, offset=null, by=[], without=[]):: it.stdvar_over_time(interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    stdvarOverTimeBy(interval, by, resolution=null, offset=null):: it.stdvar_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    stdvarOverTimeWithout(interval, without, resolution=null, offset=null):: it.stdvar_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    stddev_over_time(interval, resolution=null, offset=null, by=[], without=[]):: it._range_agg(func='stddev_over_time', interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    stddev_over_time_by(interval, by, resolution=null, offset=null):: it.stddev_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    stddev_over_time_without(interval, without, resolution=null, offset=null):: it.stddev_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    stddevOverTime(interval, resolution=null, offset=null, by=[], without=[]):: it.stddev_over_time(interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    stddevOverTimeBy(interval, by, resolution=null, offset=null):: it.stddev_over_time(interval=interval, resolution=resolution, offset=offset, by=by),
    stddevOverTimeWithout(interval, without, resolution=null, offset=null):: it.stddev_over_time(interval=interval, resolution=resolution, offset=offset, without=without),
    quantile_over_time(quantile, interval, resolution=null, offset=null, by=[], without=[]):: it._range_agg(func=std.format('quantile_over_time(%s, ', quantile), interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    quantile_over_time_by(quantile, interval, by, resolution=null, offset=null):: it.quantile_over_time(quantile, interval=interval, resolution=resolution, offset=offset, by=by),
    quantile_over_time_without(quantile, interval, without, resolution=null, offset=null):: it.quantile_over_time(quantile, interval=interval, resolution=resolution, offset=offset, without=without),
    quantileOverTime(quantile, interval, resolution=null, offset=null, by=[], without=[]):: it.quantile_over_time(quantile, interval=interval, resolution=resolution, offset=offset, by=by, without=without),
    quantileOverTimeBy(quantile, interval, by, resolution=null, offset=null):: it.quantile_over_time(quantile, interval=interval, resolution=resolution, offset=offset, by=by),
    quantileOverTimeWithout(quantile, interval, without, resolution=null, offset=null):: it.quantile_over_time(quantile, interval=interval, resolution=resolution, offset=offset, without=without),

    // aggregation functions
    _agg(func, by=[], without=[]):: self {
      local byList = stringToList(by),
      local aggBy = if std.length(byList) > 0 then std.format(' by (%s) ', [std.join(', ', byList)]) else '',
      local withoutList = stringToList(without),
      local aggWithout = if std.length(withoutList) > 0 then std.format(' without (%s) ', [std.join(', ', withoutList)]) else '',
      _statements+:: [{ type: 'agg', args: [func, by, without] }],
      _funcs+::
        if std.length(std.findSubstr('(', func)) > 0 then
          [func + ', %s)' + aggBy + aggWithout]
        else
          [func + aggBy + aggWithout + '(%s)']
    },
    sum(by=[], without=[]):: self._agg('sum', by, without),
    sum_by(by):: self.sum(by=by),
    sumBy(by):: self.sum(by=by),
    sum_without(without):: self.sum(without=without),
    sumWithout(without):: self.sum(without=without),
    avg(by=[], without=[]):: self._agg('avg', by, without),
    avg_by(by):: self.avg(by=by),
    avgBy(by):: self.avg(by=by),
    avg_without(without):: self.avg(without=without),
    avgWithout(without):: self.avg(without=without),
    min(by=[], without=[]):: self._agg('min', by, without),
    min_by(by):: self.min(by=by),
    minBy(by):: self.min(by=by),
    min_without(without):: self.min(without=without),
    minWithout(without):: self.min(without=without),
    max(by=[], without=[]):: self._agg('max', by, without),
    max_by(by):: self.max(by=by),
    maxBy(by):: self.max(by=by),
    max_without(without):: self.max(without=without),
    maxWithout(without):: self.max(without=without),
    stddev(by=[], without=[]):: self._agg('stddev', by, without),
    stddev_by(by):: self.stddev(by=by),
    stddevBy(by):: self.stddev(by=by),
    stddev_without(without):: self.stddev(without=without),
    stddevWithout(without):: self.stddev(without=without),
    stdvar(by=[], without=[]):: self._agg('stdvar', by, without),
    stdvar_by(by):: self.stdvar(by=by),
    stdvarBy(by):: self.stdvar(by=by),
    stdvar_without(without):: self.stdvar(without=without),
    stdvarWithout(without):: self.stdvar(without=without),
    count(by=[], without=[]):: self._agg('count', by, without),
    count_by(by):: self.count(by=by),
    countBy(by):: self.count(by=by),
    count_without(without):: self.count(without=without),
    countWithout(without):: self.count(without=without),
    // TODO: write tests for these
    topk(k, by=[], without=[]):: self._agg('topk(%s' % k, by, without),
    topk_by(k, by):: self.topk(k=k, by=by),
    topkBy(k, by):: self.topk(k=k, by=by),
    topk_without(k, without):: self.topk(k=k, without=without),
    topkWithout(k, without):: self.topk(k=k, without=without),
    bottomk(k, by=[], without=[]):: self._agg('bottomk(%s' % k, by, without),
    bottomk_by(k, by):: self.bottomk(k=k, by=by),
    bottomkBy(k, by):: self.bottomk(k=k, by=by),
    bottomk_without(k, without):: self.bottomk(k=k, without=without),
    bottomkWithout(k, without):: self.bottomk(k=k, without=without),
    sort(by=[], without=[]):: self._agg('sort', by, without),
    sort_by(by):: self.sort(by=by),
    sortBy(by):: self.sort(by=by),
    sort_without(without):: self.sort(without=without),
    sortWithout(without):: self.sort(without=without),
    sort_desc(by=[], without=[]):: self._agg('sort_desc', by, without),
    sort_desc_by(by):: self.sort_desc(by=by),
    sort_desc_without(without):: self.sort_desc(without=without),
    sortDesc(by=[], without=[]):: self.sort_desc(by=by, without=without),
    sortDescBy(by):: self.sort_desc(by=by),
    sortDescWithout(without):: self.sort_desc(without=without),

    // builds the query
    build(formatted=true)::
      local baseQuery = if !formatted then
        stripNewLines(self._labelExpr() + self._query)
      else
        self._labelExpr() + self._query;
      self.applyFunctions(baseQuery),
  },
}
