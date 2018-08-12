#!/usr/bin/env bash
systemctl start etcd
systemctl enable etcd
etcdctl mkdir /kube-centos/network
etcdctl mk /kube-centos/network/config "{ \"Network\":\"172.30.0.0/16\",\"SubnetLen\":24,\"Backend\": {\"Type\":\"vxlan\"}}"