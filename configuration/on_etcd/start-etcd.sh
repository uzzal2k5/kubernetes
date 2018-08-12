#!/usr/bin/env bash

for SERVICES in etcd;
do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status -l $SERVICES
done
