local logql = import '../../logql.libsonnet';

[
  [
    'it supports stdvar aggregation',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .stdvar()
    .build(formatted=false),
    'stdvar(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports stdvar by aggregation with single value',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .stdvarBy('env')
    .build(formatted=false),
    'stdvar by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports stdvar by aggregation with multiple values',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .stdvarBy('env, namespace')
    .build(formatted=false),
    'stdvar by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports stdvar by aggregation with single value',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .stdvarWithout('env')
    .build(formatted=false),
    'stdvar without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports stdvar by aggregation with multiple values',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .stdvarWithout('env, namespace')
    .build(formatted=false),
    'stdvar without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
]
