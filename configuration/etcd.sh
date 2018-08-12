#!/usr/bin/bash
# ETCD.CONF
cat <<EOF > /etc/etcd/etcd.conf
# [member]
ETCD_NAME=default
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"

#[cluster]
ETCD_ADVERTISE_CLIENT_URLS="http://0.0.0.0:2379"
EOF

# Creating etcd Network
systemctl start etcd
systemctl enable etcd
etcdctl mkdir /kube-centos/network
etcdctl mk /kube-centos/network/config "{ \"Network\":\"172.30.0.0/16\",\"SubnetLen\":24,\"Backend\": {\"Type\":\"vxlan\"}}"



# STARTING ETCD SERVICE

for SERVICES in etcd;
do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status -l $SERVICES
done
