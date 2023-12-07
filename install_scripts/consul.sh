#!/bin/bash
curl --fail --silent --show-error --location https://apt.releases.hashicorp.com/gpg | \
      gpg --dearmor | \
      sudo dd of=/usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee -a /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update -y
sudo apt-get install consul -y && sudo apt-get install consul=1.14.3-* -y
