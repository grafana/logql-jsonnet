local logql = import "../logql.libsonnet";

[
  [
    "it supports withLabels",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"}'
  ],
]
