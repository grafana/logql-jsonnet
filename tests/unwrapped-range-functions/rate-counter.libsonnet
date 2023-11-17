local logql = import '../../logql.libsonnet';

[
  [
    "it supports rate_counter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate_counter('1m')
      .build(formatted=false),
    'rate_counter({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports rateCounter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rateCounter('1m')
      .build(formatted=false),
    'rate_counter({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports rate_counter with interval and resolution",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate_counter('1h', '5m')
      .build(formatted=false),
    'rate_counter({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports rateCounter with interval and resolution",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate_counter('1h', '5m')
      .build(formatted=false),
    'rate_counter({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports rateCounter with interval:resolution combined",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rateCounter('1h:5m')
      .build(formatted=false),
    'rate_counter({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports rate_counter with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate_counter(' [ 1h:5m]  ')
      .build(formatted=false),
    'rate_counter({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports rateCounter with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rateCounter(' [ 1h:5m]  ')
      .build(formatted=false),
    'rate_counter({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
]
