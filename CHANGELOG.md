# Changelog

## [v2.1.0] - 2026-11-14

### Features

- **Uptrace v2.1.0** - Deploy Uptrace v2.1.0, the first stable v2.1 release, by default. See the
  [Uptrace changelog](https://github.com/uptrace/uptrace/blob/master/CHANGELOG.md) for the changes
  since v2.1.0-rc.1.

### Upgrading

- `helm upgrade --wait` runs the expand steps in the pre-upgrade Job and the rest of `migrate up`
  in the post-upgrade Job, as in v2.1.0-rc.1. From v2.0.x or a v2.1 beta, read
  [Upgrading to v2.1.0](https://uptrace.dev/get/hosted/upgrade#upgrading-to-v210) first.
- During the upgrade, the incident screens wait until the post-upgrade Job finishes its backfill.
- The chart's default config passes `uptrace config validate` and `uptrace config fix` of v2.1.0
  with no deprecated options. If your values set `ingest.produce_wait_timeout`, rename it to
  `ingest.request_timeout`.

## [v2.1.0-rc.1] - 2026-10-08

### Features

- **Uptrace v2.1.0-rc.1** - Deploy Uptrace v2.1.0-rc.1 by default.

### Bug Fixes

- **Alerting options** - Document `alerting.monitors` and `alerting.notifications` in place of the
  deprecated `alerting.disabled`.
- **ClickHouse storage policies** - Set the storage policy of the `service_graph_edges` and
  `project_metrics` tables, like the other tables.
- **Self-monitoring DSN** - Build the host of `self_monitoring.dsn` from the Uptrace Service name
  and ports of the release. Self-monitoring now works with any release name, not only `uptrace`.
- **Example values** - Read the ClickHouse address from `CH_ADDR` and the password from
  `CH_PASSWORD` in `uptrace-values.yaml`.
- **Generated secret** - Generate `service.secret` on the first install and keep it on later
  upgrades. The chart stores it in a Secret and gives it to Uptrace as `UPTRACE_SECRET`. Set
  `uptrace.secret` to use your own value. Uptrace refuses the old `FIXME` placeholder, so a render
  now fails when `service.secret` is `FIXME` or empty.
- **Config validation on install** - Run the config validate Job before a fresh install too, not
  only before an upgrade.

## [v2.1.0-beta.3] - 2026-03-11

### Features

- **Redis enabled by default** - Enable built-in Redis by default and use `alpha` as redis addr key

## [v2.1.0-beta.2] - 2026-03-09

### Features

- **Redis server** - Added opt-in Redis server to the chart
- **Config validation** - Validate config before upgrade
  ([#67](https://github.com/uptrace/helm-charts/pull/67))

## [v2.1.0-beta] - 2026-01-21

### Features

- **Migrate job support** - Added migration job functionality
  ([#65](https://github.com/uptrace/helm-charts/pull/65))
- **Port remapping** - Support for port remapping configuration
  ([#64](https://github.com/uptrace/helm-charts/pull/64))
- **PostgreSQL PVC template** - Added PVC template support for PostgreSQL persistence
  ([#62](https://github.com/uptrace/helm-charts/pull/62))
- **External traffic policy** - Allow setting external traffic policy on services
  ([#61](https://github.com/uptrace/helm-charts/pull/61))
- **OtelCol sidecar tolerations** - Allow setting tolerations on otelcol-sidecar
  ([#60](https://github.com/uptrace/helm-charts/pull/60))

### Bug Fixes

- **Liveness probe scheme** - Specify scheme for liveness probe
  ([#63](https://github.com/uptrace/helm-charts/pull/63))
- **ClickHouse storage class** - Use `clickhouse.persistence.storageClassName` correctly
  ([#57](https://github.com/uptrace/helm-charts/pull/57))
