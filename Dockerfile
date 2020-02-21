# FROM nvidia/cuda:10.1-base-ubuntu18.04
# FROM nvidia/cuda:10.2-runtime-ubuntu18.04
FROM tensorflow/tensorflow:2.1.0-gpu-py3

RUN apt-get install -y python3 python3-pip
RUN pip3 --no-cache-dir install --upgrade pip setuptools

# install jupyter lab
RUN pip3 install jupyterlab && jupyter serverextension enable --py jupyterlab

# install the rest of the packages
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# jupyter lab
EXPOSE 8888

# tensorboard
EXPOSE 6006

ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0", "--port=8888", "--allow-root"]
