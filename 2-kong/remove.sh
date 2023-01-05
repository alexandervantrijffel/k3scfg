kubectl ns kong
helm uninstall --namespace kong quickstart
kubectl delete secrets -nkong kong-enterprise-license
kubectl delete secrets -nkong kong-config-secret
kubectl delete pvc data-quickstart-postgresql-0
helm uninstall --namespace cert-manager cert-manager
helm repo remove jetstack
helm repo remove kong
kubectl delete all  --all -n kong
kubectl ns -
