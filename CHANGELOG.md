# Changelog

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
