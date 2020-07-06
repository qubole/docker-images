FROM debian:stretch

RUN apt-get update \
 && apt-get install -y locales \
 && dpkg-reconfigure -f noninteractive locales \
 && locale-gen C.UTF-8 \
 && /usr/sbin/update-locale LANG=C.UTF-8 \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Users with other locales should set this in their derivative image
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
 && apt-get install -y curl unzip wget bash libc6 libpam-modules krb5-user libnss3 procps gpg \
    python3 python3-setuptools \
 && ln -s /usr/bin/python3 /usr/bin/python \
 && easy_install3 pip py4j \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install tini
ENV TINI_VERSION v0.18.0
RUN set -eux; \
  wget -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini"; \
  chmod +x /usr/local/bin/tini; \
  tini --version

# http://blog.stuart.axelbrooke.com/python-3-on-spark-return-of-the-pythonhashseed
ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

# JAVA
RUN apt-get update \
 && apt-get install -y openjdk-8-jre \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# HADOOP
ENV HADOOP_VERSION 2.9.2
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
RUN curl -sL --retry 3 \
  "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
  | gunzip \
  | tar -x -C /usr/ \
 && rm -rf $HADOOP_HOME/share/doc \
 && chown -R root:root $HADOOP_HOME

# SPARK
ENV SPARK_VERSION 2.4.5
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -sL --retry 3 \
  "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
  | gunzip \
  | tar x -C /usr/ \
 && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
 && chown -R root:root $SPARK_HOME

# aws jars
RUN mkdir -p /tmp && \
 cd /tmp && \
 wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.9.2/hadoop-aws-2.9.2.jar && \
 wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.199/aws-java-sdk-bundle-1.11.199.jar && \
 wget https://repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.4/commons-lang3-3.4.jar

# spark-hive jars
RUN cd /tmp && \
 wget https://repo1.maven.org/maven2/org/apache/spark/spark-hive_2.11/2.4.5/spark-hive_2.11-2.4.5.jar && \
 wget https://repo1.maven.org/maven2/org/spark-project/hive/hive-metastore/1.2.1.spark2/hive-metastore-1.2.1.spark2.jar && \
 wget https://repo1.maven.org/maven2/org/spark-project/hive/hive-exec/1.2.1.spark2/hive-exec-1.2.1.spark2.jar && \
 wget https://repo1.maven.org/maven2/org/apache/thrift/libfb303/0.9.3/libfb303-0.9.3.jar && \
 wget https://repo1.maven.org/maven2/org/apache/thrift/libthrift/0.9.3/libthrift-0.9.3.jar


RUN rm -rf $SPARK_HOME/jars/kubernetes-client-*.jar
ADD https://repo1.maven.org/maven2/io/fabric8/kubernetes-client/4.4.2/kubernetes-client-4.4.2.jar $SPARK_HOME/jars

RUN mv /tmp/*.jar $SPARK_HOME/jars

COPY entrypoint.sh /opt/
COPY decom.sh /opt/

WORKDIR $SPARK_HOME

RUN chmod a+x /opt/decom.sh
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]


