#!/usr/bin/env bash
# https://www.mirantis.com/blog/how-install-kubernetes-kubeadm/
set -e
sudo su && swapoff -a
vi /etc/fstab

cat << EOF >> /etc/ufw/sysctl.conf
net/bridge/bridge-nf-call-ip6tables = 1
net/bridge/bridge-nf-call-iptables = 1
net/bridge/bridge-nf-call-arptables = 1
EOF

sudo su && apt-get install -y ebtables ethtool

reboot

# Install Kubeadm
apt-get update
apt-get install -y docker
apt-get install -y apt-transport-https
apt-get install curl

#Retrieve the key for the Kubernetes repo
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get install -y kubelet kubeadm kubectl
#   kubeadm config images pull
kubeadm init --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#Install the Calico network plugin:
kubectl apply -f https://docs.projectcalico.org/v2.6/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml

#Untaint the master so that it will be available for scheduling workloads
kubectl taint nodes --all node-role.kubernetes.io/master-



mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config