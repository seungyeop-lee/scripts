#!/bin/bash

# Install multipass
brew install multipass

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
INSTANCE_NAME="ssh"
multipass set client.primary-name=$INSTANCE_NAME

# Launch Instance
CPU_NUM=4
MEMORY_SIZE=8G
DISK_SIZE=32G
multipass launch -c $CPU_NUM -m $MEMORY_SIZE -d $DISK_SIZE -n $INSTANCE_NAME --cloud-init user-data 20.04
echo '--multipass launch finished--'
multipass exec $INSTANCE_NAME -- /home/ubuntu/setup-ssh.sh
echo '--multipass exec setup.sh finished--'

multipass list
