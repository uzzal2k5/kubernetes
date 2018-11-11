#!/usr/bin/env bash
set -e

yum update -y
yum install -y net-tools wget curl vim
yum install -y socat

for DISABLED_SERVICES in firewalld;
do
    systemctl disable ${DISABLED_SERVICES}
    systemctl stop ${DISABLED_SERVICES}
done

IP_ADDRESS=`ip a | grep inet | egrep eth0 | awk -F ' ' '{print $2}' | awk -F / '{print $1}'`
hosts="${IP_ADDRESS} kube-master"


if grep -Fxq "$hosts" /etc/hosts
then
    echo "Host names already exist"
else
    echo "$hosts">>/etc/hosts
fi

setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

swapoff -a

#sed -i --follow-symlinks 's/\/dev/mapper/ninja-swap/\#/dev/mapper/ninja-swap/g' /etc/fstab

yum install docker -y

for PRE_SERVICES in docker;
do
    systemctl enable ${PRE_SERVICES}
    systemctl restart ${PRE_SERVICES}
done



curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo cp minikube /usr/local/bin/
#&& rm minikube
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && cp kubectl /usr/local/bin/
#&& rm kubectl

export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
mkdir -p $HOME/.kube
mkdir -p $HOME/.minikube
touch $HOME/.kube/config

export KUBECONFIG=$HOME/.kube/config
#sudo -E minikube start --vm-driver=none
#minikube start --vm-driver=none
minikube start --vm-driver=none --extra-config=kubelet.cgroup-driver=systemd

# this for loop waits until kubectl can access the api server that Minikube has created
for i in {1..150}; do # timeout for 5 minutes
   kubectl get po &> /dev/null
   if [ $? -ne 1 ]; then
      break
  fi
  sleep 2
done

