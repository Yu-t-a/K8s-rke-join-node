#!/bin/bash

sudo ufw --force enable
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget apt-transport-https ca-certificates gnupg lsb-release

# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Load kernel modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
overlay
EOF

sudo modprobe br_netfilter
sudo modprobe overlay

# Set kernel parameters
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Install and configure NTP
sudo apt install -y ntp
sudo systemctl enable ntp
sudo systemctl start ntp

# หรือใช้ timesyncd
sudo systemctl enable systemd-timesyncd
sudo systemctl start systemd-timesyncd

sudo timedatectl set-timezone Asia/Bangkok
timedatectl
