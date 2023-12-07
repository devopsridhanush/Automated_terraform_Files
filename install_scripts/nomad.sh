#!/bin/bash
sudo apt-get update && sudo apt-get install wget gpg coreutils -y #Installation of Nomad in the instance
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install nomad -y

# Install CNI plugins
curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)-v1.0.0.tgz" && \
sudo mkdir -p /opt/cni/bin && \
sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz

# Configure bridge network settings
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-arptables && \
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-ip6tables && \
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables

# Create bridge.conf file and add settings
echo "net.bridge.bridge-nf-call-arptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1" | sudo tee /etc/sysctl.d/bridge.conf
