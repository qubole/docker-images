ARG BASE_CONTAINER=gcr.io/hybrid-qubole/spark:latest
FROM $BASE_CONTAINER

ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

ENV PYTHON_VERSION 3.6.7

RUN apt-get update && apt-get -y install build-essential libssl-dev openssl libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev && \ 
	cd /tmp && \
	wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
	tar xzvf Python-${PYTHON_VERSION}.tgz && \
	cd Python-${PYTHON_VERSION} &&\
	./configure && \
	make && \
	make install

RUN cd /usr/local/bin \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config
	
RUN cd /tmp && wget https://bootstrap.pypa.io/get-pip.py && \
	python get-pip.py

RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN pip install pyspark==2.4.5
