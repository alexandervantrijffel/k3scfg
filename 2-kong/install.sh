kubectl create namespace kong
kubectl ns kong

helm repo add kong https://charts.konghq.com; helm repo update
helm install kong-ingress-controller kong/kong --set ingressController.installCRDs=false

helm status kong-ingress-controller

HOST=$(kubectl get svc --namespace default kong-ingress-controller-kong-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
PORT=$(kubectl get svc --namespace default kong-ingress-controller-kong-proxy -o jsonpath='{.spec.ports[0].port}')
export PROXY_IP=${HOST}:${PORT}
curl $PROXY_IP
