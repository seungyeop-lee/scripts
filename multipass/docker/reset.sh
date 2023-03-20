#!/bin/bash

INSTANCE_NAME="docker-vm"

docker context use default
docker context rm $INSTANCE_NAME

# Remove Docker VM
multipass stop $INSTANCE_NAME
multipass delete $INSTANCE_NAME
multipass purge
