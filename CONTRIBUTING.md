# Contributing

## Local cluster

Start a local cluster, for example K3s or minikube:

```shell
sudo systemctl start k3s # or: minikube start
```

The chart needs the CloudNativePG, ClickHouse, and OpenTelemetry operators, plus cert-manager.
Install them once per cluster as described in
[Deploying Uptrace on Kubernetes](https://uptrace.dev/get/hosted/k8s#dependency-setup), then check
that they are available:

```shell
kubectl get deploy -n cnpg-system
kubectl get deploy -n kube-system clickhouse-operator
kubectl get deploy -n opentelemetry
```

With the default values the chart creates about 23Gi of volumes. Keep the free disk space on the
node above the kubelet eviction threshold, or the node reports `DiskPressure` and evicts the pods:

```shell
kubectl describe node | grep DiskPressure
```

## Install

To install this chart from the working tree with the sample values:

```shell
helm install uptrace ./charts/uptrace -f uptrace-values.yaml -n monitoring --create-namespace \
  --wait --timeout 10m
```

A first install takes several minutes, mostly while CloudNativePG initializes the 3 PostgreSQL
instances.

To list pods:

```shell
kubectl get pods -n monitoring
```

To view Uptrace logs:

```shell
kubectl logs uptrace-0 -n monitoring
```

To open the UI at http://localhost:8080 and log in as `admin@uptrace.local` / `admin`:

```shell
kubectl port-forward service/uptrace 8080:80 -n monitoring
```

On K3s, the default ingress also serves http://uptrace.local through Traefik once you add
`127.0.0.1 uptrace.local` to `/etc/hosts`.

To upgrade after changing the chart:

```shell
helm upgrade uptrace ./charts/uptrace -f uptrace-values.yaml -n monitoring --wait
```

## Uninstall

To uninstall the chart and wait until the ClickHouse operator removes the ClickHouse installation:

```shell
helm uninstall uptrace -n monitoring
kubectl wait --for=delete chi/uptrace1 -n monitoring --timeout=5m
```

`helm uninstall` keeps the persistent volume claims and the `uptrace-secret` Secret. To start the
next install from empty databases, delete them too:

```shell
kubectl delete pvc --all -n monitoring
kubectl delete secret uptrace-secret -n monitoring
```

To cleanup after you are done:

```shell
kubectl delete namespace monitoring
```

The `Makefile` has shortcuts for most of these commands, for example `make list` and `make purge`.
Note that `make install` and `make upgrade` use the chart defaults, not `uptrace-values.yaml`.
