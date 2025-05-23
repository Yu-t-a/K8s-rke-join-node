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
