#!/bin/bash

# Install Docker
sudo apt-get update
sudo apt-get install -y docker.io

# Install kubectl
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# Install Kind with the latest version
KIND_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-amd64"
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create a Kind cluster
sudo kind create cluster

# Get kubeconfig file and move to .kube folder
sudo mkdir -p $HOME/.kube
sudo chmod 777 $HOME/.kube
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo kind get kubeconfig >> $HOME/.kube/config

echo "Done!"
