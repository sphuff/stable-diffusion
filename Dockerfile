# syntax=docker/dockerfile:1

FROM farrenzo47/lambda-stack:20.04

USER root

RUN apt-get update
RUN apt-get install wget ffmpeg libsm6 libxext6  -y

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh
RUN bash  Miniconda3-py38_4.12.0-Linux-x86_64.sh -b -p

COPY . /stable-diffusion

WORKDIR /stable-diffusion

ENV PATH /root/miniconda3/bin:$PATH

RUN echo $(conda --version)

RUN conda env create -f environment.yaml
RUN conda install opencv

SHELL ["conda", "run", "-n", "ldm", "/bin/bash", "-c"]


COPY run.py .
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "ldm", "python", "run.py"]


