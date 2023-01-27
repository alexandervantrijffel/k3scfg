#!/bin/sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

kubectl patch cm argocd-cm -n argocd -p '{"data": {"timeout.reconciliation": "60s"}}'

kubectl rollout restart deployment argocd-repo-server
