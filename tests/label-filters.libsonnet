local logql = import "../logql.libsonnet";

[
  [
    "it supports label eq filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelEq('status_code', 200)
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | status_code == 200'
  ],
  [
    "it supports label neq filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelNeq('status_code', 200)
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | status_code != 200'
  ],
  [
    "it supports label gt filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('status_code', 200)
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | status_code > 200'
  ],
  [
    "it supports label gte filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGte('status_code', 200)
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | status_code >= 200'
  ],
  [
    "it supports label lt filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelLt('status_code', 200)
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | status_code < 200'
  ],
  [
    "it supports label lte filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelLte('status_code', 200)
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | status_code <= 200'
  ],
  [
    "it supports label regex matches filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelRe('status_code', '2..')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | status_code =~ `2..`'
  ],
  [
    "it supports label regex matches filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelNre('status_code', '2..')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | status_code !~ `2..`'
  ],
  [
    "it supports label ns duration in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_time', '200ns')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_time > 200ns'
  ],
  [
    "it supports label us duration in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_time', '200us')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_time > 200us'
  ],
  [
    "it supports label µs duration in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_time', '200µs')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_time > 200µs'
  ],
  [
    "it supports label ms duration in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_time', '200ms')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_time > 200ms'
  ],
  [
    "it supports label s duration in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_time', '200s')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_time > 200s'
  ],
  [
    "it supports label h duration in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_time', '200h')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_time > 200h'
  ],
  [
    "it supports label d duration in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_time', '1d')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_time > 1d'
  ],
  [
    "it supports label bytes in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200b')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200b'
  ],
  [
    "it supports label kb in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200kb')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200kb'
  ],
  [
    "it supports label kib in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200kib')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200kib'
  ],
  [
    "it supports label mb in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200mb')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200mb'
  ],
  [
    "it supports label mib in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200mib')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200mib'
  ],
  [
    "it supports label gb in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200gb')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200gb'
  ],
  [
    "it supports label gib in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200gib')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200gib'
  ],
  [
    "it supports label tb in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200tb')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200tb'
  ],
  [
    "it supports label tib in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200tib')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200tib'
  ],
  [
    "it supports label pb in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200pb')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200pb'
  ],
  [
    "it supports label pib in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200pib')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200pib'
  ],
  [
    "it supports label eb in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200eb')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200eb'
  ],
  [
    "it supports label eib in filter",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .labelGt('response_size', '200eib')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | response_size > 200eib'
  ],
]
