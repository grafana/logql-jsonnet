local logql = import "../logql.libsonnet";

[
  [
    "it supports withLabels as object",
    logql.new()
      .withLabels({
        cluster: 'prod',
        region: 'us-east-1',
        app: 'ecommerce'
      })
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"}'
  ],
  [
    "it supports withLabel with object",
    logql.new()
      .withLabel({
        label: 'app',
        op: '=',
        value: 'ecommerce'
      })
      .withLabel({
        label: 'cluster',
        op: '=',
        value: 'prod'
      })
      .withLabel({
        label: 'region',
        op: '=',
        value: 'us-east-1'
      })
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"}'
  ],
  [
    "it supports withLabel with arguments",
    logql.new()
      .withLabel('app', '=', 'ecommerce')
      .withLabel('cluster', '=', 'prod')
      .withLabel('region', '=', 'us-east-1')
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"}'
  ],
  [
    "it supports selector (eq) dsl",
    logql.new()
      .selector('app').eq('ecommerce')
      .selector('cluster').eq('prod')
      .selector('region').eq('us-east-1')
      .line().eq('error')
      .json()
      .build(formatted=false),
    '{app="ecommerce", cluster="prod", region="us-east-1"} !~ `error` | json'
  ],
  [
    "it supports selector (neq) dsl",
    logql.new()
      .selector('app').neq('ecommerce')
      .selector('cluster').neq('prod')
      .selector('region').neq('us-east-1')
      .line().eq('error')
      .json()
      .build(formatted=false),
    '{app!="ecommerce", cluster!="prod", region!="us-east-1"} !~ `error` | json'
  ],
  [
    "it supports selector (re) dsl",
    logql.new()
      .selector('app').re('ecommerce|payment')
      .selector('cluster').re('prod|test')
      .selector('region').re('us-east-\\d+')
      .line().eq('error')
      .json()
      .build(formatted=false),
    '{app=~"ecommerce|payment", cluster=~"prod|test", region=~"us-east-\\d+"} !~ `error` | json'
  ],
  [
    "it supports selector (nre) dsl",
    logql.new()
      .selector('app').nre('ecommerce?')
      .selector('cluster').nre('prod|test')
      .selector('region').nre('us-east-\\d+')
      .line().eq('error')
      .json()
      .build(formatted=false),
    '{app!~"ecommerce?", cluster!~"prod|test", region!~"us-east-\\d+"} !~ `error` | json'
  ],
  [
    "it supports selector (mixed) dsl",
    logql.new()
      .selector('app').eq('ecommerce')
      .selector('cluster').neq('prod')
      .selector('env').re('dev|test')
      .selector('region').nre('us-east-\\d+')
      .line().eq('error')
      .json()
      .build(formatted=false),
    '{app="ecommerce", cluster!="prod", env=~"dev|test", region!~"us-east-\\d+"} !~ `error` | json'
  ],
]
