local logql = import "../logql.libsonnet";

[
  [
    "it supports sum aggregation",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .sum()
      .build(formatted=false),
    'sum(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports sum by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .sumBy('env')
      .build(formatted=false),
    'sum by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports sum by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .sumBy('env, namespace')
      .build(formatted=false),
    'sum by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports sum by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .sumWithout('env')
      .build(formatted=false),
    'sum without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports sum by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .sumWithout('env, namespace')
      .build(formatted=false),
    'sum without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports avg aggregation",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .avg()
      .build(formatted=false),
    'avg(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports avg by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .avgBy('env')
      .build(formatted=false),
    'avg by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports avg by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .avgBy('env, namespace')
      .build(formatted=false),
    'avg by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports avg by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .avgWithout('env')
      .build(formatted=false),
    'avg without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports avg by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .avgWithout('env, namespace')
      .build(formatted=false),
    'avg without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports min aggregation",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .min()
      .build(formatted=false),
    'min(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports min by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .minBy('env')
      .build(formatted=false),
    'min by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports min by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .minBy('env, namespace')
      .build(formatted=false),
    'min by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports min by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .minWithout('env')
      .build(formatted=false),
    'min without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports min by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .minWithout('env, namespace')
      .build(formatted=false),
    'min without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports max aggregation",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .max()
      .build(formatted=false),
    'max(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports max by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .maxBy('env')
      .build(formatted=false),
    'max by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports max by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .maxBy('env, namespace')
      .build(formatted=false),
    'max by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports max by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .maxWithout('env')
      .build(formatted=false),
    'max without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports max by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .maxWithout('env, namespace')
      .build(formatted=false),
    'max without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports stddev aggregation",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .stddev()
      .build(formatted=false),
    'stddev(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports stddev by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .stddevBy('env')
      .build(formatted=false),
    'stddev by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports stddev by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .stddevBy('env, namespace')
      .build(formatted=false),
    'stddev by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports stddev by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .stddevWithout('env')
      .build(formatted=false),
    'stddev without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports stddev by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .stddevWithout('env, namespace')
      .build(formatted=false),
    'stddev without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports stdvar aggregation",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .stdvar()
      .build(formatted=false),
    'stdvar(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports stdvar by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .stdvarBy('env')
      .build(formatted=false),
    'stdvar by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports stdvar by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .stdvarBy('env, namespace')
      .build(formatted=false),
    'stdvar by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports stdvar by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .stdvarWithout('env')
      .build(formatted=false),
    'stdvar without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports stdvar by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .stdvarWithout('env, namespace')
      .build(formatted=false),
    'stdvar without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports count aggregation",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .count()
      .build(formatted=false),
    'count(count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports count by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .countBy('env')
      .build(formatted=false),
    'count by (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports count by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .countBy('env, namespace')
      .build(formatted=false),
    'count by (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports count by aggregation with single value",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .countWithout('env')
      .build(formatted=false),
    'count without (env) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
  [
    "it supports count by aggregation with multiple values",
    logql.new()
      .withLabels({
        app: 'ecommerce',
        cluster: "primary",
        region: 'us-east-1',
      })
      .line().eq('error')
      .count_over_time('1m')
      .countWithout('env, namespace')
      .build(formatted=false),
    'count without (env, namespace) (count_over_time({app="ecommerce", cluster="primary", region="us-east-1"} |= `error` [1m]))'
  ],
]
