local logql = import "../logql.libsonnet";

[
  [
    "it supports rate",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate('1m')
      .build(formatted=false),
    'rate({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports rate with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate('1h', '5m')
      .build(formatted=false),
    'rate({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports rate with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate('1h:5m')
      .build(formatted=false),
    'rate({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports rate with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate(' [ 1h:5m]  ')
      .build(formatted=false),
    'rate({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports count_over_time",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .count_over_time('1m')
      .build(formatted=false),
    'count_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` [1m])'
  ],
  [
    "it supports count_over_time with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .count_over_time('1h', '5m')
      .build(formatted=false),
    'count_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports count_over_time with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .count_over_time('1h:5m')
      .build(formatted=false),
    'count_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports count_over_time with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .count_over_time(' [ 1h:5m]  ')
      .build(formatted=false),
    'count_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports bytes_rate",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .bytes_rate('1m')
      .build(formatted=false),
    'bytes_rate({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` [1m])'
  ],
  [
    "it supports bytes_rate with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .bytes_rate('1h', '5m')
      .build(formatted=false),
    'bytes_rate({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports bytes_rate with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .bytes_rate('1h:5m')
      .build(formatted=false),
    'bytes_rate({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports bytes_rate with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .bytes_rate(' [ 1h:5m]  ')
      .build(formatted=false),
    'bytes_rate({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports bytes_over_time",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .bytes_over_time('1m')
      .build(formatted=false),
    'bytes_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` [1m])'
  ],
  [
    "it supports bytes_over_time with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .bytes_over_time('1h', '5m')
      .build(formatted=false),
    'bytes_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports bytes_over_time with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .bytes_over_time('1h:5m')
      .build(formatted=false),
    'bytes_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports bytes_over_time with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .bytes_over_time(' [ 1h:5m]  ')
      .build(formatted=false),
    'bytes_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports absent_over_time",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrap('response_size')
      .absent_over_time('1m')
      .build(formatted=false),
    'absent_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap response_size [1m])'
  ],
  [
    "it supports absent_over_time with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .absent_over_time('1h', '5m')
      .build(formatted=false),
    'absent_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports absent_over_time with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .absent_over_time('1h:5m')
      .build(formatted=false),
    'absent_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports absent_over_time with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .absent_over_time(' [ 1h:5m]  ')
      .build(formatted=false),
    'absent_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
]