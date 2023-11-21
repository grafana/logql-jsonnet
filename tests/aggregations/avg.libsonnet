local logql = import '../../logql.libsonnet';

[
  [
    'it supports avg aggregation',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .avg()
    .build(formatted=false),
    'avg(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports avg by aggregation with single value',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .avgBy('env')
    .build(formatted=false),
    'avg by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports avg by aggregation with multiple values',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .avgBy('env, namespace')
    .build(formatted=false),
    'avg by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports avg by aggregation with single value',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .avgWithout('env')
    .build(formatted=false),
    'avg without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports avg by aggregation with multiple values',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .avgWithout('env, namespace')
    .build(formatted=false),
    'avg without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
]
