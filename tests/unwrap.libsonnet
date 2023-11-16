local logql = import "../logql.libsonnet";

[
  [
    "it supports unwrap",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrap('response_size')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap response_size'
  ],
  [
    "it supports unwrap with duration seconds",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapDuration('response_time')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap duration_seconds(response_time)'
  ],
  [
    "it supports unwrap with bytes",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size)'
  ],
]
