#!/bin/sh
BASEDIR=$(dirname "$0")

mkdir -p $HOME/.kube
mv -f $HOME/.kube/config $HOME/.kube/config.bak

# inspired by https://www.google.com/amp/s/blog.alexellis.io/bare-metal-kubernetes-with-k3s/amp

echo Installing k3sup
curl -sLS https://get.k3sup.dev | sh
sudo install k3sup /usr/local/bin/ && rm k3sup

echo Installing k3s locally and creating kube context $CONTEXT

# k3s is installed with load balancer ServiceLB (successor of klipper)
k3sup install \
  --local --context $CONTEXT \
  --k3s-extra-args='--disable servicelb' \
  --k3s-channel latest \
  --merge --local-path $HOME/.kube/config \
  --cluster

k3sup ready \
  --context $CONTEXT \
  --kubeconfig $HOME/.kube/config

chmod 600 $HOME/.kube/config

# disable servicelb for existing k3s clusters https://devops.stackexchange.com/questions/16070/where-does-k3s-store-its-var-lib-kubelet-config-yaml-file
helm repo add metallb https://metallb.github.io/metallb || true
helm repo update
helm install metallb metallb/metallb 

# uninstall
# /usr/local/bin/k3s-uninstall.sh

# local install
# k3sup install --local --context dbglocal --no-extras --k3s-channel latest --merge --local-path $HOME/.kube/config --cluster

# for viewing logs, increase fs inotify limit
cp $BASEDIR/rc-local.service /tmp/
sudo mv /tmp/rc-local.service /etc/systemd/system/rc-local.service

cp $BASEDIR/rc.local /tmp/
sudo mv /tmp/rc.local /etc/

sudo systemctl enable rc-local.service

echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
