# Uptrace Helm Chart for Kubernetes

## ClickHouse Operator

To manage ClickHouse database, Uptrace chart requires
[ClickHouse Operator](https://github.com/Altinity/clickhouse-operator/).

To install ClickHouse Operator:

```shell
kubectl apply -f https://raw.githubusercontent.com/Altinity/clickhouse-operator/master/deploy/operator/clickhouse-operator-install-bundle.yaml
```

See ClickHouse Operator
[Quickstart](https://github.com/Altinity/clickhouse-operator/blob/master/docs/quick_start.md) for
details.

## Installation

To add Uptrace Helm repository:

```shell
helm repo add uptrace https://charts.uptrace.dev
```

To install Uptrace chart in `telemetry` namespace:

```shell
helm install -n telemetry --create-namespace my-uptrace uptrace/uptrace
```

To list Uptrace pods:

```shell
kubectl get pods -n telemetry

NAME                             READY   STATUS    RESTARTS   AGE
chi-uptrace-uptrace-0-0-0        1/1     Running   0          25s
my-uptrace-7b98d7f7d9-nbhlt      1/1     Running   0          28s
my-uptrace-uptrace-zookeeper-0   1/1     Running   0          28s
```

## Ingress

Uptrace creates an ingress rule for `uptrace.local` domain. To access Uptrace via that domain, you
need to update `/etc/hosts`:

```
$(minikube ip)    uptrace.local
```
