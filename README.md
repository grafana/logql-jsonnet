# logql-jsonnet

<!-- markdownlint-disable MD033 MD013 -->
<p align="center">
  <a href="https://grafana.com/products/cloud/logs/">
    <img height="20" src="https://img.shields.io/badge/grafana-loki-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white" alt="Grafana Loki">
  </a>
  <a href="http://jsonnet.org">
    <img src="https://img.shields.io/badge/jsonnet--lib-logql-blue" alt="jsonnet library: logql">
  </a>
  <a href="https://github.com/bentonam/logql-jsonnet/actions/workflows/lint.yaml">
    <img height="20" src="https://github.com/bentonam/logql-jsonnet/actions/workflows/lint.yaml/badge.svg" alt="Lint">
  </a>
  <a href="https://github.com/bentonam/logql-jsonnet/commits/main">
    <img alt="GitHub last commit (branch)" src="https://img.shields.io/github/last-commit/bentonam/logql-jsonnet/main">
  </a>
  <a href="https://raw.githubusercontent.com/bentonam/logql-jsonnet/main/LICENSE" alt="Contributors">
    <img src="https://img.shields.io/github/license/bentonam/logql-jsonnet" alt="License">
  </a>
  <a href="https://github.com/bentonam/logql-jsonnet/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/bentonam/logql-jsonnet" alt="Contributors">
  </a>
  <a href="https://github.com/bentonam/logql-jsonnet/releases">
    <img src="https://img.shields.io/github/v/release/bentonam/logql-jsonnet" alt="GitHub release">
  </a>
</p>
<!-- markdownlint-enable MD033 MD013 -->

A [Jsonnet](https://jsonnet.org/) based DSL for writing [LogQL](https://grafana.com/docs/loki/latest/query/) queries, inspired by
[promql-jsonnet](https://github.com/satyanash/promql-jsonnet/tree/master). This is useful when creating Grafana dashboards using
[grafonnet](https://grafana.github.io/grafonnet/index.html). Instead of having to template strings manually, you can now use
immutable builders to DRY out your LogQL queries.

## API Reference and LogQL Support

### Log Stream Selectors

[LogQL Stream Selector Documentation](https://grafana.com/docs/loki/latest/query/log_queries/#log-stream-selector)

| Operation | Description |
| :---------------- | :----------- |
| `.withLabels(object)`   | Accepts an object using the key as the label and the value as the value of the predicate, only uses equality `=` <br>Usage: `.withLabels({cluster: "primary",region: 'us-east-1'})` |
| `.withLabel(label, op, value)`   | Sets a single label selector, with specific arguments for the `label`, `op` and `value` <br>Usage: `.withLabel('region', '!=','us-east-1')` |
| `.withLabel(object)`   | The method is overloaded, and also accepts a single object as an argument the keys `label`, `op` and `value`. <br>Usage: `.withLabel({label: 'region', op: '!=', value: 'us-east-1'})` |

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

To support a more fluent API, a single method of `selector()` is provided that returns an object of methods to chain from.

| Operation | Description |
| :---------------- | :----------- |
| `.eq(value)` | Generates a single label equality label selector <br>Usage: `.selector('region').eq('us-east-1')` |
| `.neq(value)` | Generates a single label not equal label selector <br>Usage: `.selector('region').neq('us-east-1')` |
| `.re(value)` | Generates a single label regular expression matches label selector <br>Usage: `.selector('region').re('us-east-1')` |
| `.nre(value)` | Generates a single label not regular expression matches label selector <br>Usage: `.selector('region').nre('us-east-1')` |

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

| Operation | Description |
| :---------------- | :----------- |
| `.lineEq(text)`   | Filters a line to ensure that the line contains the specified text. <br>Usage: `.lineEq('error')` |
| `.lineNeq(text)`   | Filters a line to ensure that the line does not contains the specified text. <br>Usage: `.lineNeq('error')` |
| `.lineRe(text)`   | Filters a line to ensure that the line matches the specified regular expression. <br>Usage: `.lineRe('error')` |
| `.lineNre(text)`   | Filters a line to ensure that the line does not match the specified regular expression. <br>Usage: `.lineNre('error')` |

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

To support a more fluent API, a single method of `line()` is provided that returns an object of methods to chain from.

| Operation | Description |
| :---------------- | :----------- |
| `.eq(value)` | Generates a single line contains filter <br>Usage: `line().eq('error')` |
| `.neq(value)` | Generates a single line does not contains filter <br>Usage: `line().neq('error')` |
| `.re(value)` | Generates a single line matches regular expression filter <br>Usage: `line().re('error')` |
| `.nre(value)` |  Generates a single line does not matchregular expression filter <br>Usage: `line().nre('error')` |

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

| Operation | Description |
| :---------------- | :----------- |
| `.json(labels?)`   | Parses the log line as `json`, optionally extracting specific values and assigning to a label. <br>Usage: `.json()` |
| `.logfmt(labels?)`   | Parses the log line as `logfmt`, optionally extracting specific values and assigning to a label <br>Usage: `.logfmt()` |
| `.pattern(pattern)`   | Parses the line using the `pattern` parser extracting values and assigning to labels <br>Usage: `.pattern('<_> level=<level> <_>')` |
| `.regex(pattern)`   | Parses the line using the `regex` parser extracting placeholder values and assigning to labels <br>Usage: `.regex('.+ level=(?P<level>[^ ]+) .+')` |

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

| Operation | Description |
| :---------------- | :----------- |
| `.labelEq(label, value)` | Performs an equal to check on a label and value. <br>Usage: `.labelEq('status_code', 200)` |
| `.labelNeq(label, value)` | Performs a not equal to check on a label and value  <br>Usage: `.labelNeq('status_code', 200)` |
| `.labelGt(label, value)` | Performs a greater than check on a label and value <br>Usage: `.labelGt('status_code', 200)` |
| `.labelGte(label, value)` | Performs a greater than or equal to check on a label and value <br>Usage: `.labelGte('status_code', 200)` |
| `.labelLt(label, value)` | Performs a less than check on a label and value <br>Usage: `.labelLt('status_code', 200)` |
| `.labelLte(label, value)` | Performs a less than or equal to check on label and value <br>Usage: `.labelLte('status_code', 200)` |
| `.labelRe(label, value)` | Performs a regular expression match check on a label and value <br>Usage: `.labelRe('status_code', '2..')` |
| `.labelNre(label, value)` | Performs a regular expression does not match check on a label and value <br>Usage: `.labelNre('status_code', '2..')` |
| `.labelNoop(label)` | Adds just the label with no check, mainly used in `drop` / `keep` <br>Usage: `.labelNoop('status_code')` |

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

To support a more fluent API, a single method of `label(label)` is provided that returns an object of methods to chain from.

| Operation | Description |
| :---------------- | :----------- |
| `.eq(value)` | Performs an equal to check on a label and value. <br>Usage: `.label('status_code').eq(200)` |
| `.neq(value)` | Performs a not equal to check on a label and value  <br>Usage: `.label('status_code').neq(200)` |
| `.gt(value)` | Performs a greater than check on a label and value <br>Usage: `.label('status_code').gt(200)` |
| `.gte(value)` | Performs a greater than or equal to check on a label and value <br>Usage: `.label('status_code').gte(200)` |
| `.lt(value)` | Performs a less than check on a label and value <br>Usage: `.label('status_code').lt(200)` |
| `.lte(value)` | Performs a less than or equal to check on label and value <br>Usage: `.label('status_code').lte(200)` |
| `.re(value)` | Performs a regular expression match check on a label and value <br>Usage: `.label('status_code').re('2..')` |
| `.nre(value)` | Performs a regular expression does not match check on a label and value <br>Usage: `.label('status_code').nre('2..')` |
| `.noop()` | Adds just the label with no check, mainly used in `drop` / `keep` <br>Usage: `.label('status_code').noop()` |

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

| Operation | Description |
| :---------------- | :----------- |
| `.and(exprs[])` | Performs a logical `and` operation on the expressions <br>Usage: `.and(['status_code == 200','response_time > 200ms'])` |
| `.or(exprs[])` |  Performs a logical `or` operation on the expressions  <br>Usage: `.or(['status_code == 200','response_time > 200ms'])` |

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

| Operation | Description |
| :---------------- | :----------- |
| `.line_format(format)` | Rewrites the log line content by using the [text/template](https://golang.org/pkg/text/template/) format <br>Usage: `.line_format('{{ .request_method }}: {{ .status_code }}')` |
| `.lineFormat(format)` | Wrapper for `.line_format()` <br>Usage: `.lineFormat('{{ .request_method }}: {{ .status_code }}')` |
| `.labelFormat(label, path)` | Wrapper for `.label_format()` <br>Usage: `.labelFormat('response_size', '{{ .response_size \| lower }}')` |
| `.decolorize()` | Strips ANSI sequences (color codes) from the line <br>Usage: `.decolorize()` |
| `.drop(labels[])` | Drops one or more labels or labels with a conditional check <br>Usage: `.drop(['instance_id','host'])` |
| `.keep(labels[])` | Keeps one or more labels or labels with a conditional check, dropping all other labels <br>Usage: `.keep(['status_code', 'method', 'response_size', 'path'])` |

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

| Operation | Description |
| :---------------- | :----------- |
| `.rate(interval, resolution?, offset?)` | Calculates the number of entries per second <br>Usage: `.rate('5m')` |
| `.count_over_time(interval, resolution?, offset?)` | Counts the entries for each log stream within the given range <br>Usage: `.count_over_time('5m')` |
| `.countOverTime(interval, resolution?, offset?)` | Wrapper for `.count_over_time()` <br>Usage: `.countOverTime('5m')` |
| `.bytes_rate(interval, resolution?, offset?)` | Calculates the number of bytes per second for each stream. <br>Usage: `.bytes_rate('5m')` |
| `.bytesRate(interval, resolution?, offset?)` | Wrapper for `.bytes_rate()` <br>Usage: `.bytesRate('5m')` |
| `.bytes_over_time(interval, resolution?, offset?)` | Counts the amount of bytes used by each log stream for a given range <br>Usage: `.bytes_over_time('5m')` |
| `.bytesOverTime(interval, resolution?, offset?)` | Wrapper for `.bytes_over_time()` <br>Usage: `.bytesOverTime('5m')` |
| `.absent_over_time(interval, resolution?, offset?)` | Returns an empty vector if the range vector passed to it has any elements and a 1-element vector with the value 1 if the range vector passed to it has no elements <br>Usage: `.absent_over_time('5m')` |
| `.absentOverTime(interval, resolution?, offset?)` | Wrapper for `.absent_over_time()` <br>Usage: `.absentOverTime('5m')` |

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

| Operation | Description |
| :---------------- | :----------- |
| `.unwrap(label)` | Sets the label to unwrap for the aggregation. Unwrapped ranges uses extracted labels as sample values instead of log lines.  <br>Usage: `.unwrap('response_bytes')` |
| `.unwrap_duration(label)` | Unwraps the label and converts the value from a [go duration format](https://golang.org/pkg/time/#ParseDuration) to seconds <br>Usage: `.unwrap_duration('response_time')` |
| `.unwrapDuration(label)` | Wrapper for `.unwrap_duration()` <br>Usage: `.unwrapDuration('response_time')` |
| `.unwrap_bytes(label)` | Unwraps the label and converts the value from a bytes unit to bytes <br>Usage: `.unwrap_bytes('response_size')` |
| `.unwrapBytes(label)` | Wrapper for `.unwrap_bytes()` <br>Usage: `.unwrapBytes('response_size')` |
| `.avg_over_time(interval, resolution?, offset?, by?, without?)` | Calculates the average value of all points in the specified interval. <br>Usage: `.avg_over_time('5m')` |
| `.avg_over_time_by(interval, by, resolution?, offset?)` | Wrapper for `avg_over_time()` <br>Usage: `.avg_over_time_by('5m', ['region', 'cluster'])` |
| `.avg_over_time_without(interval, without, resolution?, offset?)` | Wrapper for `avg_over_time()` <br>Usage: `.avg_over_time_without('5m', ['region', 'cluster'])` |
| `.avgOverTime(interval, resolution?, offset?, by?, without?)` | Wrapper for `avg_over_time()` <br>Usage: `.avgOverTime('5m')` |
| `.avgOverTimeBy(interval, by, resolution?, offset?)` | Wrapper for `avg_over_time()` <br>Usage: `.avgOverTimeBy('5m', ['region', 'cluster'])` |
| `.avgOverTimeWithout(interval, without, resolution?, offset?)` | Wrapper for `avg_over_time()` <br>Usage: `.avgOverTimeWithout('5m', ['region', 'cluster'])` |
| `.min_over_time(interval, resolution?, offset?, by?, without?)` | Calculates the minimum value of all points in the specified interval <br>Usage: `.min_over_time('5m')` |
| `.min_over_time_by(interval, by, resolution?, offset?)` | Wrapper for `min_over_time()` <br>Usage: `.min_over_time_by('5m', ['region', 'cluster'])` |
| `.min_over_time_without(interval, without, resolution?, offset?)` | Wrapper for `min_over_time()` <br>Usage: `.min_over_time_without('5m', ['region', 'cluster'])` |
| `.minOverTime(interval, resolution?, offset?, by?, without?)` | Wrapper for `min_over_time()` <br>Usage: `.minOverTime('5m')` |
| `.minOverTimeBy(interval, by, resolution?, offset?)` | Wrapper for `min_over_time()` <br>Usage: `.minOverTimeBy('5m', ['region', 'cluster'])` |
| `.minOverTimeWithout(interval, without, resolution?, offset?)` | Wrapper for `min_over_time()` <br>Usage: `.minOverTimeWithout('5m', ['region', 'cluster'])` |
| `.max_over_time(interval, resolution?, offset?, by?, without?)` | Calculates the maximum value of all points in the specified interval. <br>Usage: `.max_over_time('5m')` |
| `.max_over_time_by(interval, by, resolution?, offset?)` | Wrapper for `max_over_time()` <br>Usage: `.max_over_time_by('5m', ['region', 'cluster'])` |
| `.max_over_time_without(interval, without, resolution?, offset?)` | Wrapper for `max_over_time()` <br>Usage: `.max_over_time_without('5m', ['region', 'cluster'])` |
| `.maxOverTime(interval, resolution?, offset?, by?, without?)` | Wrapper for `max_over_time()` <br>Usage: `.maxOverTime('5m')` |
| `.maxOverTimeBy(interval, by, resolution?, offset?)` | Wrapper for `max_over_time()` <br>Usage: `.maxOverTimeBy('5m', ['region', 'cluster'])` |
| `.maxOverTimeWithout(interval, without, resolution?, offset?)` | Wrapper for `max_over_time()` <br>Usage: `.maxOverTimeWithout('5m', ['region', 'cluster'])` |
| `.first_over_time(interval, resolution?, offset?, by?, without?)` | Calculates the first value of all points in the specified interval <br>Usage: `.first_over_time('5m')` |
| `.first_over_time_by(interval, by, resolution?, offset?)` | Wrapper for `first_over_time()` <br>Usage: `.first_over_time_by('5m', ['region', 'cluster'])` |
| `.first_over_time_without(interval, without, resolution?, offset?)` | Wrapper for `first_over_time()` <br>Usage: `.first_over_time_without('5m', ['region', 'cluster'])` |
| `.firstOverTime(interval, resolution?, offset?, by?, without?)` | Wrapper for `first_over_time()` <br>Usage: `.firstOverTime('5m')` |
| `.firstOverTimeBy(interval, by, resolution?, offset?)` | Wrapper for `first_over_time()` <br>Usage: `.firstOverTimeBy('5m', ['region', 'cluster'])` |
| `.firstOverTimeWithout(interval, without, resolution?, offset?)` | Wrapper for `first_over_time()` <br>Usage: `.firstOverTimeWithout('5m', ['region', 'cluster'])` |
| `.last_over_time(interval, resolution?, offset?, by?, without?)` | Calculates the last value of all points in the specified interval <br>Usage: `.last_over_time('5m')` |
| `.last_over_time_by(interval, by, resolution?, offset?)` | Wrapper for `last_over_time()` <br>Usage: `.last_over_time_by('5m', ['region', 'cluster'])` |
| `.last_over_time_without(interval, without, resolution?, offset?)` | Wrapper for `last_over_time()` <br>Usage: `.last_over_time_without('5m', ['region', 'cluster'])` |
| `.lastOverTime(interval, resolution?, offset?, by?, without?)` | Wrapper for `last_over_time()` <br>Usage: `.lastOverTime('5m')` |
| `.lastOverTimeBy(interval, by, resolution?, offset?)` | Wrapper for `last_over_time()` <br>Usage: `.lastOverTimeBy('5m', ['region', 'cluster'])` |
| `.lastOverTimeWithout(interval, without, resolution?, offset?)` | Wrapper for `last_over_time()` <br>Usage: `.lastOverTimeWithout('5m', ['region', 'cluster'])` |
| `.rate_counter(interval, resolution?, offset?)` | Calculates per second rate of the values in the specified interval and treating them as "counter metric" <br>Usage: `.rate_counter('5m')` |
| `.rateCounter(interval, resolution?, offset?)` | c <br>Usage: `.rate_counter('5m')` |
| `.stdvar_over_time(interval, resolution?, offset?, by?, without?)` | Calculates the population standard variance of the values in the specified interval. <br>Usage: `.stdvar_over_time('5m', ['region', 'cluster'])` |
Wrapper for `stdvar_over_time()` |
| `.stdvar_over_time_without(interval, without, resolution?, offset?)` | Wrapper for `stdvar_over_time()` <br>Usage: `.stdvar_over_time_without('5m', ['region', 'cluster'])` |
| `.stdvarOverTime(interval, resolution?, offset?, by?, without?)` | Wrapper for `stdvar_over_time()` <br>Usage: `.stdvarOverTime('5m')` |
| `.stdvarOverTimeBy(interval, by, resolution?, offset?)` | Wrapper for `stdvar_over_time()` <br>Usage: `.stdvarOverTimeBy('5m', ['region', 'cluster'])` |
| `.stdvarOverTimeWithout(interval, without, resolution?, offset?)` | Wrapper for `stdvar_over_time()` <br>Usage: `.stdvarOverTimeWithout('5m', ['region', 'cluster'])` |
| `.stddev_over_time(interval, resolution?, offset?, by?, without?)` | Calculates the population standard deviation of the values in the specified interval. <br>Usage: `.stddev_over_time('5m')` |
| `.stddev_over_time_by(interval, by, resolution?, offset?)` | Wrapper for `stddev_over_time()` <br>Usage: `.stddev_over_time_by('5m', ['region', 'cluster'])` |
| `.stddev_over_time_without(interval, without, resolution?, offset?)` | Wrapper for `stddev_over_time()` <br>Usage: `.stddev_over_time_without('5m', ['region', 'cluster'])` |
| `.stddevOverTime(interval, resolution?, offset?, by?, without?)` | Wrapper for `stddev_over_time()` <br>Usage: `.stddevOverTime('5m')` |
| `.stddevOverTimeBy(interval, by, resolution?, offset?)` | Wrapper for `stddev_over_time()` <br>Usage: `.stddevOverTimeBy('5m', ['region', 'cluster'])` |
| `.stddevOverTimeWithout(interval, without, resolution?, offset?)` | Wrapper for `stddev_over_time()` <br>Usage: `.stddevOverTimeWithout('5m', ['region', 'cluster'])` |
| `.quantile_over_time(quantile, interval, resolution?, offset?, by?, without?)` | Calculates the φ-quantile (0 ≤ φ ≤ 1) of the values in the specified interval. <br>Usage: `.quantile_over_time('0.95', '5m')` |
| `.quantile_over_time_by(quantile, interval, by, resolution?, offset?)` | Wrapper for `quantile_over_time()` <br>Usage: `.quantile_over_time_by('0.95', '5m', ['region', 'cluster'])` |
| `.quantile_over_time_without(quantile, interval, without, resolution?, offset?)` | Wrapper for `quantile_over_time()` <br>Usage: `.quantile_over_time_without('0.95', '5m', ['region', 'cluster'])` |
| `.quantileOverTime(quantile, interval, resolution?, offset?, by?, without?)` | Wrapper for `quantile_over_time()` <br>Usage: `.quantileOverTime('0.95', '5m')` |
| `.quantileOverTimeBy(quantile, interval, by, resolution?, offset?)` | Wrapper for `quantile_over_time()` <br>Usage: `.quantileOverTimeBy('0.95', '5m', ['region', 'cluster'])` |
| `.quantileOverTimeWithout(quantile, interval, without, resolution?, offset?)` | Wrapper for `quantile_over_time()` <br>Usage: `.quantileOverTimeWithout('0.95', '5m', ['region', 'cluster'])` |

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

| Operation | Description |
| :---------------- | :----------- |
| `.sum(by?, without?)` | Calculate sum over labels <br>Usage:  `.sum()` |
| `.sum_by(by)` | Wrapper for `sum(by=[])` <br>Usage:  `.sumBy(['cluster', 'region'])` |
| `.sumBy(by)` | Wrapper for `sum(by=[])` <br>Usage:  `.sumBy(['cluster', 'region'])` |
| `.sum_without(without)` | Wrapper for `sum(without=[])` <br>Usage:  `.sumWithout(['cluster', 'region')` |
| `.sumWithout(without)` | Wrapper for `sum(without=[])` <br>Usage:  `.sumWithout(['cluster', 'region')` |
| `.avg(by?, without?)` | Calculate the average over labels <br>Usage:  `.avg()` |
| `.avg_by(by)` | Wrapper for `avg(by=[])` <br>Usage:  `.avgBy(['cluster', 'region')` |
| `.avgBy(by)` | Wrapper for `avg(by=[])` <br>Usage:  `.avgBy(['cluster', 'region')` |
| `.avg_without(without)` | Wrapper for `avg(without=[])` <br>Usage:  `.avgWithout(['cluster', 'region')` |
| `.avgWithout(without)` | Wrapper for `avg(without=[])` <br>Usage:  `.avgWithout(['cluster', 'region')` |
| `.min(by?, without?)` |  Select minimum over labels <br>Usage:  `.min()` |
| `.min_by(by)` | Wrapper for `min(by=[])` <br>Usage:  `.minBy(['cluster', 'region')` |
| `.minBy(by)` | Wrapper for `min(by=[])` <br>Usage:  `.minBy(['cluster', 'region')` |
| `.min_without(without)` | Wrapper for `min(without=[])` <br>Usage:  `.minWithout(['cluster', 'region')` |
| `.minWithout(without)` | Wrapper for `min(without=[])` <br>Usage:  `.minWithout(['cluster', 'region')` |
| `.max(by?, without?)` | Select maximum over labels <br>Usage:  `.max()` |
| `.max_by(by)` | Wrapper for `max(by=[])` <br>Usage:  `.maxBy(['cluster', 'region')` |
| `.maxBy(by)` | Wrapper for `max(by=[])` <br>Usage:  `.maxBy(['cluster', 'region')` |
| `.max_without(without)` | Wrapper for `max(without=[])` <br>Usage:  `.maxWithout(['cluster', 'region')` |
| `.maxWithout(without)` | Wrapper for `max(without=[])` <br>Usage:  `.maxWithout(['cluster', 'region')` |
| `.stddev(by?, without?)` | Calculate the population standard deviation over labels <br>Usage:  `.stddev()` |
| `.stddev_by(by)` | Wrapper for `stddev(by=[])` <br>Usage:  `.stddevBy(['cluster', 'region')` |
| `.stddevBy(by)` | Wrapper for `stddev(by=[])` <br>Usage:  `.stddevBy(['cluster', 'region')` |
| `.stddev_without(without)` | Wrapper for `stddev(without=[])` <br>Usage:  `.stddevWithout(['cluster', 'region')` |
| `.stddevWithout(without)` | Wrapper for `stddev(without=[])` <br>Usage:  `.stddevWithout(['cluster', 'region')` |
| `.stdvar(by?, without?)` | Calculate the population standard variance over labels <br>Usage:  `.stdvar()` |
| `.stdvar_by(by)` | Wrapper for `stdvar(by=[])` <br>Usage:  `.stdvarBy(['cluster', 'region')` |
| `.stdvarBy(by)` | Wrapper for `stdvar(by=[])` <br>Usage:  `.stdvarBy(['cluster', 'region')` |
| `.stdvar_without(without)` | Wrapper for `stdvar(without=[])` <br>Usage:  `.stdvarWithout(['cluster', 'region')` |
| `.stdvarWithout(without)` | Wrapper for `stdvar(without=[])` <br>Usage:  `.stdvarWithout(['cluster', 'region')` |
| `.count(by?, without?)` | Count number of elements in the vector <br>Usage:  `.count()` |
| `.count_by(by)` | Wrapper for `count(by=[])` <br>Usage:  `.countBy(['cluster', 'region')` |
| `.countBy(by)` | Wrapper for `count(by=[])` <br>Usage:  `.countBy(['cluster', 'region')` |
| `.count_without(without)` | Wrapper for `count(without=[])` <br>Usage:  `.countWithout(['cluster', 'region')` |
| `.countWithout(without)` | Wrapper for `count(without=[])` <br>Usage:  `.countWithout(['cluster', 'region')` |
| `.topk(k, by?, without?)` | Select largest k elements by sample value <br>Usage:  `.topk(10)` |
| `.topk_by(k, by)` | Wrapper for `.topk(k, by=[])` <br>Usage:  `.topk_by(10, ['region'])` |
| `.topkBy(k, by)` | Wrapper for `.topk(k, by=[])` <br>Usage:  `.topkBy(10, ['region'])` |
| `.topk_without(k, without)` | Wrapper for `.topk(k, without=[])` <br>Usage:  `.topk_without(10, ['region'])` |
| `.topkWithout(k, without)` | Wrapper for `.topk(k, without=[])` <br>Usage:  `.topkWithout(10, ['region'])` |
| `.bottomk(k, by?, without?)` | Select smallest k elements by sample value <br>Usage:  `.bottomk(10)` |
| `.bottomk_by(k, by)` | Wrapper for `.bottomk(k, by=[])` <br>Usage:  `.bottomk_by(10, ['region'])` |
| `.bottomkBy(k, by)` | Wrapper for `.bottomk(k, by=[])` <br>Usage:  `.bottomkBy(10, ['region'])` |
| `.bottomk_without(k, without)` | Wrapper for `.bottomk(k, without=[])` <br>Usage:  `.bottomk_without(10, ['region'])` |
| `.bottomkWithout(k, without)` | Wrapper for `.bottomk(k, without=[])` <br>Usage:  `.bottomkWithout(10, ['region'])` |
| `.sort(by?, without?)` | returns vector elements sorted by their sample values, in ascending order. <br>Usage:  `.sort()` |
| `.sort_by(by)` | Wrapper for `.sort(by=[])` <br>Usage:  `.sort_by(['region', 'cluster'])` |
| `.sortBy(by)` |  Wrapper for `.sort(by=[])` <br>Usage:  `.sortBy(['region', 'cluster'])` |
| `.sort_without(without)` | `.sort(without=[])` <br>Usage:  `.sort_without(['region', 'cluster'])` |
| `.sortWithout(without)` | `.sort(without=[])` <br>Usage:  `.sortWithout(['region', 'cluster'])` |
| `.sort_desc(by?, without?)` | Same as sort, but sorts in descending order. <br>Usage:  `.sort_desc()` |
| `.sortDesc(by?, without?)` | Wrapper for `.sort_desc()` <br>Usage:  `.sortDesc()` |
| `.sort_desc_by(by)` | Wrapper for `.sort_desc(by=[])` <br>Usage:  `.sort_desc_by(['region', 'cluster'])` |
| `.sortDescBy(by)` | Wrapper for `.sort_desc(by=[])` <br>Usage:  `sortDescBy(['region', 'cluster'])` |
| `.sort_desc_without(without)` | Wrapper for `.sort_desc(without=[])` <br>Usage:  `.sort_desc_without(['region', 'cluster'])` |
| `.sortDescWithout(without)` | Wrapper for `.sort_desc(without=[])` <br>Usage:  `.sortDescWithout(['region', 'cluster'])` |

#### Example Aggregations Usage

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
