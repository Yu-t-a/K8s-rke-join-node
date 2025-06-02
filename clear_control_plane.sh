#!/bin/bash

# หยุด services
sudo systemctl stop kubelet
sudo systemctl stop etcd
sudo systemctl stop kube-apiserver
sudo systemctl stop kube-controller-manager
sudo systemctl stop kube-scheduler

# disable services
sudo systemctl disable kubelet
sudo systemctl disable etcd

# ลบ config และ data files
sudo rm -rf /etc/kubernetes/
sudo rm -rf /var/lib/kubelet/
sudo rm -rf /var/lib/etcd/
sudo rm -rf /var/lib/kube-proxy/

# ลบ certificates
sudo rm -rf /etc/ssl/etcd/
sudo rm -rf /etc/kubernetes/pki/

# reset iptables
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X

# หรือใช้ kubeadm reset
sudo kubeadm reset --force
