#!/bin/bash

PODMAN_MODE=$1

# Install podman client & multipass
brew install podman multipass

# Create docker symlink
ln -s /usr/local/bin/podman /usr/local/bin/docker || true

# Generate ssh key
SSH_KEY_FILE="./.ssh/id_rsa"
if [ -f "$SSH_KEY_FILE" ] ; then
  echo "ssh key file is exist"
else
  echo "generate ssh key file"
  mkdir .ssh
  ssh-keygen -t rsa -N '' -f $SSH_KEY_FILE <<< y
fi

# Add ssh config
SSH_CONFIG_EXISTS=$(cat user-data | grep -c "ssh_authorized_keys:")
if [[ $SSH_CONFIG_EXISTS -eq 0 ]]; then
  SSH_PUB_KEY=$(cat $SSH_KEY_FILE.pub)
  echo "
ssh_authorized_keys:
  - '${SSH_PUB_KEY}'" >> user-data
fi

# Set default instance
INSTANCE_NAME="podman"
multipass set client.primary-name=$INSTANCE_NAME

# Launch Instance
CPU_NUM=4
MEMORY_SIZE=8G
DISK_SIZE=32G
multipass launch -c $CPU_NUM -m $MEMORY_SIZE -d $DISK_SIZE -n $INSTANCE_NAME --cloud-init user-data 20.04
multipass exec $INSTANCE_NAME -- /home/ubuntu/setup-podman.sh

# Add ssh destination info in podman conf
IP=$(multipass info $INSTANCE_NAME | grep IPv4: | cut -d ':' -f2 | tr -ds ' ' '')
SSH_KEY_FILE="./.ssh/id_rsa"
podman system connection add $INSTANCE_NAME --identity $SSH_KEY_FILE  ssh://root@${IP}/run/podman/podman.sock

# List of volume mounts that Docker for Desktop also mounts per default.
multipass mount /Users $INSTANCE_NAME
multipass mount /Volumes $INSTANCE_NAME
multipass mount /private $INSTANCE_NAME
multipass mount /tmp $INSTANCE_NAME
multipass mount /var/folders $INSTANCE_NAME

multipass list
echo "#######################"
podman system connection list
