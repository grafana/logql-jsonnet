local logql = import '../../logql.libsonnet';

[
  [
    'it supports sum aggregation',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .sum()
    .build(formatted=false),
    'sum(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports sum by aggregation with single value',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .sumBy('env')
    .build(formatted=false),
    'sum by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports sum by aggregation with multiple values',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .sumBy('env, namespace')
    .build(formatted=false),
    'sum by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports sum by aggregation with single value',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .sumWithout('env')
    .build(formatted=false),
    'sum without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports sum by aggregation with multiple values',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .sumWithout('env, namespace')
    .build(formatted=false),
    'sum without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
]
