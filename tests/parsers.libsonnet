local logql = import '../logql.libsonnet';

[
  [
    'it supports json parser',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .json()
    .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | json',
  ],
  [
    'it supports logfmt parser',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .logfmt()
    .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | logfmt',
  ],
  [
    'it supports pattern parser',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .pattern('<_><status_code><_>')
    .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | pattern `<_><status_code><_>`',
  ],
  [
    'it supports regex parser',
    logql.new()
    .withLabels({
      app: 'ecommerce',
      cluster: 'primary',
      region: 'us-east-1',
    })
    .line().eq('error')
    .regex('.+"status":(?P<status_code>[^,]+')
    .build(formatted=false),
    '{app="ecommerce", cluster="primary", region="us-east-1"} |= `error` | regex `.+"status":(?P<status_code>[^,]+`',
  ],
]
