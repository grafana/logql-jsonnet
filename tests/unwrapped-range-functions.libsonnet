local logql = import "../logql.libsonnet";

[
  [
    "it supports rate_counter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate_counter('1m')
      .build(formatted=false),
    'rate_counter({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports rate_counter with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate_counter('1h', '5m')
      .build(formatted=false),
    'rate_counter({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports rate_counter with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate_counter('1h:5m')
      .build(formatted=false),
    'rate_counter({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports rate_counter with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .rate_counter(' [ 1h:5m]  ')
      .build(formatted=false),
    'rate_counter({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports sum_over_time",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .sum_over_time('1m')
      .build(formatted=false),
    'sum_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports sum_over_time with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .sum_over_time('1h', '5m')
      .build(formatted=false),
    'sum_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports sum_over_time with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .sum_over_time('1h:5m')
      .build(formatted=false),
    'sum_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports sum_over_time with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .sum_over_time(' [ 1h:5m]  ')
      .build(formatted=false),
    'sum_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports avg_over_time",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .avg_over_time('1m')
      .build(formatted=false),
    'avg_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports avg_over_time with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .avg_over_time('1h', '5m')
      .build(formatted=false),
    'avg_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports avg_over_time with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .avg_over_time('1h:5m')
      .build(formatted=false),
    'avg_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports avg_over_time with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .avg_over_time(' [ 1h:5m]  ')
      .build(formatted=false),
    'avg_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports min_over_time",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .min_over_time('1m')
      .build(formatted=false),
    'min_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports min_over_time with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .min_over_time('1h', '5m')
      .build(formatted=false),
    'min_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports min_over_time with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .min_over_time('1h:5m')
      .build(formatted=false),
    'min_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports min_over_time with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .min_over_time(' [ 1h:5m]  ')
      .build(formatted=false),
    'min_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports max_over_time",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .max_over_time('1m')
      .build(formatted=false),
    'max_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports max_over_time with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .max_over_time('1h', '5m')
      .build(formatted=false),
    'max_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports max_over_time with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .max_over_time('1h:5m')
      .build(formatted=false),
    'max_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports max_over_time with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .max_over_time(' [ 1h:5m]  ')
      .build(formatted=false),
    'max_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports first_over_time",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .first_over_time('1m')
      .build(formatted=false),
    'first_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports first_over_time with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .first_over_time('1h', '5m')
      .build(formatted=false),
    'first_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports first_over_time with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .first_over_time('1h:5m')
      .build(formatted=false),
    'first_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports first_over_time with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .first_over_time(' [ 1h:5m]  ')
      .build(formatted=false),
    'first_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports last_over_time",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .last_over_time('1m')
      .build(formatted=false),
    'last_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports last_over_time with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .last_over_time('1h', '5m')
      .build(formatted=false),
    'last_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports last_over_time with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .last_over_time('1h:5m')
      .build(formatted=false),
    'last_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports last_over_time with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .last_over_time(' [ 1h:5m]  ')
      .build(formatted=false),
    'last_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports stdvar_over_time",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .stdvar_over_time('1m')
      .build(formatted=false),
    'stdvar_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports stdvar_over_time with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .stdvar_over_time('1h', '5m')
      .build(formatted=false),
    'stdvar_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports stdvar_over_time with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .stdvar_over_time('1h:5m')
      .build(formatted=false),
    'stdvar_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports stdvar_over_time with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .stdvar_over_time(' [ 1h:5m]  ')
      .build(formatted=false),
    'stdvar_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports stddev_over_time",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .stddev_over_time('1m')
      .build(formatted=false),
    'stddev_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports stddev_over_time with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .stddev_over_time('1h', '5m')
      .build(formatted=false),
    'stddev_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports stddev_over_time with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .stddev_over_time('1h:5m')
      .build(formatted=false),
    'stddev_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports stddev_over_time with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .stddev_over_time(' [ 1h:5m]  ')
      .build(formatted=false),
    'stddev_over_time({app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports quantile_over_time",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .quantile_over_time('0.95', '1m')
      .build(formatted=false),
    'quantile_over_time(0.95, {app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1m])'
  ],
  [
    "it supports quantile_over_time with interval and resolution",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .quantile_over_time('0.95', '1h', '5m')
      .build(formatted=false),
    'quantile_over_time(0.95, {app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports quantile_over_time with interval:resolution combined",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .quantile_over_time('0.95', '1h:5m')
      .build(formatted=false),
    'quantile_over_time(0.95, {app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
  [
    "it supports quantile_over_time with interval:resolution combined with bad formatting",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .line().eq('error')
      .logfmt()
      .unwrapBytes('response_size')
      .quantile_over_time('0.95', ' [ 1h:5m]  ')
      .build(formatted=false),
    'quantile_over_time(0.95, {app="ecommerce", cluster="prod", region="us-east-1"} |= `error` | logfmt | unwrap bytes(response_size) [1h:5m])'
  ],
]
