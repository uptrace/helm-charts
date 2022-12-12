# Contributing

Start minikube:

```shell
minikube start
```

To install this chart locally:

```shell
kubectl create namespace uptrace
helm install my-uptrace ./charts/uptrace -n uptrace
```

To list pods:

```shell
kubectl get pods -n uptrace
```

To view Uptrace logs:

```shell
kubectl logs my-uptrace-0 -n uptrace
```

To uninstall the chart:

```shell
helm uninstall -n uptrace my-uptrace
```

To install the chart with override values:

```shell
helm install my-uptrace ./charts/uptrace -n uptrace -f override-values.yaml
```

To cleanup after you are done:

```shell
kubectl delete namespace uptrace
```
