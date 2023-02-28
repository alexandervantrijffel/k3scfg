#!/bin/sh
set -e

# disable servicelb for existing k3s clusters https://devops.stackexchange.com/questions/16070/where-does-k3s-store-its-var-lib-kubelet-config-yaml-file
helm repo add metallb https://metallb.github.io/metallb || true
helm repo update
helm install metallb metallb/metallb 
