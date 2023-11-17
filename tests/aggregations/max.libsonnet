local logql = import '../../logql.libsonnet';

[
  [
    "it supports max aggregation",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .max()
      .build(formatted=false),
    'max(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports max by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .maxBy('env')
      .build(formatted=false),
    'max by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports max by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .maxBy('env, namespace')
      .build(formatted=false),
    'max by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports max by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .maxWithout('env')
      .build(formatted=false),
    'max without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports max by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .maxWithout('env, namespace')
      .build(formatted=false),
    'max without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
]
