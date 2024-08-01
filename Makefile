NAMESPACE := uptrace
RELEASE_NAME := my-uptrace

init:
	minikube start
	minikube addons enable ingress

create-namespace:
	kubectl create namespace $(NAMESPACE)

delete-namespace:
	kubectl delete namespace $(NAMESPACE)

debug:
	helm install --dry-run --debug $(RELEASE_NAME) ./charts/uptrace

lint:
	helm lint --strict --set "cloud=local" ./charts/uptrace

install: create-namespace
	helm install $(RELEASE_NAME) ./charts/uptrace -n $(NAMESPACE)

uninstall: delete-namespace
	helm uninstall -n $(NAMESPACE) $(RELEASE_NAME)

logs:
	kubectl logs my-uptrace-0 -n uptrace

delete: uninstall
	kubectl delete all,pvc,cm --all -n $(NAMESPACE)

upgrade:
	helm upgrade $(RELEASE_NAME) -n $(NAMESPACE) --create-namespace

list:
	kubectl get all -n $(NAMESPACE)

list-all:
	kubectl get all,pvc,cm -n $(NAMESPACE)

re-install: delete install

purge: delete delete-namespace
