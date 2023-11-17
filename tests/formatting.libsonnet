local logql = import "../logql.libsonnet";

[
  [
    "it supports line_format()",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .line_format('{{.query}} {{.duration}}')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | line_format `{{.query}} {{.duration}}`'
  ],
  [
    "it supports lineFormat()",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .lineFormat('{{.query}} {{.duration}}')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | line_format `{{.query}} {{.duration}}`'
  ],
  [
    "it supports label_format()",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .label_format('response_size', '{{ .response_size | lower }}')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | label_format response_size=`{{ .response_size | lower }}`'
  ],
  [
    "it supports labelFormat()",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .labelFormat('response_size', '{{ .response_size | lower }}')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | label_format response_size=`{{ .response_size | lower }}`'
  ],
  [
    "it supports decolorize",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .decolorize()
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | decolorize'
  ],
  [
    "it supports dropping labels with dsl",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .drop([
        logql.new().label('level').noop().build(formatted=false),
        logql.new().label('request_method').eq('GET').build(formatted=false),
      ])
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | drop level, request_method==`GET`'
  ],
  [
    "it supports dropping labels with raw expression",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .drop([
        'level',
        'request_method==`GET`',
      ])
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | drop level, request_method==`GET`'
  ],
  [
    "it supports keeping labels with dsl",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .keep([
        logql.new().label('level').noop().build(formatted=false),
        logql.new().label('request_method').eq('GET').build(formatted=false),
      ])
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | keep level, request_method==`GET`'
  ],
  [
    "it supports keeping labels with raw expression",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .keep([
        'level',
        'request_method==`GET`',
      ])
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | keep level, request_method==`GET`'
  ],
]
