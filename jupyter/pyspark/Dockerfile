ARG BASE_CONTAINER=jupyter/scipy-notebook:29a003bb3030
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Spark dependencies
ENV APACHE_SPARK_VERSION=2.4.5 \
    HADOOP_VERSION=2.9.2

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y openjdk-8-jre-headless ca-certificates-java && \
    rm -rf /var/lib/apt/lists/*

# Using the preferred mirror to download Spark
WORKDIR /tmp
# download hadoop

RUN cd /tmp && wget https://mirrors.estointernet.in/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar xzf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/local --owner root --group root --no-same-owner && \
    rm hadoop-${HADOOP_VERSION}.tar.gz


# hadolint ignore=SC2046
RUN wget -q $(wget -qO- https://www.apache.org/dyn/closer.lua/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-without-hadoop.tgz\?as_json | \
    python -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") && \
    tar xzf "spark-${APACHE_SPARK_VERSION}-bin-without-hadoop.tgz" -C /usr/local --owner root --group root --no-same-owner && \
    rm "spark-${APACHE_SPARK_VERSION}-bin-without-hadoop.tgz"

WORKDIR /usr/local
RUN ln -s "spark-${APACHE_SPARK_VERSION}-bin-without-hadoop" spark
RUN ln -s "hadoop-${HADOOP_VERSION}" hadoop

# Configure Spark
ENV SPARK_HOME=/usr/local/spark
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip \
    SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH=$PATH:$SPARK_HOME/bin PYSPARK_SUBMIT_ARGS="--master local[2] pyspark-shell"
    
# With explicit path to 'hadoop' binary
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
RUN export SPARK_DIST_CLASSPATH=$(/usr/local/hadoop/bin/hadoop classpath)

USER $NB_UID

# Install pyarrow
RUN conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

WORKDIR $HOME
