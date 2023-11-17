local logql = import '../../logql.libsonnet';

[
  [
    "it supports min aggregation",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .min()
      .build(formatted=false),
    'min(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports min by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .minBy('env')
      .build(formatted=false),
    'min by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports min by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .minBy('env, namespace')
      .build(formatted=false),
    'min by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports min by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .minWithout('env')
      .build(formatted=false),
    'min without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports min by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .minWithout('env, namespace')
      .build(formatted=false),
    'min without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
]
