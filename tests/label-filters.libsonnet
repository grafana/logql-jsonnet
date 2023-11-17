local logql = import "../logql.libsonnet";

[
  [
    "it supports labelEq filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelEq('status_code', 200)
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code == 200'
  ],
  [
    "it supports label eq filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .label('status_code').eq(200)
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code == 200'
  ],
  [
    "it supports labelNeq filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelNeq('status_code', 200)
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code != 200'
  ],
  [
    "it supports label neq filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .label('status_code').neq(200)
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code != 200'
  ],
  [
    "it supports labelGt filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('status_code', 200)
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code > 200'
  ],
  [
    "it supports label gt filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .label('status_code').gt(200)
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code > 200'
  ],
  [
    "it supports labelGte filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGte('status_code', 200)
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code >= 200'
  ],
  [
    "it supports label gte filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .label('status_code').gte(200)
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code >= 200'
  ],
  [
    "it supports labelLt filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelLt('status_code', 200)
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code < 200'
  ],
  [
    "it supports label lt filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .label('status_code').lt(200)
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code < 200'
  ],
  [
    "it supports labelLte filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelLte('status_code', 200)
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code <= 200'
  ],
  [
    "it supports label lte filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .label('status_code').lte(200)
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code <= 200'
  ],
  [
    "it supports labelRe (regex) matches filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelRe('status_code', '2..')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code =~ `2..`'
  ],
  [
    "it supports label re (regex) matches filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .label('status_code').re('2..')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code =~ `2..`'
  ],
  [
    "it supports labelNre (not regex) matches filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelNre('status_code', '2..')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code !~ `2..`'
  ],
  [
    "it supports label nre (not regex) matches filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .label('status_code').nre('2..')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | status_code !~ `2..`'
  ],
  [
    "it supports label ns duration in filter",
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
    "it supports label us duration in filter",
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
    "it supports label µs duration in filter",
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
    "it supports label ms duration in filter",
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
    "it supports label s duration in filter",
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
    "it supports label h duration in filter",
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
    "it supports label d duration in filter",
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
  [
    "it supports label bytes in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200b')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200b'
  ],
  [
    "it supports label kb in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200kb')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200kb'
  ],
  [
    "it supports label kib in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200kib')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200kib'
  ],
  [
    "it supports label mb in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200mb')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200mb'
  ],
  [
    "it supports label mib in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200mib')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200mib'
  ],
  [
    "it supports label gb in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200gb')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200gb'
  ],
  [
    "it supports label gib in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200gib')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200gib'
  ],
  [
    "it supports label tb in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200tb')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200tb'
  ],
  [
    "it supports label tib in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200tib')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200tib'
  ],
  [
    "it supports label pb in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200pb')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200pb'
  ],
  [
    "it supports label pib in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200pib')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200pib'
  ],
  [
    "it supports label eb in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200eb')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200eb'
  ],
  [
    "it supports label eib in filter",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .json()
      .labelGt('response_size', '200eib')
      .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} | json | response_size > 200eib'
  ],
]
