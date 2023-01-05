#!/bin/sh
BASEDIR=$(dirname "$0")
kubectl create namespace httpbin
kubectl apply -f https://bit.ly/k8s-httpbin -n httpbin
kubectl apply -f $BASEDIR/httpbin-ingress.yaml -n httpbin
