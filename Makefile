NAMESPACE := monitoring
RELEASE_NAME := uptrace

init:
	minikube start
	minikube addons enable ingress

create-namespace:
	kubectl create namespace $(NAMESPACE)

delete-namespace:
	kubectl delete namespace $(NAMESPACE)

debug:
	helm install -n $(NAMESPACE) --dry-run --debug $(RELEASE_NAME) ./charts/uptrace

lint:
	helm lint --strict --set "cloud=local" ./charts/uptrace

install:
	helm install $(RELEASE_NAME) ./charts/uptrace -n $(NAMESPACE) --create-namespace

uninstall: delete-namespace
	helm uninstall -n $(NAMESPACE) $(RELEASE_NAME)

logs:
	kubectl logs $(RELEASE_NAME)-0 -n $(NAMESPACE)

delete: uninstall
	kubectl delete all,pvc,cm --all -n $(NAMESPACE)

upgrade:
	helm upgrade $(RELEASE_NAME) ./charts/uptrace -n $(NAMESPACE) --create-namespace

list:
	kubectl get all -n $(NAMESPACE)

list-all:
	kubectl get all,pvc,cm -n $(NAMESPACE)

re-install: delete install

purge: delete delete-namespace

secrets:
	kubectl get secrets -n monitoring
