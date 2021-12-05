#!/usr/bin/env bash

# install nfs-server
sudo apt install -y nfs-kernel-server
sudo mkdir /nfs_shared
echo "/nfs_shared 192.168.64.0/24(rw,sync,no_root_squash)" | sudo tee /etc/exports
if [[ $(sudo systemctl is-enabled nfs-server) -eq "disabled" ]]; then
  sudo systemctl enable nfs-server
fi
  sudo systemctl restart nfs-server

# init kubernetes
sudo kubeadm init --pod-network-cidr=192.178.0.0/16

# config for master node only 
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# config for kubernetes's network
kubectl apply -f calico.yaml

# alias kubectl to k 
echo 'alias k=kubectl' >> ~/.bashrc
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc
