ARG CUDA_VERSION=11.1
ARG CUDNN_VERSION=8
ARG IMGTYPE=runtime
ARG OS=ubuntu20.04

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-${IMGTYPE}-${OS}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    ca-certificates \
    libopencv-dev \
    git \
    htop \
    nano \
    nvtop \
    tree \
    wget \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* # clean up

RUN apt-get update && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* # clean up

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

WORKDIR ${HOME}

USER ${NB_USER}

# Install Miniconda and Python 3.8
ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH=${HOME}/miniconda/bin:${PATH}
RUN curl -sLo ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-py38_4.9.2-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && conda clean -ya

COPY environment.yml ${HOME}
RUN conda env create -f environment.yml

SHELL ["conda", "run", "-n", "pydev_conda", "/bin/bash", "-c"]

ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "pydev_conda", "bash"]
