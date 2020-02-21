
FROM tensorflow/tensorflow:2.1.0-gpu-py3-jupyter

COPY requirements.txt .

RUN pip3 install -r requirements.txt


