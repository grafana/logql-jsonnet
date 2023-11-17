local logql = import '../../logql.libsonnet';

[
  [
    "it supports bytes_rate",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .bytes_rate('1m')
      .build(formatted=false),
    'bytes_rate({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m])'
  ],
  [
    "it supports bytes_rate with interval and resolution",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .bytes_rate('1h', '5m')
      .build(formatted=false),
    'bytes_rate({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports bytes_rate with interval:resolution combined",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .bytes_rate('1h:5m')
      .build(formatted=false),
    'bytes_rate({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports bytes_rate with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .bytes_rate(' [ 1h:5m]  ')
      .build(formatted=false),
    'bytes_rate({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
]
