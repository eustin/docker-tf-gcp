#! /bin/bash

echo running startup script...

sudo apt-get update && apt-get install -y --no-install-recommends \
		 apt-transport-https \
		 wget \
		 curl \
		 ca-certificates \
		 curl \
		 gnupg-agent \
		 software-properties-common \
		 python-dev \
		 pciutils

# cuda
curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo apt-get update && sudo apt-get install -y cuda

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# nvidia-docker
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo usermod -a -G docker ${USER}


GCLOUD_PATH=$(which gcloud)
export PATH="$PATH:GCLOUD_PATH"

# pull my docker image from container registry
#sudo gcloud docker -- pull gcr.io/iconic-algo/tf-2.1.0-gpu:latest
#sudo docker run --gpus all -it -d --name tf-gpu -p 8888:8888 -p 6006:6006 gcr.io/iconic-algo/tf-2.1.0-gpu:latest
f0d41d96de4c