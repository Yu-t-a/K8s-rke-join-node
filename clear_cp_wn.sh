# ลบ kubectl config
rm -rf ~/.kube/

# ลบ container runtime data (ถ้าใช้ containerd)
sudo systemctl stop containerd
sudo rm -rf /var/lib/containerd/

# ลบ CNI networks
sudo rm -rf /etc/cni/net.d/
sudo rm -rf /opt/cni/bin/

# restart network (Ubuntu/Debian)
sudo systemctl restart networking

# หรือ (CentOS/RHEL)
sudo systemctl restart network

#-------------------------------------------
# restart container runtime
# sudo systemctl start containerd
# sudo systemctl enable containerd

# # ตรวจสอบว่า kubelet ถูก reset แล้ว
# sudo systemctl status kubelet

# # ลบ old join tokens (ถ้ามี)
# sudo kubeadm token list

# #------------------
# # ตรวจสอบไม่มี kubernetes processes
# ps aux | grep kube

# # ตรวจสอบไม่มี containers ที่เหลือ
# sudo crictl ps -a
# sudo crictl rmi --all

# # ตรวจสอบ network interfaces
# ip addr show
