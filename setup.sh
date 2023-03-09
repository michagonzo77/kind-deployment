#!/bin/bash

# Install Docker
sudo apt update
sudo apt install -y docker.io

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# Install Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create a Kind cluster
sudo kind create cluster

# Get kubeconfig file and move to .kube folder
sudo mkdir -p $HOME/.kube
sudo chmod 777 $HOME/.kube
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo kind get kubeconfig >> $HOME/.kube/config

# Install Arkade
curl -SLsf https://get.arkade.dev/ | sudo sh

# Install OpenFaaS app using Arkade
arkade install openfaas

# Get the password from the installed OpenFaaS installation
PASSWORD=$(kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)

echo "Gateway password is: ${PASSWORD}.
Paste this password in the runner creation prompt in Kubiya"
echo "Done!"
