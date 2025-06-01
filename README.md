
# Config kubeconfig
Snap คือระบบจัดการแพ็กเกจ (package manager)
```
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
# Clean-Join-Node-Agent-
Clean &amp; Join Node (Agent) ใน Kubernetes
```
journalctl -u rancher-system-agent.service
```

