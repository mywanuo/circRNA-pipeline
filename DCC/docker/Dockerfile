FROM ubuntu:18.04
LABEL maintainer=" Jishu Xu <jishu.xu@gmail.com> "\
      software="circRNA tools" \
      version="0.1" \
      description="circRNA discovery tools" 
 
WORKDIR /tmp
# install additional python packages
#Install wget, unzip
RUN apt update && apt install -y \
  liblzma-dev \
  libbz2-dev \
  cmake automake \
  curl \
  libboost-all-dev \
  wget \
  make \
  gcc \
  build-essential \
  gcc-multilib \
  zlib1g-dev \
  libxml2-dev \
  libncurses5-dev \
  python3 \
  python3-pip \
  python-setuptools \
  samtools 


WORKDIR /tmp
RUN wget https://github.com/dieterich-lab/DCC/archive/v0.4.6.tar.gz && \
	tar -zxvf v0.4.6.tar.gz && \
	cd DCC-0.4.6 && \
	python setup.py install  

