FROM tensorflow/tensorflow:2.1.0-gpu-py3-jupyter

WORKDIR /home/jupyter

RUN pip3 install jupyterlab && jupyter serverextension enable --py jupyterlab

COPY requirements.txt .
RUN pip3 install -r requirements.txt

# jupyter lab
EXPOSE 8888

# tensorboard
EXPOSE 6006

ENTRYPOINT ["/bin/bash"]
