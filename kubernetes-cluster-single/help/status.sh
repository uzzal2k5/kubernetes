for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler kube-proxy  kubelet flanneld docker;
do
      systemctl status -l ${SERVICES}
done