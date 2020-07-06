ARG BASE_CONTAINER=gcr.io/hybrid-qubole/jupyter-pyspark:latest
FROM $BASE_CONTAINER
USER root

# RSpark config
ENV R_LIBS_USER $SPARK_HOME/R/lib
RUN fix-permissions $R_LIBS_USER

# update aws JAR
RUN cd $SPARK_HOME/jars && \
 wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.9.2/hadoop-aws-2.9.2.jar

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gcc && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Apache Toree kernel
RUN pip install --no-cache-dir \
    https://dist.apache.org/repos/dist/release/incubator/toree/0.3.0-incubating/toree-pip/toree-0.3.0.tar.gz \
    && \
    jupyter toree install --sys-prefix && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
