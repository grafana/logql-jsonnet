local logql = import '../logql.libsonnet';

[
  [
    'it supports unwrap',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrap('response_size')
    .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap response_size',
  ],
  [
    'it supports unwrap_duration',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrap_duration('response_time')
    .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap duration_seconds(response_time)',
  ],
  [
    'it supports unwrapDuration',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrapDuration('response_time')
    .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap duration_seconds(response_time)',
  ],
  [
    'it supports unwrap_bytes',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrap_bytes('response_size')
    .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size)',
  ],
  [
    'it supports unwrapBytes',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .unwrapBytes('response_size')
    .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size)',
  ],
]
