local logql = import '../logql.libsonnet';

[
  [
    "it supports label nanoseconds (ns) duration in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_time', '200ns')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_time > 200ns'
  ],
  [
    "it supports label microseconds (us) duration in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_time', '200us')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_time > 200us'
  ],
  [
    "it supports label microseconds (µs) duration in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_time', '200µs')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_time > 200µs'
  ],
  [
    "it supports label milliseconds (ms) duration in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_time', '200ms')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_time > 200ms'
  ],
  [
    "it supports label seconds (s) duration in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_time', '200s')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_time > 200s'
  ],
  [
    "it supports label hours (h) duration in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_time', '200h')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_time > 200h'
  ],
  [
    "it supports label days (d) duration in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_time', '1d')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_time > 1d'
  ],
]
