local logql = import "../logql.libsonnet";

[
  [
    "it supports lineEq filter",
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
    "it supports line eq filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error`'
  ],
  [
    "it supports lineNeq filter",
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
    "it supports line neq filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().neq('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} != `error`'
  ],
  [
    "it supports lineRe (regex) matches filter",
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
    "it supports line re (regex) matches filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().re('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |~ `error`'
  ],
  [
    "it supports lineNre (regex not) matches filter",
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
  [
    "it supports line nre (regex not) matches filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().nre('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} !~ `error`'
  ],
]
