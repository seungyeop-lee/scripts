#!/bin/bash

# Install docker client & multipass
brew install docker docker-compose multipass

INSTANCE_NAME="docker-vm"

# Launch Multipass VM with cloud-init
CPU_NUM=2
MEMORY_SIZE=4G
DISK_SIZE=32G
multipass launch -c $CPU_NUM -m $MEMORY_SIZE -d $DISK_SIZE -n $INSTANCE_NAME --cloud-init ./cloud-init.yaml 20.04
multipass exec $INSTANCE_NAME -- /home/ubuntu/setup-docker.sh

# List of volume mounts that Docker for Desktop also mounts per default.
multipass mount /Users $INSTANCE_NAME

# Get VM IP address
DOCKER_VM_IP=$(multipass info $INSTANCE_NAME | grep IPv4 | awk '{print $2}')

docker context create $INSTANCE_NAME --docker "host=tcp://$DOCKER_VM_IP:2375"
docker context use $INSTANCE_NAME

docker run --rm hello-world

# Print the IP address of the Docker VM
echo "Docker VM IP address: $DOCKER_VM_IP"
