#!/usr/bin/env bash

# CONFIGURE FLANNELD NETWORK
cat <<EOF >/etc/sysconfig/flanneld

# Flanneld configuration options

# etcd url location.  Point this to the server where etcd runs
FLANNEL_ETCD_ENDPOINTS="http://etcd:2379"

# etcd config key.  This is the configuration key that flannel queries
# For address range assignment
FLANNEL_ETCD_PREFIX="/kube-centos/network"

# Any additional options that you want to pass
FLANNEL_OPTIONS="--iface=eth1"

EOF



# CONFIGURE /etc/kubernetes/kubelet
cat <<EOF >/etc/kubernetes/kubelet
###
# kubernetes kubelet (minion) config

# The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
KUBELET_ADDRESS="--address=0.0.0.0"

# The port for the info server to serve on
KUBELET_PORT="--port=10250"

# You may leave this blank to use the actual hostname
KUBELET_HOSTNAME="--hostname-override=`hostname`"

# location of the api-server
KUBELET_API_SERVER="--api-servers=http://kube-master:8080"

# pod infrastructure container
#KUBELET_POD_INFRA_CONTAINER="--pod-infra-container-image=registry.access.redhat.com/rhel7/pod-infrastructure:latest"

# Add your own!
KUBELET_ARGS=""

EOF

# CONFIGURE /etc/kubernetes/config

cat <<EOF >/etc/kubernetes/config

###
# kubernetes system config
#
# The following values are used to configure various aspects of all
# kubernetes services, including
#
#   kube-apiserver.service
#   kube-controller-manager.service
#   kube-scheduler.service
#   kubelet.service
#   kube-proxy.service
# logging to stderr means we get it in the systemd journal
KUBE_LOGTOSTDERR="--logtostderr=true"

# journal message level, 0 is debug
KUBE_LOG_LEVEL="--v=0"

# Should this cluster be allowed to run privileged docker containers
KUBE_ALLOW_PRIV="--allow-privileged=false"

# How the controller-manager, scheduler, and proxy find the apiserver
KUBE_MASTER="--master=http://kube-master:8080"

EOF

# STARTING NODE SERVICES
for SERVICES in kube-proxy  kubelet flanneld docker;
do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status -l $SERVICES
done

