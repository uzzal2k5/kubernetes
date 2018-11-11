#!/usr/bin/env bash
ETCD_DIR="/etc/etcd/"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
FLANNELD_CONF="/etc/sysconfig/flanneld"
KUBER_CONF_DIR="/etc/kubernetes/"



yum update -y
yum install -y wget net-tools vim curl

setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux



cat << EOF >/etc/yum.repos.d/virt7-kubernetes-110-release.repo
[virt7-kubernetes-110-release]
name = virt7-kubernetes-110-release
baseurl=http://cbs.centos.org/repos/virt7-kubernetes-110-release/x86_64/os/
gpgcheck=0
EOF

IP_ADDRESS=`ip a | grep inet | egrep eth0 | awk -F ' ' '{print $2}' | awk -F / '{print $1}'`
hosts="${IP_ADDRESS} kube-master kube-node etcd"


if grep -Fxq "$hosts" /etc/hosts
then
    echo "Host names already exist"
else
    echo "$hosts">>/etc/hosts
fi


yum install -y --enablerepo=virt7-kubernetes-110-release kubernetes kubernetes-kubeadm containernetworking-cni flannel docker etcd  *rhsm*





for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler kube-proxy  kubelet flanneld docker;
do
    systemctl restart ${SERVICES}
    systemctl enable ${SERVICES}
    systemctl status -l ${SERVICES}
done

for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler   flanneld kubelet kube-proxy docker;
do
    systemctl stop ${SERVICES}
    systemctl status -l ${SERVICES}
done


for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler kube-proxy  kubelet flanneld docker;
do
    systemctl status -l ${SERVICES}
done






Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --fail-swap-on=false"
Environment="KUBELET_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true"
Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/usr/libexec/cni"
Environment="KUBELET_DNS_ARGS=--cluster-dns=10.96.0.10 --cluster-domain=cluster.local"
Environment="KUBELET_AUTHZ_ARGS=--authorization-mode=Webhook --client-ca-file=/etc/kubernetes/pki/ca.crt"
Environment="KUBELET_EXTRA_ARGS=--cgroup-driver=systemd"
#ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_SYSTEM_PODS_ARGS $KUBELET_NETWORK_ARGS $KUBELET_DNS_ARGS $KUBELET_AUTHZ_ARGS $KUBELET_EXTRA_ARGS



























