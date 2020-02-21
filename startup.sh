#! /bin/bash

# Docker is the easiest way to enable TensorFlow GPU support on Linux since only the NVIDIA® GPU driver is required
# on the host machine (the NVIDIA® CUDA® Toolkit does not need to be installed).
sudo apt-get install -y cuda-drivers

# install docker
sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

docker run hello-world
