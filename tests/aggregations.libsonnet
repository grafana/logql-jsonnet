local logql = import "../logql.libsonnet";

[
  [
    "it supports sum aggregation",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate('1m')
      .sum()
      .build(formatted=false),
    'sum(rate({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m]))'
  ],
  [
    "it supports sum by aggregation",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate('1m')
      .sumBy('team')
      .build(formatted=false),
    'sum by(team) (rate({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m]))'
  ],
  [
    "it supports sum without aggregation",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .lineEq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate('1m')
      .sumWithout('team')
      .build(formatted=false),
    'sum without(team) (rate({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m]))'
  ],
]
