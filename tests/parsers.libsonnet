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
      .lineEq('error')
      .json()
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} !~ `error` | json'
  ],
  [
    "it supports logfmt parser",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .logfmt()
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} !~ `error` | logfmt'
  ],
  [
    "it supports logfmt parser",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .pattern('<_><status_code><_>')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} !~ `error` | pattern `<_><status_code><_>`'
  ],
  [
    "it supports logfmt parser",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .regex('.+"status":(?P<status_code>[^,]+')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} !~ `error` | pattern `<_><status_code><_>`'
  ],
]
