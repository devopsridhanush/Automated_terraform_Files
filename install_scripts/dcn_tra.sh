#!/bin/bash
sudo apt-get update -y
sudo apt install docker.io -y && sudo groupadd docker && sudo usermod -aG docker $USER
curl --fail --silent --show-error --location https://apt.releases.hashicorp.com/gpg | \
      gpg --dearmor | \
      sudo dd of=/usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee -a /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update -y
sudo apt-get install consul -y && sudo apt-get install consul=1.14.3-* -y
sudo apt-get update && sudo apt-get install wget gpg coreutils -y
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyr172.31.54.150ings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
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

# Install Traefik
#TRAEFIK_VERSION=$(curl -s https://api.github.com/repos/traefik/traefik/releases/latest | grep "tag_name" | cut -d '"' -f 4)
#wget "https://github.com/traefik/traefik/releases/download/$TRAEFIK_VERSION/traefik_linux_amd64.tar.gz" -O /home/ubuntu/traefik_linux_amd64.tar.gz
wget "https://github.com/traefik/traefik/releases/download/v2.10.5/traefik_v2.10.5_linux_amd64.tar.gz" -O /home/ubuntu/traefik_v2.10.5_linux_amd64.tar.gz
tar -xzvf /home/ubuntu/traefik_v2.10.5_linux_amd64.tar.gz -C /home/ubuntu/
sudo mv /home/ubuntu/traefik /usr/bin/
sudo chmod +x /usr/bin/traefik
