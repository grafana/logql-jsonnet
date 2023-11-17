local logql = import '../logql.libsonnet';

[
  [
    "it supports lineEq filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .lineEq('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error`'
  ],
  [
    "it supports line eq filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error`'
  ],
  [
    "it supports lineNeq filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .lineNeq('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} != `error`'
  ],
  [
    "it supports line neq filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().neq('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} != `error`'
  ],
  [
    "it supports lineRe (regex) matches filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .lineRe('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |~ `error`'
  ],
  [
    "it supports line re (regex) matches filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().re('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |~ `error`'
  ],
  [
    "it supports lineNre (regex not) matches filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .lineNre('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} !~ `error`'
  ],
  [
    "it supports line nre (regex not) matches filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().nre('error')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} !~ `error`'
  ],
]
