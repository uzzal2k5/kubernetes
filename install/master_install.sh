#!/usr/bin/env bash
cat << EOF >/etc/yum.repos.d/virt7-docker-common-release.repo
[virt7-docker-common-release]
name = virt7-docker-common-release
baseurl=http://cbs.centos.org/repos/virt7-docker-common-release/x86_64/os/
gpgcheck=0
EOF

yum install -y  --enablerepo=virt7-docker-common-release kubernetes 
yum install -y *rhsm*
