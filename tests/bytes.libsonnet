local logql = import '../logql.libsonnet';

[
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
