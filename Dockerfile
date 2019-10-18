##
# This dockerfile is used for building a Phonetisaurus environment for g2p based tasks
# To build: docker build -t us.gcr.io/talkiq-data/g2p-env  .
# To run: docker run -it us.gcr.io/talkiq-data/g2p-env [-v <dir_to_mount>:<mounted_dir>]
# Need not build the dockerfile everytime, instead pull the pre-built image from 'us.gcr.io/talkiq-data' and run
##
FROM ubuntu

WORKDIR /root

RUN printf "\nUPDATING UBUNTU AND INSTALLING PACKAGES\n" && \
    apt-get update && \
    apt-get install -y \
    autoconf-archive \
    build-essential \
    libtool \
    make \
    nano \
    g++ \
    gfortran \
    git \
    wget \
    tar \
    python \
    python-dev \
    python-setuptools \
    python-twisted && \
    cd /root

RUN printf "\nDOWNLOADING AND INSTALLING OPEN FST\n" && \
    wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.6.2.tar.gz && \
    tar -xvzf openfst-1.6.2.tar.gz && \
    cd openfst-1.6.2 && \
    # Minimal configure, compatible with current defaults for Kaldi
    ./configure --enable-static --enable-shared --enable-far --enable-ngram-fsts && \
    make -j 4 && \
    # Now wait a while...
    make install

ENV LD_LIBRARY_PATH :/usr/local/lib:/usr/local/lib/fst

RUN printf "\nDOWNLOADING AND INSTALLING PHONETISAURUS\n" && \
    git clone https://github.com/AdolfVonKleist/Phonetisaurus.git && \
    cd Phonetisaurus && \
    ./configure && \
    make && \
    make install

RUN printf "\nSETUP COMPLETE\n"
