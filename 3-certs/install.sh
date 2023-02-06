#!/bin/sh
set -e

BASEDIR=$(dirname "$0")

helm repo add jetstack https://charts.jetstack.io; helm repo update

helm upgrade --install \
    cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --version v1.10.1 \
    --set installCRDs=true \
    --set prometheus.enabled=false

cmctl check api --wait=2m

# instructions for adding secret
# https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/

kubectl apply -f ${BASEDIR}/cloudflare-secret.yaml

kubectl apply -f ${BASEDIR}/cloudflare-cluster-issuer.yaml

kubectl apply -f ${BASEDIR}/wildcard-certificate.yaml

kubectl get cr -n default

