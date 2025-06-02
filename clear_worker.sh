#!/bin/bash

# หยุด kubelet และ kube-proxy
sudo systemctl stop kubelet
sudo systemctl stop kube-proxy

# disable services
sudo systemctl disable kubelet
sudo systemctl disable kube-proxy

# ลบ config files
sudo rm -rf /etc/kubernetes/
sudo rm -rf /var/lib/kubelet/
sudo rm -rf /var/lib/kube-proxy/
sudo rm -rf /var/lib/etcd/

# reset iptables rules
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X

# หรือใช้ kubeadm reset (ถ้ามี)
sudo kubeadm reset --force
