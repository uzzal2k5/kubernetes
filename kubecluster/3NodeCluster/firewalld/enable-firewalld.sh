#!/usr/bin/env bash
systemctl enable firewalld
systemctl restart firewalld

# On Kube-Master
firewall-cmd --add-port={10250,10256,10257,6443}/tcp --permanent
firewall-cmd --add-service=ssh --permanent
firewall-cmd --add-port={8472}/udp --permanent
firewall-cmd --reload

# On Kube-Node
firewall-cmd --add-port={10250,10256}/tcp --permanent
firewall-cmd --add-service={ssh, http, https} --permanent
firewall-cmd --add-port={8472}/udp --permanent
fireall-cmd --reload