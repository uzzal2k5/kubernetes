#!/usr/bin/env bash
minikube addons enable ingress
kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx --watch