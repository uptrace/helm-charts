# Uptrace Helm Chart for Kubernetes

## Quickstart

```shell
helm repo add uptrace https://charts.uptrace.dev
helm install -n telemetry --create-namespace my-uptrace uptrace/uptrace
```

## Before you begin

### Kubernetes Cluster

If you don't have a Kubernetes Cluster, create one with
[minikube](https://minikube.sigs.k8s.io/docs/start/).

To install Helm, see [Installation guide](https://helm.sh/docs/intro/install/).

### ClickHouse Operator

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

## Upgrade

To fetch information about latest charts from the Helm repositories:

```shell
helm repo update
```

To upgrade to the latest available version:

```shell
helm -n telemetry upgrade my-uptrace uptrace/uptrace
```

## Uninstall

To uninstall Uptrace chart:

```shell
helm -n telemetry uninstall my-uptrace
```

To delete Uptrace namespace:

```shell
kubectl delete namespace telemetry
```
