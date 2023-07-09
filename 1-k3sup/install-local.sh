#!/bin/sh
set -e

BASEDIR=$(dirname "$0")
CONTEXT=local

mkdir -p $HOME/.kube
mv -f $HOME/.kube/config $HOME/.kube/config.bak &> /dev/null

# inspired by https://www.google.com/amp/s/blog.alexellis.io/bare-metal-kubernetes-with-k3s/amp


echo Installing k3sup
curl -sLS https://get.k3sup.dev && sudo sh && rm k3sup
# sudo install k3sup /usr/local/bin/ && rm k3sup

echo Installing k3s locally and creating kube context $CONTEXT

# k3s is installed with load balancer ServiceLB (successor of klipper)
k3sup install \
  --local --context $CONTEXT \
  --k3s-extra-args='--disable traefik --disable servicelb' \
  --k3s-channel latest \
  --merge --local-path $HOME/.kube/config \
  --cluster

# if the --disable args failed, add them manually to /etc/systemd/system/k3s.service at ExecStart, example:
#   '--disable' \
#   'servicelb'

k3sup ready \
  --context $CONTEXT \
  --kubeconfig $HOME/.kube/config

chmod 600 $HOME/.kube/config

sh $BASEDIR/install-metallb.sh

# uninstall
# /usr/local/bin/k3s-uninstall.sh

# for viewing logs, increase fs inotify limit
sudo cp $BASEDIR/rc-local.service /etc/systemd/system/rc-local.service
sudo mv /tmp/rc-local.service 

sudo cp $BASEDIR/rc.local /etc/

sudo systemctl enable rc-local.service

echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
