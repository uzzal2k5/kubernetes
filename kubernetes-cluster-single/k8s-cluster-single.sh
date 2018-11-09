#!/usr/bin/env bash
set -e

setenforce 0
sed -i --follow-symlinks 's/SELINUX=disabled/SELINUX=enforcing/g' /etc/sysconfig/selinux

for SERVICES in firewalld NetworkManager;
do
    systemctl disable ${SERVICES}
    systemctl stop ${SERVICES}
done
# IP address grep - Device ens33 , enp0s31f6
IP_ADDRESS=`ip a | grep inet | egrep ens33 | awk -F ' ' '{print $2}' | awk -F / '{print $1}'`


hosts="${IP_ADDRESS} kube-master kube-node etcd"


if grep -Fxq "$hosts" /etc/hosts
then
    echo "Host names already exist"
else
    echo "$hosts">>/etc/hosts
fi


# Add Repository
cat << EOF >/etc/yum.repos.d/virt7-kubernetes-19-release.repo
[virt7-docker-common-release]
name = virt7-docker-common-release
baseurl=http://cbs.centos.org/repos/virt7-kubernetes-19-release/x86_64/os/
gpgcheck=0
EOF

# Install Require packages
yum install -y --enablerepo=virt7-kubernetes-19-release \
    kubernetes \
    flannel \
    docker \
    etcd \
    *rhsm*

cd dashboard && sh x509-auth.sh
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
etcdctl mkdir /kube-network/network
etcdctl mk /kube-network/network/config "{ \"Network\":\"172.30.0.0/16\",\"SubnetLen\":24,\"Backend\": {\"Type\":\"vxlan\"}}"

# Configure kube-master
cat <<EOF >/etc/kubernetes/apiserver
KUBE_API_ADDRESS="--address=0.0.0.0"
KUBE_API_PORT="--port=8080"
KUBELET_PORT="--kubelet_port=10250"
KUBE_ETCD_SERVERS="--etcd_servers=http://etcd:2379"
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
KUBE_ADMISSION_CONTROL="--admission_control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ResourceQuota"
#KUBE_ADMISSION_CONTROL=""
KUBE_API_ARGS="--service_account_key_file=/usr/local/share/ca-certificates/ca.key"
#KUBE_API_ARGS=""
EOF

cat <<EOF >/etc/kubernetes/config
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

cat << EOF >/etc/kubernetes/controller-manager

###
# The following values are used to configure the kubernetes controller-manager

# defaults from config and apiserver should be adequate

# Add your own!\
KUBE_CONTROLLER_MANAGER_ARGS="--service_account_private_key_file=/usr/local/share/ca-certificates/ca.key"
#
#KUBE_CONTROLLER_MANAGER_ARGS=""
EOF

# Configure kube-node
# CONFIGURE FLANNELD NETWORK
cat <<EOF >/etc/sysconfig/flanneld

# Flanneld configuration options

# etcd url location.  Point this to the server where etcd runs
FLANNEL_ETCD_ENDPOINTS="http://etcd:2379"

# etcd config key.  This is the configuration key that flannel queries
# For address range assignment
FLANNEL_ETCD_PREFIX="/kube-network/network"

# Any additional options that you want to pass
FLANNEL_OPTIONS="--iface=ens33"

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
KUBELET_HOSTNAME="--hostname-override=kube-node"

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


# STARTING MASTER SERVICES

for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler kube-proxy  kubelet flanneld docker;
do
    systemctl restart ${SERVICES}
    systemctl enable ${SERVICES}
    systemctl status -l ${SERVICES}
done

