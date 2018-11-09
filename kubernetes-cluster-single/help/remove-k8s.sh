yum remove -y --enablerepo=virt7-kubernetes-110-release kubernetes docker etcd  *rhsm*
rm -rf /etc/kubernetes
rm -rf /etc/etcd

yum install -y --enablerepo=virt7-kubernetes-110-release  kubernetes  flannel docker  etcd  *rhsm*