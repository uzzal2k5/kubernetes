#!/usr/bin/env bash

cp /etc/sysconfig/network-scripts/ifcfg-enp0s3 /etc/sysconfig/network-scripts/back.ifcfg-enp0s3
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-br0
TYPE="Bridge"
BOOTPROTO="static"
NAME="br0"
DEVICE="br0"
ONBOOT="yes"
DFROUTE="yes"
IPADDR="10.1.1.30"
PREFIX="24"
GATEWAY="10.1.1.1"
DNS1="8.8.8.8"
NM_CONTROLLED="no"
EOF

cat << EOF >/etc/sysconfig/network-scripts/ifcfg-enp0s3
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="none"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="no"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="enp0s3"
DEVICE="enp0s3"
ONBOOT="yes"
IPV6_PRIVACY="no"
BRIDGE=br0
NM_CONTROLLED=no
EOF

systemctl restart network