#!/usr/bin/env bash
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

for SERVICES in firewalld NetworkManager;
do
    systemctl disable $SERVICES
    systemctl stop $SERVICES
done
