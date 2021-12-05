#!/bin/bash

k8s_V=$1    # Kubernetes
docker_V=$2 # Docker
ctrd_V=$3   # Containerd

multipass launch --name master --cpus 2 --mem 2G --disk 16G 20.04

multipass transfer in-instance-script/k8s_env_build.sh master:
multipass exec master -- sudo chmod +x /home/ubuntu/k8s_env_build.sh
multipass exec master -- /home/ubuntu/k8s_env_build.sh

multipass transfer in-instance-script/k8s_pkg_cfg.sh master:
multipass exec master -- sudo chmod +x /home/ubuntu/k8s_pkg_cfg.sh
multipass exec master -- /home/ubuntu/k8s_pkg_cfg.sh ${k8s_V} ${docker_V} ${ctrd_V}

multipass transfer cni/calico.yaml master:
multipass transfer in-instance-script/master_node.sh master:
multipass exec master -- sudo chmod +x /home/ubuntu/master_node.sh
multipass exec master -- /home/ubuntu/master_node.sh

multipass exec master -- sudo cat /etc/kubernetes/admin.conf > kubeconfig.yaml
