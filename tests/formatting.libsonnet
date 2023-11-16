local logql = import "../logql.libsonnet";

[
  [
    "it supports line format",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .logfmt()
      .line_format('{{.query}} {{.duration}}')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | line_format `{{.query}} {{.duration}}`'
  ],
  [
    "it supports line format",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .logfmt()
      .label_format('response_size', '{{ .response_size | lower }}')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | label_format response_size=`{{ .response_size | lower }}`'
  ],
  [
    "it supports dropping labels with dsl",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .logfmt()
      .drop([
        logql.new().label('level').build(formatted=false),
        logql.new().labelEq('request_method', 'GET').build(formatted=false),
      ])
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | drop level, request_method=`GET`'
  ],
  [
    "it supports dropping labels with raw expression",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .logfmt()
      .drop([
        'level',
        'request_method=`GET`',
      ])
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | drop level, request_method=`GET`'
  ],
  [
    "it supports keeping labels with dsl",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .logfmt()
      .keep([
        logql.new().label('level').build(formatted=false),
        logql.new().labelEq('request_method', 'GET').build(formatted=false),
      ])
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | keep level, request_method=`GET`'
  ],
  [
    "it supports keeping labels with raw expression",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .logfmt()
      .keep([
        'level',
        'request_method=`GET`',
      ])
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | keep level, request_method=`GET`'
  ],
]
