#!/usr/bin/env bash
#!/usr/bin/env bash
# https://mapr.com/blog/making-data-actionable-at-scale-part-2-of-3/
# yum -y install $(cat packages.txt)
# yum -y install $(cat packages.txt cat | tr '\n' ' ')
setenforce 0
sed -i '/^SELINUX./ { s/enforcing/disabled/; }' /etc/selinux/config

# Adding host name
IP_ADDRESS=`ip a | grep inet | egrep br0 | awk -F ' ' '{print $2}' | awk -F / '{print $1}'`

# ON EACH NODE
# Install kubernetes repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
cat packages.txt | xargs yum -y install
# Disable swap
if [ `hostname` ==  'kube-node1' ];
then
    swapoff -a
    sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
    # Set iptables
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
fi
# Launch Docker and enable it on system boot
systemctl start docker
systemctl enable docker


# Install Kubernetes and start it
#yum install -y kubelet kubeadm kubectl
systemctl start kubelet
systemctl enable kubelet

firewall-cmd --add-port={6443,10250}/tcp --permanent
firewall-cmd --reload

#kubeadm init --apiserver-advertise-address=10.1.1.29 --pod-network-cidr=10.244.0.0/16
hostname --ip-address
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$(hostname --ip-address)

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml