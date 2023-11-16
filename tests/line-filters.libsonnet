local logql = import "../logql.libsonnet";

[
  [
    "it supports line eq filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error`'
  ],
  [
    "it supports line neq filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineNeq('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} != `error`'
  ],
  [
    "it supports line regex matches filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineRe('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |~ `error`'
  ],
  [
    "it supports line regex not matches filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineNre('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} !~ `error`'
  ],
]
