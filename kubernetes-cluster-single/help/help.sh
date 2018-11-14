#!/usr/bin/env bash
kubectl get pods --all-namespaces
kubectl describe service kubernetes-dashboard --namespace=kube-system
kubectl proxy --address 0.0.0.0 --accept-hosts '.*'
kubectl edit svc/kubernetes-dashboard --namespace=kube-system
kubectl get svc --namespace=kube-system
kubectl describe nodes

yum remove -y --enablerepo=virt7-docker-common-release kubernetes flannel docker etcd  *rhsm*






kubectl config delete-context minikube

minikube delete
rm -rf ~/.minikube

#====================FWall=============
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="10.1.1.0/24" accept'
firewall-cmd --reload