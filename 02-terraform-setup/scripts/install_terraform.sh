#!/bin/bash

# Update the package list and install required packages
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

# Add HashiCorp GPG key to the keyring
wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null

# Add HashiCorp repository to the sources list
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null

# Update the package list again
sudo apt update

# Install Terraform
sudo apt-get install terraform
