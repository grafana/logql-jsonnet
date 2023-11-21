local logql = import '../../logql.libsonnet';

[
  [
    'it supports last_over_time',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrapBytes('response_size')
    .last_over_time('1m')
    .build(formatted=false),
    'last_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])',
  ],
  [
    'it supports lastOverTime',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrapBytes('response_size')
    .lastOverTime('1m')
    .build(formatted=false),
    'last_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])',
  ],
  [
    'it supports last_over_time with interval and resolution',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrapBytes('response_size')
    .last_over_time('1h', '5m')
    .build(formatted=false),
    'last_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])',
  ],
  [
    'it supports lastOverTime with interval and resolution',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrapBytes('response_size')
    .lastOverTime('1h', '5m')
    .build(formatted=false),
    'last_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])',
  ],
  [
    'it supports last_over_time with interval:resolution combined',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrapBytes('response_size')
    .last_over_time('1h:5m')
    .build(formatted=false),
    'last_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])',
  ],
  [
    'it supports lastOverTime with interval:resolution combined',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrapBytes('response_size')
    .lastOverTime('1h:5m')
    .build(formatted=false),
    'last_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])',
  ],
  [
    'it supports last_over_time with interval:resolution combined with bad formatting',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrapBytes('response_size')
    .last_over_time(' [ 1h:5m]  ')
    .build(formatted=false),
    'last_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])',
  ],
  [
    'it supports lastOverTime with interval:resolution combined with bad formatting',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrapBytes('response_size')
    .lastOverTime(' [ 1h:5m]  ')
    .build(formatted=false),
    'last_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])',
  ],
]
