# Hive docker image

Hive docker image for `metastore` (mysql backed) and `server`

## Build
```
docker build -t gcr.io/hybrid-qubole/hive-metastore:latest .
```

## Run

### Metastore

```
docker run -p 9083:9083 gcr.io/hybrid-qubole/hive-metastore:latest hive --service metastore
```

Configuration parameters:

```
MYSQL_URI jdbc:mysql://<host>:<port>/<db_name>
MYSQL_USER <mysql_user>
MYSQL_PASSWORD <mysql_password>
```

Example:

```
docker run \
  -e "CONNECTION_URI=jdbc:mysql://localhost:3306/hive" \
  -e "CONNECTION_USER=root" \
  -e "CONNECTION_PASSWORD=super-password" \
  -e "CONNECTION_DRIVER=com.mysql.jdbc.Driver" \
  -e "AWS_ACCESS_KEY_ID=xxx" \
  -e "AWS_SECRET_ACCESS_KEY=yyy" \
  -p 9083:9083 \
  gcr.io/hybrid-qubole/hive-metastore:latest hive --service metastore
```


### Configuration

See above configuration parameters per container type.
For another customisations copy file with configuration to `/opt/hadoop/etc/hadoop/hive-site.xml.tpl` in container

### Kubernetes

#### Install MySQL

```console
helm install --name metastore stable/mysql --set mysqlUser=hive --set mysqlDatabase=metastore --set mysqlPassword=password
```

Add your AWS Access Key and Secret Key in the file: `kubernetes/config-map.yaml`

```bash
kubectl apply -f kubernetes/
```

### Docker Compose

make sure docker is up and running, and fill the relevant variables in the docker compose file:

```bash
cd docker 
docker-compose up
```