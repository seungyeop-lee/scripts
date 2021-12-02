#!/bin/bash

INSTANCE_NAME="podman"

function dk() {
  CMD="$*"
  multipass exec $INSTANCE_NAME -- sudo /bin/bash -c "cd $PWD && docker $CMD"
}

function dkc() {
  CMD="$*"
  multipass exec $INSTANCE_NAME -- sudo /bin/bash -c "cd $PWD && docker-compose $CMD"
}
