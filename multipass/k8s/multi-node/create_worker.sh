#!/bin/bash

k8s_V=$1       # Kubernetes
docker_V=$2    # Docker
ctrd_V=$3      # Containerd
worker_name=$4

multipass launch --name "${worker_name}" --cpus 2 --mem 2G --disk 8G 20.04

multipass transfer in-instance-script/k8s_env_build.sh "${worker_name}":
multipass exec "${worker_name}" -- sudo chmod +x /home/ubuntu/k8s_env_build.sh
multipass exec "${worker_name}" -- /home/ubuntu/k8s_env_build.sh

multipass transfer in-instance-script/k8s_pkg_cfg.sh "${worker_name}":
multipass exec "${worker_name}" -- sudo chmod +x /home/ubuntu/k8s_pkg_cfg.sh
multipass exec "${worker_name}" -- /home/ubuntu/k8s_pkg_cfg.sh "${k8s_V}" "${docker_V}" "${ctrd_V}"

multipass exec "${worker_name}" -- bash -c "sudo mkdir -p /home/ubuntu/.kube/"
multipass exec "${worker_name}" -- bash -c "sudo chown ubuntu:ubuntu /home/ubuntu/.kube/"
multipass transfer kubeconfig.yaml "${worker_name}":/home/ubuntu/.kube/config
multipass exec "${worker_name}" -- bash -c "kubeadm token create --print-join-command > /home/ubuntu/kubeadm_join_cmd.sh"
multipass exec "${worker_name}" -- bash -c "sudo chmod +x /home/ubuntu/kubeadm_join_cmd.sh"
multipass exec "${worker_name}" -- bash -c "sudo sh /home/ubuntu/kubeadm_join_cmd.sh"
