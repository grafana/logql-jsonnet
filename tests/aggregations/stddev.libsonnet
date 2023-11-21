local logql = import '../../logql.libsonnet';

[
  [
    'it supports stddev aggregation',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .stddev()
    .build(formatted=false),
    'stddev(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports stddev by aggregation with single value',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .stddevBy('env')
    .build(formatted=false),
    'stddev by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports stddev by aggregation with multiple values',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .stddevBy('env, namespace')
    .build(formatted=false),
    'stddev by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports stddev by aggregation with single value',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .stddevWithout('env')
    .build(formatted=false),
    'stddev without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
  [
    'it supports stddev by aggregation with multiple values',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .count_over_time('1m')
    .stddevWithout('env, namespace')
    .build(formatted=false),
    'stddev without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))',
  ],
]
