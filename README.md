# Uptrace Helm Chart for Kubernetes

## Quickstart

Add Uptrace [repo](https://github.com/uptrace/helm-charts-repository):

```shell
helm repo add uptrace https://charts.uptrace.dev
helm repo update uptrace
```

Install Uptrace:

```shell
helm install -n uptrace --create-namespace my-uptrace uptrace/uptrace
```

View available pods and logs:

```shell
kubectl get pods -n uptrace
kubectl logs my-uptrace-0 -n uptrace
```

## Before you begin

### Kubernetes Cluster

If you don't have a Kubernetes Cluster, create one with
[minikube](https://minikube.sigs.k8s.io/docs/start/).

### Helm

To install Helm, see [Helm Installation guide](https://helm.sh/docs/intro/install/).

## Installation

To add Uptrace Helm repository:

```shell
helm repo add uptrace https://charts.uptrace.dev
```

To install Uptrace chart in `uptrace` namespace:

```shell
helm install -n uptrace --create-namespace my-uptrace uptrace/uptrace
```

To list Uptrace pods:

```shell
kubectl get pods -n uptrace

NAME                      READY   STATUS    RESTARTS   AGE
clickhouse-my-uptrace-0   1/1     Running   0          59s
my-uptrace-0              1/1     Running   0          59s
my-uptrace-zookeeper-0    1/1     Running   0          59s
```

To view Uptrace logs:

```shell
kubectl logs my-uptrace-0 -n uptrace
```

## Ingress

Uptrace creates an ingress rule for `uptrace.local` domain.

First, enable ingress controller:

```shell
minikube addons enable ingress
```

Then, make sure the pods are running:

```shell
kubectl get pods -n ingress-nginx
```

Lastly, update `/etc/hosts` using the minikube IP address and open
[http://uptrace.local](http://uptrace.local):

```
$(minikube ip)    uptrace.local
```

## Deploying to AWS EKS

To deploy Uptrace on AWS EKS and provide external access using the AWS LB Controller:

```yaml
service:
  type: LoadBalancer
  port: 80
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: 'external'
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: 'ip'
  loadBalancerSourceRanges:
    - '0.0.0.0/0'
```

## Upgrade

To fetch information about latest charts from the Helm repositories:

```shell
helm repo update
```

To upgrade to the latest available version:

```shell
helm -n uptrace upgrade my-uptrace uptrace/uptrace
```

## Configuration

You change Uptrace config by creating `override-values.yaml` and providing Uptrace config in
`uptrace.config` YAML option.

For example, to use your own ClickHouse database, create `override-values.yaml` with the following
content:

```yaml
clickhouse:
  enabled: false

uptrace:
  config:
    ch:
      addr: clickhouse-host:9000
      user: default
      password:
      database: uptrace
```

Then install Uptrace:

```shell
helm --namespace uptrace install my-uptrace uptrace/uptrace -f override-values.yaml
```

## Uninstall

To uninstall Uptrace chart:

```shell
helm -n uptrace uninstall my-uptrace
```

To delete Uptrace namespace:

```shell
kubectl delete namespace uptrace
```
