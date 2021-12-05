#references
#https://github.com/sysnet4admin/IaC/tree/master/k8s/U/k8s-multicontext
#https://github.com/arashkaffamanesh/kubeadm-multipass

k8s_V = '1.22.1-00'                     # Kubernetes
docker_V = '5:20.10.8~3-0~ubuntu-focal' # Docker
ctrd_V = '1.4.9-1'                      # Containerd

.PHONY: requirement
requirement:
	brew install multipass kubernetes-cli kustomize helm

.PHONY: create_m
create_m:
	./create_master.sh ${k8s_V} ${docker_V} ${ctrd_V}

.PHONY: create_w
create_w:
	./create_worker.sh ${k8s_V} ${docker_V} ${ctrd_V} worker

.PHONY: create_w1 create_w2 create_w3
create_w1:
	./create_worker.sh ${k8s_V} ${docker_V} ${ctrd_V} worker1
create_w2:
	./create_worker.sh ${k8s_V} ${docker_V} ${ctrd_V} worker2
create_w3:
	./create_worker.sh ${k8s_V} ${docker_V} ${ctrd_V} worker3

.PHONY: apply_kubeconfig
apply_kubeconfig:
	-mkdir ${HOME}/.kube
	-cp -f kubeconfig.yaml ${HOME}/.kube/config

.PHONY: install_addon
install_addon:
	#metallb
	kustomize build metallb | kubectl apply -f -
	#metrics-server
	kustomize build metrics-server | kubectl apply -f -
	#nginx ingress controller
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.0/deploy/static/provider/cloud/deploy.yaml
	#nfs provisioner
	helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
	helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
		--set nfs.server=$(shell multipass info master | grep IPv4: | cut -d ':' -f2 | tr -ds ' ' '') \
		--set nfs.path=/nfs_shared \
		--set storageClass.provisionerName=k8s-sigs.io/nfs-subdir-external-provisioner \
		--set storageClass.defaultClass=true \
		--set nfs.volumeName=nfs-client-root

.PHONY: min
deploy_mw: requirement create_m create_w apply_kubeconfig install_addon

.PHONY: all
deploy_mw3: requirement create_m create_w1 create_w2 create_w3 apply_kubeconfig install_addon

.PHONY: clear
clear:
	multipass delete --all
	multipass purge
