#!/bin/sh
mkdir -p $HOME/.kube
rm -f $HOME/.kube/config

# inspired by https://www.google.com/amp/s/blog.alexellis.io/bare-metal-kubernetes-with-k3s/amp

# k3s comes with the servicelb load balancer
# as alternative to metallb

export IP=${1:-192.168.1.235}
export SSHUSER=${2:-lex}
export CONTEXT=${3:-lanprod}

echo Installing k3s on $IP, connecting to ssh with user $SSHUSER and creating kube context $CONTEXT

k3sup install --ip $IP --user $SSHUSER --context $CONTEXT --k3s-extra-args '--disable traefik' --k3s-channel latest --merge --local-path $HOME/.kube/config --cluster

k3sup ready \
  --context $CONTEXT \
  --kubeconfig $HOME/.kube/config

chmod 600 $HOME/.kube/config

# uninstall
# /usr/local/bin/k3s-uninstall.sh

# local install
# k3sup install --local --context dbglocal --no-extras --k3s-channel latest --merge --local-path $HOME/.kube/config --cluster
