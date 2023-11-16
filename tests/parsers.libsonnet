local logql = import "../logql.libsonnet";

[
  [
    "it supports json parser",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .json()
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | json'
  ],
  [
    "it supports logfmt parser",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt'
  ],
  [
    "it supports pattern parser",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .pattern('<_><status_code><_>')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | pattern `<_><status_code><_>`'
  ],
  [
    "it supports regex parser",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .regex('.+"status":(?P<status_code>[^,]+')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | regex `.+"status":(?P<status_code>[^,]+`'
  ],
]
