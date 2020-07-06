#!/usr/bin/env bash
set -e

if [[ -z "${AWS_S3_ENDPOINT}" ]]; then
  echo "AWS_S3_ENDPOINT is not set in env, using endpoint for us-east-1"
  export AWS_S3_ENDPOINT=https://s3.us-east-1.amazonaws.com
else
  echo "AWS_S3_ENDPOINT is set in env, using the same"
fi

export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
envsubst < /opt/hadoop/etc/hadoop/hive-site.xml.tpl > /opt/hadoop/etc/hadoop/hive-site.xml

schematool -initSchema -dbType ${DB_TYPE}  || true
hive --service metastore
