local logql = import "../logql.libsonnet";

[
  [
    "it supports complex logical and as well as or using dsl",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .json()
      .or([
        logql.new().labelEq('status_code', 500).build(false),
        logql.new().labelGt('response_time', 100).build(false),
        logql.new().labelGt('critical', true).build(false)
      ])
      .and([
        logql.new().labelEq('user', 'admin').build(false),
        logql.new().labelNeq('method', 'GET').build(false)
      ])
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} | json | (status_code == 500 or response_time > 100 or critical > true) and (user == `admin` and method != `GET`)'
  ],
]
