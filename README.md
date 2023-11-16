# logql-jsonnet

A [Jsonnet](https://jsonnet.org/) based DSL for writing [LogQL](https://grafana.com/docs/loki/latest/query/) queries, inspired by [promql-jsonnet](https://github.com/satyanash/promql-jsonnet/tree/master). This is useful when creating grafana dashboards using [grafonnet](https://grafana.github.io/grafonnet/index.html). Instead of having to template strings manually, you can now use immutable builders to DRY out your LogQL queries.
