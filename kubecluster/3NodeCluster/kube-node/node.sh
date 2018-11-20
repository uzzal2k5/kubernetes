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


kubeadm join 10.1.1.29:6443 --token d1oaur.m1us1r0dmmzx9nos --discovery-token-ca-cert-hash sha256:96407b21678f2789a86c77577a2cadf4895c487532e575cd38bfd738f6949c17