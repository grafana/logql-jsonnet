local logql = import '../../logql.libsonnet';

[
  [
    "it supports count aggregation",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .count()
      .build(formatted=false),
    'count(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports count by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .countBy('env')
      .build(formatted=false),
    'count by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports count by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .countBy('env, namespace')
      .build(formatted=false),
    'count by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports count by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .countWithout('env')
      .build(formatted=false),
    'count without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports count by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .countWithout('env, namespace')
      .build(formatted=false),
    'count without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
]
