# Uptrace Helm Chart for Kubernetes

This chart installs:

- [Uptrace open source APM](https://uptrace.dev/get/hosted/open-source-apm).
- ClickHouse using [ClickHouse Operator](https://github.com/Altinity/clickhouse-operator).
- PostgreSQL using [PostgreSQL Operator](https://cloudnative-pg.io/).
- Redis using [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/redis).
- OpenTelemetry Collector using
  [OpenTelemetry Operator](https://github.com/open-telemetry/opentelemetry-operator).

See [**Deploying Uptrace on Kubernetes with Helm**](https://uptrace.dev/get/hosted/k8s) for details.

## TODO

- Start using Redis Operator (need to find a working one first)
- Change default configuration to run multiple replicas of everything for high availability

## Help

Have questions? Get help via [Telegram](https://t.me/uptrace),
[Slack](https://join.slack.com/t/uptracedev/shared_invite/zt-1xr19nhom-cEE3QKSVt172JdQLXgXGvw), or
[start a discussion](https://github.com/uptrace/uptrace/discussions) on GitHub.

## Contributing

<a href="https://github.com/uptrace/helm-charts/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=uptrace/helm-charts" />
</a>
