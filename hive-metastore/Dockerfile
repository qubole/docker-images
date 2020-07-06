FROM centos:latest

ENV HADOOP_VERSION 2.9.1
ENV HIVE_VERSION 2.1.1
ENV MYSQL_JDBC=https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.18/mysql-connector-java-8.0.18.jar
ENV POSTGRES_JDBC=https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.9/postgresql-42.2.9.jar

RUN yum update -y && \
  yum -y install \
    gettext\
    java-1.8.0-openjdk \
    java-1.8.0-openjdk-devel \
    wget \
    which

RUN cd /opt && \
  wget https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
  tar xzf hadoop-$HADOOP_VERSION.tar.gz && \
  mv hadoop-$HADOOP_VERSION hadoop

RUN cd /opt && \
  wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-${HIVE_VERSION}-bin.tar.gz && \
  tar xzf apache-hive-${HIVE_VERSION}-bin.tar.gz && \
  mv apache-hive-${HIVE_VERSION}-bin hive

RUN wget $MYSQL_JDBC -P /opt/hive/lib/
RUN wget $POSTGRES_JDBC -P /opt/hive/lib/
RUN cd /opt/hive/lib/ && wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.9.2/hadoop-aws-2.9.2.jar && \
 wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.199/aws-java-sdk-bundle-1.11.199.jar && \
 wget https://repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.4/commons-lang3-3.4.jar

COPY conf/mapred-site.xml /opt/hadoop/etc/hadoop/mapred-site.xml
COPY conf/hive-site.xml.tpl /opt/hadoop/etc/hadoop/hive-site.xml.tpl
COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh
COPY conf/hive-log4j2.properties /opt/hive/conf/hive-log4j2.properties

ENV HADOOP_USER_CLASSPATH_FIRST true
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CLASSPATH $HADOOP_HOME/share/hadoop/tools/lib/*
ENV HADOOP_LIBEXEC_DIR ${HADOOP_HOME}/libexec
ENV PATH=$PATH:/opt/hadoop/bin/:/opt/hive/bin/

RUN rm /opt/hadoop/share/hadoop/common/lib/slf4j-log4j12-*.jar

ENTRYPOINT ["/opt/entrypoint.sh"]
