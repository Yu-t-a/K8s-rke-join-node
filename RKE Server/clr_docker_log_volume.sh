#!/bin/bash

docker stop rke_server
docker rm rke_server

docker volume prune -f
docker volume rm $(docker volume ls -q)

sudo systemctl stop rancher-system-agent
sudo systemctl disable rancher-system-agent
sudo rm -rf /etc/rancher /var/lib/rancher /var/lib/agent
sudo rm -f /etc/systemd/system/rancher-system-agent.service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
rm -rf ~/.kube

sudo systemctl stop rke2-server
sudo systemctl disable rke2-server
sudo rm -rf /etc/rancher/rke2 /var/lib/rancher/rke2
sudo rm -f /usr/local/bin/rke2*
sudo rm -f /etc/systemd/system/rke2-server.service
sudo systemctl daemon-reload
rm -rf ~/.kube ~/.rancher

echo "Stopping services..."
sudo systemctl stop rancher-system-agent k3s k3s-agent rke2-server rke2-agent 2>/dev/null || true
sudo systemctl disable rancher-system-agent k3s k3s-agent rke2-server rke2-agent 2>/dev/null || true

echo "Removing directories..."
sudo rm -rf /opt/rancher /var/lib/rancher /etc/rancher /var/lib/containerd /run/containerd /var/lib/cni /etc/cni /opt/cni

#echo "Cleaning containers..."
#sudo docker system prune -a -f --volumes 2>/dev/null || true
#sudo crictl rmi --prune 2>/dev/null || true

echo "Cleaning network..."
sudo ip link delete cni0 2>/dev/null || true
sudo ip link delete flannel.1 2>/dev/null || true

echo "Killing processes..."
sudo pkill -f rancher 2>/dev/null || true
sudo pkill -f k3s 2>/dev/null || true
sudo pkill -f rke2 2>/dev/null || true

echo "Clean completed! Please reboot the system."
