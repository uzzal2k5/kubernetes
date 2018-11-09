#!/usr/bin/env bash
kubectl get pods --all-namespaces
kubectl describe service kubernetes-dashboard --namespace=kube-system
kubectl proxy --address 0.0.0.0 --accept-hosts '.*'
kubectl edit svc/kubernetes-dashboard --namespace=kube-system
kubectl get svc --namespace=kube-system
kubectl describe nodes

yum remove -y --enablerepo=virt7-docker-common-release kubernetes flannel docker etcd  *rhsm*