
APP_NAME=$(basename $(pwd))
VM_NAME=deep-docker1
ZONE=us-west1-b
REMOTE_IMAGE_NAME=gcr.io/iconic-algo/tf-2.1.0-gpu:latest
CONTAINER_NAME=tf-gpu


build-local:
	docker build -t $(APP_NAME) .

run:
	docker run --rm --name $(CONTAINER_NAME) -it -d -p 8888:8888 -p 6006:6006 -v /home/docker/notebooks:/home/jupyter $(REMOTE_IMAGE_NAME)

exec:
	docker exec -it tf-gpu /bin/bash

exec-notebook:
	docker exec -it tf-gpu jupyter lab --port=8888 --ip=0.0.0.0 --allow-root /home/jupyter

run-exec: run exec

run-exec-notebook: run exec-notebook

down:
	docker stop $(CONTAINER_NAME)

build-cloud-image:
	gcloud builds submit --tag $(REMOTE_IMAGE_NAME)

ssh-vm:
	gcloud compute ssh docker@$(VM_NAME) --zone=$(ZONE) -- -L 8888:localhost:8888 -L 6006:localhost:6006

ssh-container:
	gcloud compute ssh $(VM_NAME) --zone=$(ZONE) --container $(CONTAINER_NAME)

build-vm-gpu:
	gcloud compute instances create $(VM_NAME) \
	--zone=$(ZONE) \
	--accelerator="type=nvidia-tesla-k80,count=1" \
	--image-family "ubuntu-1804-lts" \
	--image-project "ubuntu-os-cloud" \
	--boot-disk-device-name="persistent-disk" \
	--boot-disk-size=500GB \
	--boot-disk-type=pd-standard \
	--machine-type=n1-standard-4 \
	--maintenance-policy=TERMINATE \
	--tags="allow-tcp-6006,allow-tcp-8888" \
	--metadata-from-file startup-script=./startup.sh

# this will create a VM. however, VMs created with this method are limited to Container-Optimized OS which this
# based on Chromium OS. installing GPU drivers looks complicated.
build-vm-with-container:
	gcloud compute instances create-with-container $(VM_NAME) \
	--zone=$(ZONE) \
	--container-image $(REMOTE_IMAGE_NAME) \
	--container-stdin \
	--container-tty \
	--accelerator="type=nvidia-tesla-k80,count=1" \
	--boot-disk-device-name="persistent-disk" \
	--boot-disk-size=500GB \
	--boot-disk-type=pd-standard \
	--machine-type=n1-standard-4 \
	--maintenance-policy=TERMINATE \
	--tags="allow-tcp-6006,allow-tcp-8888"

build-vm-no-gpu:
	gcloud compute instances create $(VM_NAME) \
	--zone=$(ZONE) \
	--image-family "ubuntu-1804-lts" \
	--image-project "ubuntu-os-cloud" \
	--boot-disk-device-name="persistent-disk" \
	--boot-disk-size=500GB \
	--boot-disk-type=pd-standard \
	--machine-type=n1-standard-4 \
	--maintenance-policy=TERMINATE \
	--tags="allow-tcp-6006,allow-tcp-8888" \
	--metadata-from-file startup-script=./startup.sh
