#!/bin/sh
set -e

export IP=${1:-<my-ip>}
export SSHUSER=${2:-<my-ssh-user>}

BASEDIR=$(dirname "$0")

if [ -z "${BASEDIR}/longhorn" ]; then
  git clone https://github.com/longhorn/longhorn ${BASEDIR}/longhorn
fi

kubectl create namespace longhorn-system

helm upgrade --install longhorn ./longhorn/chart/ --namespace longhorn-system  -f ${BASEDIR}/values.yaml

kubectl apply -f yaml/storageclass-longhorn-durable.yaml.yaml
kubectl apply -f yaml/storageclass-longhorn-hddyaml.yaml

ssh $SSHUSER@$IP sudo apt update && sudo apt install -y nfs-common

kubectl patch svc longhorn-frontend -n longhorn-system -p '{"spec": {"type": "LoadBalancer", "sessionAffinity: ClientIP" }}'

echo todo: check longhorn-manager logs for any issues with volume mounts
