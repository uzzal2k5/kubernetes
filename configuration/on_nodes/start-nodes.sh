#!/usr/bin/env bash

for SERVICES in kube-proxy  kubelet flanneld docker;
do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status -l $SERVICES
done

