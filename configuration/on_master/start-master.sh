#!/usr/bin/env bash

for SERVICES in kube-apiserver kube-controller-manager kube-scheduler;
do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status -l $SERVICES
done

