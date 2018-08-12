#!/usr/bin/env bash
# Change ip address and hostname according to your settings

hosts='192.168.0.64 kube-master
192.168.0.65 kube-node1
192.168.0.66 etcd
192.168.0.67 kube-node2
'

if grep -Fxq "$hosts" /etc/hosts
then
    echo "Host names already exist"
else
    echo "$hosts">>/etc/hosts
fi


