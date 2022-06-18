#!/bin/bash

INSTANCE_NAME="ssh"

multipass stop $INSTANCE_NAME
multipass delete $INSTANCE_NAME
multipass purge
