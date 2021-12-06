#!/usr/bin/env bash

# update package list 
sudo apt update

# install nfs-common
sudo apt install -y nfs-common

# install docker 
sudo apt install -y docker-ce=$2 docker-ce-cli=$2 containerd.io=$3

# install kubernetes
# both kubelet and kubectl will install by dependency
# but aim to latest version. so fixed version by manually
sudo apt install -y kubelet=$1 kubectl=$1 kubeadm=$1

# Ready to install for k8s 
sudo systemctl enable --now docker
sudo systemctl enable --now kubelet

# docker daemon config for systemd from cgroupfs, registry mirror & restart
# https://cloud.google.com/container-registry/docs/pulling-cached-images
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "registry-mirrors": ["https://mirror.gcr.io"]
}
EOF
sudo systemctl daemon-reload && sudo systemctl restart docker
