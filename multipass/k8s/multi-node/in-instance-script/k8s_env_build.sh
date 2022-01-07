#!/usr/bin/env bash

# vim configuration 
echo 'alias vi=vim' | sudo tee /etc/profile

# swapoff -a to disable swapping
sudo swapoff -a
# sed to comment the swap partition in /etc/fstab (Rmv blank)
sudo sed -i.bak -r 's/(.+swap.+)/#\1/' /etc/fstab

# add kubernetes repo
sudo apt-get update && sudo apt-get install -y libseccomp2 apt-transport-https curl
## add key
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
## add repository
sudo touch /etc/apt/sources.list.d/kubernetes.list
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# add docker-ce repo
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
# enable br_filter for iptables
sudo modprobe br_netfilter
sudo sysctl net.bridge.bridge-nf-call-iptables=1
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

# config DNS
cat <<EOF | sudo tee /etc/resolv.conf
nameserver 1.1.1.1 #cloudflare DNS
nameserver 8.8.8.8 #Google DNS
EOF
