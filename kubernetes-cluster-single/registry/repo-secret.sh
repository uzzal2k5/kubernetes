#!/usr/bin/env bash
kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/  --docker-username=uzzal2k5 --docker-password=shafiq2k5 --docker-email=uzzal2k5@gmail.com
kubectl get secret regcred --output=yaml