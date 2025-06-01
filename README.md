
# Config kubeconfig
Snap คือระบบจัดการแพ็กเกจ (package manager)
```
#Control plane (Master Node)

sudo snap install kubectl --classic     # ติดตั้ง kubectl
snap list                               # ดูรายการ snap ที่ติดตั้ง
sudo snap remove kubectl                # ลบ snap

which kubectl
kubectl version --client

vim kubeconfig.yaml
chmod 400 kubeconfig.yaml
export KUBECONFIG=$(pwd)/kubeconfig.yaml
echo $KUBECONFIG

OR

mkdir -p ~/.kube
vim config
sudo chown $(id -u):$(id -g) ~/.kube/config


kubectl get nodes
kubectl get pods -A
```

# Config Node
```
# ตั้งค่า hostname (แต่ละ node ต้องไม่ซ้ำกัน)
sudo hostnamectl set-hostname master-node-01  # สำหรับ master
sudo hostnamectl set-hostname worker-node-01  # สำหรับ worker

# เพิ่ม DNS entries (ถ้าจำเป็น)
echo "192.168.1.10 master-node-01" | sudo tee -a /etc/hosts
echo "192.168.1.11 worker-node-01" | sudo tee -a /etc/hosts

# ตรวจสอบ connectivity ไปยัง Rancher server
curl -k https://rke.pattaya.go.th/ping

# ตรวจสอบ DNS resolution
nslookup rke.pattaya.go.th

telnet [ip Master node] 9345
```
การตรวจสอบหลังติดตั้ง
```
# ตรวจสอบ system agent status
sudo systemctl status rancher-system-agent

# ตรวจสอบ logs
sudo journalctl -u rancher-system-agent -f

# ตรวจสอบ processes
ps aux | grep -E "(etcd|kube|rancher)"

# ตรวจสอบ network ports
netstat -tlnp | grep -E ":(2379|2380|6443|10250)"
```

# ถอนการติดตั้ง Docker Snap แล้วลงใหม่จาก APT
```
sudo snap remove docker

ปิดไฟล์ repo ด้วยคำสั่ง:
sudo nano /etc/apt/sources.list.d/mongodb-org-7.0.list

# deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/7.0 multiverse

จากนั้นติดตั้ง Docker อีกครั้ง:
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

```
ถ้าอยากใช้ MongoDB บน Ubuntu 24.04 ตอนนี้:
ยังไม่มี official package สำหรับ "noble" ต้องใช้วิธี:
```
หาไฟล์ MongoDB repo
ls /etc/apt/sources.list.d/
mongodb-org-7.0.list

คอมเมนต์ repo MongoDB
sudo sed -i 's/^/#/' /etc/apt/sources.list.d/mongodb-org-7.0.list

docker --version
docker compose version

```
# Node (Agent) ใน Kubernetes
```
journalctl -u rancher-system-agent.service

บน worker-node-01 รันคำสั่ง:
sudo journalctl -u rke2-agent -f
หรือ:
sudo journalctl -u kubelet -f
```

# ขั้นตอนลบแค่ worker-node-01 (แบบ manual แบบปลอดภัย)
1. Drain node ก่อน (ย้าย workload ออก)
```
kubectl drain worker-node-01 --ignore-daemonsets --delete-emptydir-data
```
2. ลบ node ออกจาก cluster
```
kubectl delete node worker-node-01
```
3. หยุด service agent บน worker-node-01
```
sudo systemctl stop rke2-agent
```

1. ตรวจสอบสถานะและทำความสะอาดบน Worker Node
```
# หยุด rke2-agent service
sudo systemctl stop rke2-agent

# ลบข้อมูลเก่า
sudo rm -rf /var/lib/rancher/rke2/agent/
sudo rm -rf /etc/rancher/rke2/

# ลบ token เก่า (ถ้ามี)
sudo rm -f /var/lib/rancher/rke2/server/node-token
```
2. ดึง Token และ CA Hash จาก Master Node
บน master-node ให้รันคำสั่งนี้:
```
# ดึง node token
sudo cat /var/lib/rancher/rke2/server/node-token

# ดึง CA certificate hash
openssl x509 -pubkey -in /var/lib/rancher/rke2/server/tls/server-ca.crt | \
openssl rsa -pubin -outform der 2>/dev/null | \
openssl dgst -sha256 -hex | sed 's/^.* //'
```
3. สร้าง Config File ใหม่บน Worker Node
สร้างไฟล์ /etc/rancher/rke2/config.yaml:
```
sudo mkdir -p /etc/rancher/rke2/
sudo tee /etc/rancher/rke2/config.yaml << EOF
server: https://10.20.252.15:9345
token: <YOUR_TOKEN_FROM_MASTER>
tls-san:
  - 10.20.252.15
  - 127.0.0.1
node-external-ip: <WORKER_NODE_EXTERNAL_IP>
EOF
```
4. ตรวจสอบการเชื่อมต่อเครือข่าย
```
# ทดสอบการเชื่อมต่อ
telnet 10.20.252.15 9345

# ตรวจสอบ firewall
sudo ufw status
# หรือ
sudo iptables -L

# ตรวจสอบ DNS resolution
nslookup 10.20.252.15
```
5. เริ่ม Service อีกครั้ง
```
# เริ่ม rke2-agent
sudo systemctl start rke2-agent
sudo systemctl enable rke2-agent

# ติดตาม log
sudo journalctl -u rke2-agent -f
```

