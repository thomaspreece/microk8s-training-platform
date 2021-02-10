#!/usr/bin/env bash
set -e

git clone git@github.com:OWASP/SecurityShepherd.git
cd SecurityShepherd
mvn -Pdocker clean install -DskipTests

export VERSION=3.1
export TOMCAT_DOCKER_VERSION=8.5.51-jdk8-openjdk
export MYSQL_VERSION=5.7.26
export MONGODB_VERSION=4.1.13
export IMAGE_TOMCAT=owasp/security-shepherd
export IMAGE_MYSQL=owasp/security-shepherd_mysql
export IMAGE_MONGO=owasp/security-shepherd_mongo
export CONTAINER_TOMCAT=secshep_tomcat
export CONTAINER_MYSQL=secshep_mysql
export CONTAINER_MONGO=secshep_mongo
export MYSQL_USER=root
export MYSQL_PASS=CowSaysMoo
export TLS_KEYSTORE_PASS=CowSaysMoo
export TLS_KEYSTORE_FILE=shepherdKeystore.p12
export ALIAS=tomcat
export KEY_ALG=RSA
export DNAME=cn=OwaspShepherd,ou=SecurityShepherd,o=OWASP,L=BaileÁthaCliath,ST=Laighin,C=IE
export STORE_TYPE=pkcs12
export HTTP_PORT=80
export HTTPS_PORT=443
export DOCKER_NETWORK_NAME=securityshepherd_default

docker build . -t rdctf/security-shepherd \
  --build-arg TOMCAT_DOCKER_VERSION=${TOMCAT_DOCKER_VERSION} \
  --build-arg MYSQL_USER=${MYSQL_USER} \
  --build-arg MYSQL_PASS=${MYSQL_PASS} \
  --build-arg MYSQL_URI=jdbc:mysql://security-shepherd-mysql-db:3306 \
  --build-arg MONGO_HOST=security-shepherd-mongo-db \
  --build-arg MONGO_PORT=27017 \
  --build-arg MONGO_CONN_TIMEOUT=1000 \
  --build-arg MONGO_SOCK_TIMEOUT=0 \
  --build-arg MONGO_SVR_TIMEOUT=30000 \
  --build-arg TLS_KEYSTORE_FILE=${TLS_KEYSTORE_FILE} \
  --build-arg TLS_KEYSTORE_PASS=${TLS_KEYSTORE_PASS} \
  --build-arg ALIAS=${ALIAS} \
  --build-arg HTTPS_PORT=${HTTPS_PORT}
