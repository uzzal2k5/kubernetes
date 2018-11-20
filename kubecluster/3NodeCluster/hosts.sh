#!/usr/bin/env bash
hosts="10.1.1.28    etcd1
10.1.1.29   kube-master
10.1.1.30   kube-node1"

if grep -Fxq "$hosts" /etc/hosts
then
    echo "Host names already exist"
else
    echo "$hosts">>/etc/hosts
fi
