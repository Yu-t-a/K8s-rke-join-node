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
# ใช้ repo ของ Ubuntu 22.04 (jammy) แทน
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# นำ GPG Key ลงใหม่
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg

# ตั้งค่า GPG Key
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

```
# Clean-Join-Node-Agent-
Clean &amp; Join Node (Agent) ใน Kubernetes
```
journalctl -u rancher-system-agent.service
```
