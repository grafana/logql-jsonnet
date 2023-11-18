# logql-jsonnet

A [Jsonnet](https://jsonnet.org/) based DSL for writing [LogQL](https://grafana.com/docs/loki/latest/query/) queries, inspired by [promql-jsonnet](https://github.com/satyanash/promql-jsonnet/tree/master). This is useful when creating grafana dashboards using [grafonnet](https://grafana.github.io/grafonnet/index.html). Instead of having to template strings manually, you can now use immutable builders to DRY out your LogQL queries.

## API Reference and LogQL Support

### Log Stream Selectors

[LogQL Stream Selector Documentation](https://grafana.com/docs/loki/latest/query/log_queries/#log-stream-selector)

| Function / Operation | Sample Usage | Description |
| :---------------- | :----------- | :----------- |
| `.withLabels(object)`   | `.withLabels({cluster: "primary",region: 'us-east-1'})` | Accepts an object using the key as the label and the value as the value of the predicate, only uses equality `=` |
| `.withLabel(label, op, value)`   | `.withLabel('region', '!=','us-east-1')` | Sets a single label selector, with specific arguments for the `label`, `op` and `value` |
| `.withLabel(object)`   | `.withLabel({label: 'region', op: '!=', value: 'us-east-1'})` | The method is overloaded, and also accepts a single object as an argument the keys `label`, `op` and `value`. |

#### Example Stream Selector Usage

```js
logql.new()
  .withLabels({
    app: 'ecommerce',
    cluster: "primary",
    region: 'us-east-1',
  })
  .build()

// renders
{app="ecommerce", cluster="primary", region="us-east-1"}
```

To support a more fluent api, a single method of `label()` is provided that returns an object of methods to chain from.

| Function / Operation | Sample Usage | Description |
| :---------------- | :----------- | :----------- |
| `.eq(value)` | `.label('region').eq('us-east-1')` | Generates a single label equality label selector |
| `.neq(value)` | `.label('region').neq('us-east-1')` | Generates a single label not equal label selector |
| `.re(value)` | `.label('region').re('us-east-1')` | Generates a single label regex matches label selector |
| `.nre(value)` | `.label('region').nre('us-east-1')` | Generates a single label not regex matches label selector |

#### Example Stream Selector Fluent Usage

```js
logql.new()
  .selector('app').eq('ecommerce')
  .selector('cluster').neq('primary')
  .selector('env').re('dev|test')
  .selector('region').nre('us-east-\\d+')
  .line().eq('error')
  .json()
  .build(formatted=false)

// renders
{app="ecommerce", cluster!="primary", env=~"dev|test", region!~"us-east-\\d+"}
```

### Log Line Filters

[LogQL Line Filter Documentation](https://grafana.com/docs/loki/latest/query/log_queries/#line-filter-expression)

| Function / Operation | Sample Usage | Description |
| :---------------- | :----------- | :----------- |
| `.lineEq(text)`   | `.lineEq('error')` | Filters a line to ensure that the line contains the specified text. |
| `.lineNeq(text)`   | `.lineNeq('error')` | Filters a line to ensure that the line does not contains the specified text. |
| `.lineRe(text)`   | `.lineRe('error')` | Filters a line to ensure that the line matches the specified regular expression. |
| `.lineNre(text)`   | `.lineNre('error')` | Filters a line to ensure that the line does not match the specified regular expression. |

#### Example Line Filter Usage

```js
logql.new()
  .withLabels({
    app: 'ecommerce',
    cluster: "primary",
    region: 'us-east-1',
  })
  .lineEq('error')
  .build()

// renders
{app="ecommerce", cluster="primary", region="us-east-1"}
|= `error`
```

To support a more fluent api, a single method of `line()` is provided that returns an object of methods to chain from.

| Function / Operation | Sample Usage | Description |
| :---------------- | :----------- | :----------- |
| `.eq(value)` | `line().eq('error')` | Generates a single line contains filter |
| `.neq(value)` | `line().neq('error')` | Generates a single line does not contains filter |
| `.re(value)` | `line().re('error')` | Generates a single line matches regular expression filter |
| `.nre(value)` | `line().nre('error')` |  Generates a single line does not matchregular expression filter |

#### Example Line Filter Fluent Usage

```js
logql.new()
  .selector('app').eq('ecommerce')
  .selector('cluster').eq('primary')
  .selector('env').eq('prod')
  .line().re('level=(error|warn)')
  .build()

// renders
{app="ecommerce", cluster!="primary", env="prod"}
|~ `level=(error|warn)`
```

### Parser Expressions

[LogQL Parser Documentation](https://grafana.com/docs/loki/latest/query/log_queries/#parser-expression)

| Function / Operation | Sample Usage | Description |
| :---------------- | :----------- | :----------- |
| `.json(labels?)`   | `.json()` | Parses the log line as `json`, optionally extracting specific values and assigning to a label. |
| `.logfmt(labels?)`   | `.logfmt()` | Parses the log line as `logfmt`, optionally extracting specific values and assigning to a label |
| `.pattern(pattern)`   | `.pattern('<_> level=<level> <_>')` | Parses the line using the `pattern` parser extracting values and assigning to labels |
| `.regex(pattern)`   | `.regex('.+ level=(?P<level>[^ ]+) .+')` | Parses the line using the `regex` parser extracting placeholder values and assigning to labels |

#### Example Parser Usage

```js
logql.new()
  .selector('app').eq('ecommerce')
  .selector('cluster').eq('primary')
  .selector('env').eq('prod')
  .line().re('level=(error|warn)')
  .json()
  .build()

// renders
{app="ecommerce", cluster!="primary", env="prod"}
|~ `level=(error|warn)`
| json
```

### Label Filter Expressions

[LogQL Label Filter Documentation](https://grafana.com/docs/loki/latest/query/log_queries/#label-filter-expression)

| Function / Operation | Sample Usage | Description |
| :---------------- | :----------- | :----------- |
| `.labelEq(label, value)`  | `.labelEq('status_code', 200)` | Performs an equal to check on a label and value. |
| `.labelNeq(label, value)` | `.labelNeq('status_code', 200)` | Performs a not equal to check on a label and value  |
| `.labelGt(label, value)`  | `.labelGt('status_code', 200)` | Performs a greater than check on a label and value |
| `.labelGte(label, value)` | `.labelGte('status_code', 200)` | Performs a greater than or equal to check on a label and value |
| `.labelLt(label, value)`  | `.labelLt('status_code', 200)` | Performs a less than check on a label and value |
| `.labelLte(label, value)` | `.labelLte('status_code', 200)` | Performs a less than or equal to check on label and value |
| `.labelRe(label, value)`  | `.labelRe('status_code', '2..')`  | Performs a regular expression match check on a label and value |
| `.labelNre(label, value)` | `.labelNre('status_code', '2..')` | Performs a regular expression does not match check on a label and value |
| `.labelNoop(label)` | `.labelNoop('status_code')` | Adds just the label with no check, mainly used in `drop` / `keep` |

#### Example Label Filter Usage

```js
logql.new()
  .withLabels({
    app: 'ecommerce',
    cluster: 'primary',
    env: 'prod',
  })
  .lineRe('level=(error|warn)')
  .json()
  .labelNeq('status_code', 200)
  .build()

// renders
{app="ecommerce", cluster!="primary", env="prod"}
|~ `level=(error|warn)`
| json
| status_code != 200
```

To support a more fluent api, a single method of `label(label)` is provided that returns an object of methods to chain from.

| Function / Operation | Sample Usage | Description |
| :---------------- | :----------- | :----------- |
| `.eq(value)`  | `.label('status_code').eq(200)`| Performs an equal to check on a label and value. |
| `.neq(value)` | `.label('status_code').neq(200)` | Performs a not equal to check on a label and value  |
| `.gt(value)`  | `.label('status_code').gt(200)`| Performs a greater than check on a label and value |
| `.gte(value)` | `.label('status_code').gte(200)` | Performs a greater than or equal to check on a label and value |
| `.lt(value)`  | `.label('status_code').lt(200)`| Performs a less than check on a label and value |
| `.lte(value)` | `.label('status_code').lte(200)` | Performs a less than or equal to check on label and value |
| `.re(value)`  | `.label('status_code').re('2..')`  | Performs a regular expression match check on a label and value |
| `.nre(value)` | `.label('status_code').nre('2..')` | Performs a regular expression does not match check on a label and value |
| `.noop()` | `.label('status_code').noop()` | Adds just the label with no check, mainly used in `drop` / `keep` |

#### Example Label Filter Fluent Usage

```js
logql.new()
  .selector('app').eq('ecommerce')
  .selector('cluster').eq('primary')
  .selector('env').eq('dev|test')
  .line().re('level=(error|warn)')
  .json()
  .label('status_code').neq(200)
  .build()

// renders
{app="ecommerce", cluster!="primary", env="prod"}
|~ `level=(error|warn)`
| json
| status_code != 200
```

### Logical Operator Expressions

| Function / Operation | Sample Usage | Description |
| :---------------- | :----------- | :----------- |
| `.and(exprs[])`  | `.and(['status_code == 200','response_time > 200ms'])` | Performs a logical `and` operation on the expressions |
| `.or(exprs[])` | `.or(['status_code == 200','response_time > 200ms'])` |  Performs a logical `or` operation on the expressions  |

#### Example Logical Operator Usage

```js
logql.new()
  .withLabels({
    app: 'ecommerce',
    cluster: "primary",
    region: 'us-east-1',
  })
  .json()
  .or([
    logql.new().labelEq('status_code', 500).build(),
    logql.new().labelGt('response_time', 100).build(),
    logql.new().labelGt('critical', true).build()
  ])
  .and([
    logql.new().labelEq('user', 'admin').build(),
    logql.new().labelNeq('method', 'GET').build()
  ])
  .build(formatted=false)

// renders
{app="ecommerce", cluster="primary", region="us-east-1"}
| json
| (status_code == 500 or response_time > 100 or critical > true) and (user == `admin` and method != `GET`)
```

### Formatting Expressions

[LogQL Formatting Documentation](https://grafana.com/docs/loki/latest/query/log_queries/#line-format-expression)

| Function / Operation | Sample Usage | Description |
| :---------------- | :----------- | :----------- |
| `.line_format(format)`  | `.line_format('{{ .request_method }}: {{ .status_code }}')` | Rewrites the log line content by using the [text/template](https://golang.org/pkg/text/template/) format |
| `.lineFormat(format)` | `.lineFormat('{{ .request_method }}: {{ .status_code }}')` | Wrapper for `.line_format()` |
| `.label_format(label, path)` | `.label_format('response_size', '{{ .response_size \| lower }}')` | Rename, modifies or adds labels |
| `.labelFormat(label, path)` | `.labelFormat('response_size', '{{ .response_size \| lower }}')` | Wrapper for `.label_format()` |
| `.decolorize()`  | `.decolorize()` | Strips ANSI sequences (color codes) from the line |
| `.drop(labels[])` | `.drop(['instance_id','host'])` | Drops one or more labels or labels with a conditional check |
| `.keep(labels[])`  | `.keep(['status_code', 'method', 'response_size', 'path'])` | Keeps one or more labels or labels with a conditional check, dropping all other labels |

#### Example Label Filter Usage

```js
logql.new()
  .selector('app').eq('ecommerce')
  .selector('cluster').eq('primary')
  .selector('env').eq('dev|test')
  .line().re('level=(error|warn)')
  .json()
  .label('status_code').neq(200)
  .decolorize()
  .line_format('{{ .request_method }}: {{ .status_code }} - {{ .path }}')
  .label_format('response_size', '{{ .response_size | lower }}')
  .keep([
    logql.new().label('instance').noop().build(),
    logql.new().label('level').noop().build(),
    logql.new().label('request_method').eq('GET').build(),
  ])
  .build()

// renders
{app="ecommerce", cluster="primary", env="dev|test"}
|~ `level=(error|warn)`
| json
| status_code != 200
| decolorize
| line_format `{{ .request_method }}: {{ .status_code }} - {{ .path }}`
| label_format response_size=`{{ .response_size | lower }}`
| keep instance, level, request_method==`GET`
```

### Range Aggregation Expressions

[LogQL Formatting Documentation](https://grafana.com/docs/loki/latest/query/metric_queries/#log-range-aggregations)

| Function / Operation | Sample Usage | Description |
| :---------------- | :----------- | :----------- |
| `.rate(interval, resolution?, offset?)`  | `.rate('5m')` | Calculates the number of entries per second |
| `.count_over_time(interval, resolution?, offset?)` | `.count_over_time('5m')` | Counts the entries for each log stream within the given range |
| `.countOverTime(interval, resolution?, offset?)` | `.countOverTime('5m')` | Wrapper for `.count_over_time()` |
| `.bytes_rate(interval, resolution?, offset?)`  | `.bytes_rate('5m')` | Calculates the number of bytes per second for each stream. |
| `.bytesRate(interval, resolution?, offset?)`  | `.bytesRate('5m')` | Wrapper for `.bytes_rate()` |
| `.bytes_over_time(interval, resolution?, offset?)` | `.bytes_over_time('5m')` | Counts the amount of bytes used by each log stream for a given range |
| `.bytesOverTime(interval, resolution?, offset?)` | `.bytesOverTime('5m')` | Wrapper for `.bytes_over_time()` |
| `.absent_over_time(interval, resolution?, offset?)`  | `.absent_over_time('5m')` | Returns an empty vector if the range vector passed to it has any elements and a 1-element vector with the value 1 if the range vector passed to it has no elements |
| `.absentOverTime(interval, resolution?, offset?)`  | `.absentOverTime('5m')` | Wrapper for `.absent_over_time()` |

#### Example Range Aggregation Usage

```js
logql.new()
  .selector('app').eq('ecommerce')
  .selector('cluster').eq('primary')
  .selector('env').eq('dev|test')
  .line().re('level=(error|warn)')
  .count_over_time('5m')
  .build()

// renders
count_over_time(
  {app="ecommerce", cluster="primary", env="dev|test"}
  |~ `level=(error|warn)` [5m]
)
```

### Unwrapped Range Aggregation Expressions

[LogQL Formatting Documentation](https://grafana.com/docs/loki/latest/query/metric_queries/#unwrapped-range-aggregations)

| Function / Operation | Sample Usage | Description |
| :---------------- | :----------- | :----------- |
| `.unwrap(label)`  | `.unwrap('response_bytes')` | Sets the label to unwrap for the aggregation. Unwrapped ranges uses extracted labels as sample values instead of log lines.  |
| `.unwrap_duration(label)` | `.unwrap_duration('response_time')` | Unwraps the label and converts the value from a [go duration format](https://golang.org/pkg/time/#ParseDuration) to seconds |
| `.unwrapDuration(label)` | `.unwrapDuration('response_time')` | Wrapper for `.unwrap_duration()` |
| `.unwrap_bytes(label)`  | `.unwrap_bytes('response_size')` | Unwraps the label and converts the value from a bytes unit to bytes |
| `.unwrapBytes(label)`  | `.unwrapBytes('response_size')` | Wrapper for `.unwrap_bytes()` |
| `.avg_over_time(interval, resolution?, offset?, by?, without?)` | `.avg_over_time('5m')` | Calculates the average value of all points in the specified interval. |
| `.avg_over_time_by(interval, by, resolution?, offset?)` | `.avg_over_time_by('5m', ['region', 'cluster'])` | Wrapper for `avg_over_time()` |
| `.avg_over_time_without(interval, without, resolution?, offset?)` | `.avg_over_time_without('5m', ['region', 'cluster'])` | Wrapper for `avg_over_time()` |
| `.avgOverTime(interval, resolution?, offset?, by?, without?)` | `.avgOverTime('5m')` | Wrapper for `avg_over_time()` |
| `.avgOverTimeBy(interval, by, resolution?, offset?)` | `.avgOverTimeBy('5m', ['region', 'cluster'])` | Wrapper for `avg_over_time()` |
| `.avgOverTimeWithout(interval, without, resolution?, offset?)` | `.avgOverTimeWithout('5m', ['region', 'cluster'])` | Wrapper for `avg_over_time()` |
| `.min_over_time(interval, resolution?, offset?, by?, without?)` | `.min_over_time('5m')` | Calculates the minimum value of all points in the specified interval |
| `.min_over_time_by(interval, by, resolution?, offset?)` | `.min_over_time_by('5m', ['region', 'cluster'])` | Wrapper for `min_over_time()` |
| `.min_over_time_without(interval, without, resolution?, offset?)` | `.min_over_time_without('5m', ['region', 'cluster'])` | Wrapper for `min_over_time()` |
| `.minOverTime(interval, resolution?, offset?, by?, without?)` | `.minOverTime('5m')` | Wrapper for `min_over_time()` |
| `.minOverTimeBy(interval, by, resolution?, offset?)` | `.minOverTimeBy('5m', ['region', 'cluster'])` | Wrapper for `min_over_time()` |
| `.minOverTimeWithout(interval, without, resolution?, offset?)` | `.minOverTimeWithout('5m', ['region', 'cluster'])` | Wrapper for `min_over_time()` |
| `.max_over_time(interval, resolution?, offset?, by?, without?)` | `.max_over_time('5m')` | Calculates the maximum value of all points in the specified interval. |
| `.max_over_time_by(interval, by, resolution?, offset?)` | `.max_over_time_by('5m', ['region', 'cluster'])` | Wrapper for `max_over_time()` |
| `.max_over_time_without(interval, without, resolution?, offset?)` | `.max_over_time_without('5m', ['region', 'cluster'])` | Wrapper for `max_over_time()` |
| `.maxOverTime(interval, resolution?, offset?, by?, without?)` | `.maxOverTime('5m')` | Wrapper for `max_over_time()` |
| `.maxOverTimeBy(interval, by, resolution?, offset?)` | `.maxOverTimeBy('5m', ['region', 'cluster'])` | Wrapper for `max_over_time()` |
| `.maxOverTimeWithout(interval, without, resolution?, offset?)` | `.maxOverTimeWithout('5m', ['region', 'cluster'])` | Wrapper for `max_over_time()` |
| `.first_over_time(interval, resolution?, offset?, by?, without?)` | `.first_over_time('5m')` | Calculates the first value of all points in the specified interval |
| `.first_over_time_by(interval, by, resolution?, offset?)` | `.first_over_time_by('5m', ['region', 'cluster'])` | Wrapper for `first_over_time()` |
| `.first_over_time_without(interval, without, resolution?, offset?)` | `.first_over_time_without('5m', ['region', 'cluster'])` | Wrapper for `first_over_time()` |
| `.firstOverTime(interval, resolution?, offset?, by?, without?)` | `.firstOverTime('5m')` | Wrapper for `first_over_time()` |
| `.firstOverTimeBy(interval, by, resolution?, offset?)` | `.firstOverTimeBy('5m', ['region', 'cluster'])` | Wrapper for `first_over_time()` |
| `.firstOverTimeWithout(interval, without, resolution?, offset?)` | `.firstOverTimeWithout('5m', ['region', 'cluster'])` | Wrapper for `first_over_time()` |
| `.last_over_time(interval, resolution?, offset?, by?, without?)` | `.last_over_time('5m')` | Calculates the last value of all points in the specified interval |
| `.last_over_time_by(interval, by, resolution?, offset?)` | `.last_over_time_by('5m', ['region', 'cluster'])` | Wrapper for `last_over_time()` |
| `.last_over_time_without(interval, without, resolution?, offset?)` | `.last_over_time_without('5m', ['region', 'cluster'])` | Wrapper for `last_over_time()` |
| `.lastOverTime(interval, resolution?, offset?, by?, without?)` | `.lastOverTime('5m')` | Wrapper for `last_over_time()` |
| `.lastOverTimeBy(interval, by, resolution?, offset?)` | `.lastOverTimeBy('5m', ['region', 'cluster'])` | Wrapper for `last_over_time()` |
| `.lastOverTimeWithout(interval, without, resolution?, offset?)` | `.lastOverTimeWithout('5m', ['region', 'cluster'])` | Wrapper for `last_over_time()` |
| `.rate_counter(interval, resolution?, offset?)` | `.rate_counter('5m')` | Calculates per second rate of the values in the specified interval and treating them as "counter metric" |
| `.rateCounter(interval, resolution?, offset?)` | `.rate_counter('5m')` | c |
| `.stdvar_over_time(interval, resolution?, offset?, by?, without?)` | `.stdvar_over_time('5m', ['region', 'cluster'])` | Calculates the population standard variance of the values in the specified interval. |
Wrapper for `stdvar_over_time()` |
| `.stdvar_over_time_without(interval, without, resolution?, offset?)` | `.stdvar_over_time_without('5m', ['region', 'cluster'])` | Wrapper for `stdvar_over_time()` |
| `.stdvarOverTime(interval, resolution?, offset?, by?, without?)` | `.stdvarOverTime('5m')` | Wrapper for `stdvar_over_time()` |
| `.stdvarOverTimeBy(interval, by, resolution?, offset?)` | `.stdvarOverTimeBy('5m', ['region', 'cluster'])` | Wrapper for `stdvar_over_time()` |
| `.stdvarOverTimeWithout(interval, without, resolution?, offset?)` | `.stdvarOverTimeWithout('5m', ['region', 'cluster'])` | Wrapper for `stdvar_over_time()` |
| `.stddev_over_time(interval, resolution?, offset?, by?, without?)` | `.stddev_over_time('5m')` | Calculates the population standard deviation of the values in the specified interval. |
| `.stddev_over_time_by(interval, by, resolution?, offset?)` | `.stddev_over_time_by('5m', ['region', 'cluster'])` | Wrapper for `stddev_over_time()` |
| `.stddev_over_time_without(interval, without, resolution?, offset?)` | `.stddev_over_time_without('5m', ['region', 'cluster'])` | Wrapper for `stddev_over_time()` |
| `.stddevOverTime(interval, resolution?, offset?, by?, without?)` | `.stddevOverTime('5m')` | Wrapper for `stddev_over_time()` |
| `.stddevOverTimeBy(interval, by, resolution?, offset?)` | `.stddevOverTimeBy('5m', ['region', 'cluster'])` | Wrapper for `stddev_over_time()` |
| `.stddevOverTimeWithout(interval, without, resolution?, offset?)` | `.stddevOverTimeWithout('5m', ['region', 'cluster'])` | Wrapper for `stddev_over_time()` |
| `.quantile_over_time(quantile, interval, resolution?, offset?, by?, without?)` | `.quantile_over_time('0.95', '5m')` | Calculates the φ-quantile (0 ≤ φ ≤ 1) of the values in the specified interval. |
| `.quantile_over_time_by(quantile, interval, by, resolution?, offset?)` | `.quantile_over_time_by('0.95', '5m', ['region', 'cluster'])` | Wrapper for `quantile_over_time()` |
| `.quantile_over_time_without(quantile, interval, without, resolution?, offset?)` | `.quantile_over_time_without('0.95', '5m', ['region', 'cluster'])` | Wrapper for `quantile_over_time()` |
| `.quantileOverTime(quantile, interval, resolution?, offset?, by?, without?)` | `.quantileOverTime('0.95', '5m')` | Wrapper for `quantile_over_time()` |
| `.quantileOverTimeBy(quantile, interval, by, resolution?, offset?)` | `.quantileOverTimeBy('0.95', '5m', ['region', 'cluster'])` | Wrapper for `quantile_over_time()` |
| `.quantileOverTimeWithout(quantile, interval, without, resolution?, offset?)` | `.quantileOverTimeWithout('0.95', '5m', ['region', 'cluster'])` | Wrapper for `quantile_over_time()` |

#### Example Unwrapped Range Aggregation Usage

```js
logql.new()
  .selector('app').eq('ecommerce')
  .selector('cluster').eq('primary')
  .selector('env').eq('dev|test')
  .line().re('level=(error|warn)')
  .count_over_time('5m')
  .build()

// renders
avg_over_time(
  {app="ecommerce", cluster="primary", region="us-east-1"}
  |= `error`
  | logfmt
  | unwrap bytes(response_size) [1h:5m]
) by (cluster, region)
```

### Aggregation Expressions

[LogQL Formatting Documentation](https://grafana.com/docs/loki/latest/query/metric_queries/#built-in-aggregation-operators)

| Function / Operation | Sample Usage | Description |
| :---------------- | :----------- | :----------- |
| `.sum(by?, without?)` |  `.sum()` | Calculate sum over labels |
| `.sum_by(by)` |  `.sumBy(['cluster', 'region'])` | Wrapper for `sum(by=[])` |
| `.sumBy(by)` |  `.sumBy(['cluster', 'region'])` | Wrapper for `sum(by=[])` |
| `.sum_without(without)` |  `.sumWithout(['cluster', 'region')` | Wrapper for `sum(without=[])` |
| `.sumWithout(without)` |  `.sumWithout(['cluster', 'region')` | Wrapper for `sum(without=[])` |
| `.avg(by?, without?)` |  `.avg()` | Calculate the average over labels |
| `.avg_by(by)` |  `.avgBy(['cluster', 'region')` | Wrapper for `avg(by=[])` |
| `.avgBy(by)` |  `.avgBy(['cluster', 'region')` | Wrapper for `avg(by=[])` |
| `.avg_without(without)` |  `.avgWithout(['cluster', 'region')` | Wrapper for `avg(without=[])` |
| `.avgWithout(without)` |  `.avgWithout(['cluster', 'region')` | Wrapper for `avg(without=[])` |
| `.min(by?, without?)` |  `.min()` |  Select minimum over labels |
| `.min_by(by)` |  `.minBy(['cluster', 'region')` | Wrapper for `min(by=[])` |
| `.minBy(by)` |  `.minBy(['cluster', 'region')` | Wrapper for `min(by=[])` |
| `.min_without(without)` |  `.minWithout(['cluster', 'region')` | Wrapper for `min(without=[])` |
| `.minWithout(without)` |  `.minWithout(['cluster', 'region')` | Wrapper for `min(without=[])` |
| `.max(by?, without?)` |  `.max()` | Select maximum over labels |
| `.max_by(by)` |  `.maxBy(['cluster', 'region')` | Wrapper for `max(by=[])` |
| `.maxBy(by)` |  `.maxBy(['cluster', 'region')` | Wrapper for `max(by=[])` |
| `.max_without(without)` |  `.maxWithout(['cluster', 'region')` | Wrapper for `max(without=[])` |
| `.maxWithout(without)` |  `.maxWithout(['cluster', 'region')` | Wrapper for `max(without=[])` |
| `.stddev(by?, without?)` |  `.stddev()` | Calculate the population standard deviation over labels |
| `.stddev_by(by)` |  `.stddevBy(['cluster', 'region')` | Wrapper for `stddev(by=[])` |
| `.stddevBy(by)` |  `.stddevBy(['cluster', 'region')` | Wrapper for `stddev(by=[])` |
| `.stddev_without(without)` |  `.stddevWithout(['cluster', 'region')` | Wrapper for `stddev(without=[])` |
| `.stddevWithout(without)` |  `.stddevWithout(['cluster', 'region')` | Wrapper for `stddev(without=[])` |
| `.stdvar(by?, without?)` |  `.stdvar()` | Calculate the population standard variance over labels |
| `.stdvar_by(by)` |  `.stdvarBy(['cluster', 'region')` | Wrapper for `stdvar(by=[])` |
| `.stdvarBy(by)` |  `.stdvarBy(['cluster', 'region')` | Wrapper for `stdvar(by=[])` |
| `.stdvar_without(without)` |  `.stdvarWithout(['cluster', 'region')` | Wrapper for `stdvar(without=[])` |
| `.stdvarWithout(without)` |  `.stdvarWithout(['cluster', 'region')` | Wrapper for `stdvar(without=[])` |
| `.count(by?, without?)` |  `.count()` | Count number of elements in the vector |
| `.count_by(by)` |  `.countBy(['cluster', 'region')` | Wrapper for `count(by=[])` |
| `.countBy(by)` |  `.countBy(['cluster', 'region')` | Wrapper for `count(by=[])` |
| `.count_without(without)` |  `.countWithout(['cluster', 'region')` | Wrapper for `count(without=[])` |
| `.countWithout(without)` |  `.countWithout(['cluster', 'region')` | Wrapper for `count(without=[])` |
| `.topk(k, by?, without?)` |  `.topk(10)` | Select largest k elements by sample value |
| `.topk_by(k, by)` |  `.topk_by(10, ['region'])` | Wrapper for `.topk(k, by=[])` |
| `.topkBy(k, by)` |  `.topkBy(10, ['region'])` | Wrapper for `.topk(k, by=[])` |
| `.topk_without(k, without)` |  `.topk_without(10, ['region'])` | Wrapper for `.topk(k, without=[])` |
| `.topkWithout(k, without)` |  `.topkWithout(10, ['region'])` | Wrapper for `.topk(k, without=[])` |
| `.bottomk(k, by?, without?)` |  `.bottomk(10)` | Select smallest k elements by sample value |
| `.bottomk_by(k, by)` |  `.bottomk_by(10, ['region'])` | Wrapper for `.bottomk(k, by=[])` |
| `.bottomkBy(k, by)` |  `.bottomkBy(10, ['region'])` | Wrapper for `.bottomk(k, by=[])` |
| `.bottomk_without(k, without)` |  `.bottomk_without(10, ['region'])` | Wrapper for `.bottomk(k, without=[])` |
| `.bottomkWithout(k, without)` |  `.bottomkWithout(10, ['region'])` | Wrapper for `.bottomk(k, without=[])` |
| `.sort(by?, without?)` |  `.sort()` | returns vector elements sorted by their sample values, in ascending order. |
| `.sort_by(by)` |  `.sort_by(['region', 'cluster'])` | Wrapper for `.sort(by=[])` |
| `.sortBy(by)` |  `.sortBy(['region', 'cluster'])` |  Wrapper for `.sort(by=[])` |
| `.sort_without(without)` |  `.sort_without(['region', 'cluster'])` | `.sort(without=[])` |
| `.sortWithout(without)` |  `.sortWithout(['region', 'cluster'])` | `.sort(without=[])` |
| `.sort_desc(by?, without?)` |  `.sort_desc()` | Same as sort, but sorts in descending order. |
| `.sortDesc(by?, without?)` |  `.sortDesc()` | Wrapper for `.sort_desc()` |
| `.sort_desc_by(by)` |  `.sort_desc_by(['region', 'cluster'])` | Wrapper for `.sort_desc(by=[])` |
| `.sortDescBy(by)` |  `sortDescBy(['region', 'cluster'])` | Wrapper for `.sort_desc(by=[])` |
| `.sort_desc_without(without)` |  `.sort_desc_without(['region', 'cluster'])` | Wrapper for `.sort_desc(without=[])` |
| `.sortDescWithout(without)` |  `.sortDescWithout(['region', 'cluster'])` | Wrapper for `.sort_desc(without=[])` |

#### Example Unwrapped Range Aggregation Usage

```js
logql.new()
  .selector('app').eq('ecommerce')
  .selector('cluster').eq('primary')
  .selector('env').eq('dev|test')
  .line().re('level=(error|warn)')
  .count_over_time('5m')
  .build()

// renders
sort_desc(
  sum by (region, cluster) (
    count_over_time(
      {app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]
    )
  )
)
```
