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
| `.eq(value)` | `label('region').eq('us-east-1')` | Generates a single label equality label selector |
| `.neq(value)` | `label('region').neq('us-east-1')` | Generates a single label not equal label selector |
| `.re(value)` | `label('region').re('us-east-1')` | Generates a single label regex matches label selector |
| `.nre(value)` | `label('region').nre('us-east-1')` | Generates a single label not regex matches label selector |

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
| `.label_format(label, path)` | `.label_format('response_size', '{{ .response_size | lower }}')` | Rename, modifies or adds labels |
| `.labelFormat(label, path)` | `.labelFormat('response_size', '{{ .response_size | lower }}')` | Wrapper for `.label_format()` |
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
| `.rate(interval, resolution?)`  | `.rate('5m')` | Calculates the number of entries per second |
| `.count_over_time(interval, resolution?)` | `.count_over_time('5m')` | Counts the entries for each log stream within the given range |
| `.bytes_rate(interval, resolution?)`  | `.bytes_rate('5m')` | Calculates the number of bytes per second for each stream. |
| `.bytes_over_time(interval, resolution?)` | `.bytes_over_time('5m')` | Counts the amount of bytes used by each log stream for a given range |
| `.absent_over_time(interval, resolution?)`  | `.absent_over_time('5m')` | Returns an empty vector if the range vector passed to it has any elements and a 1-element vector with the value 1 if the range vector passed to it has no elements |

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
| `.unwrapDuration(label)` | `.unwrapDuration('response_time')` | Unwraps the label and converts the value from a [go duration format](https://golang.org/pkg/time/#ParseDuration) to seconds |
| `.unwrapBytes(label)`  | `.unwrapBytes('response_size')` | Unwraps the label and converts the value from a bytes unit to bytes |
| `.bytes_over_time(interval, resolution?)` | `.bytes_over_time('5m')` | Counts the amount of bytes used by each log stream for a given range |
