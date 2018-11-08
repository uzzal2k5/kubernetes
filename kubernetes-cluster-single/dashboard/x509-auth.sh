#!/usr/bin/env bash
#yum install -y openssl
# HELP - !!!
# https://kubernetes.io/docs/concepts/cluster-administration/certificates/
MASTER_IP=`ip a | grep inet | egrep enp0s31f6 | awk -F ' ' '{print $2}' | awk -F / '{print $1}'`
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -subj "/CN=${MASTER_IP}" -days 10000 -out ca.crt
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -config csr.conf
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key \
-CAcreateserial -out server.crt -days 10000 \
-extensions v3_ext -extfile csr.conf
openssl x509  -noout -text -in ./server.crt

#Distributing Self-Signed CA Certificate
mkdir -p /usr/local/share/ca-certificates
cp ca.* /usr/local/share/ca-certificates/
cp ca.crt /usr/local/share/ca-certificates/kubernetes.crt
#update-ca-certificates