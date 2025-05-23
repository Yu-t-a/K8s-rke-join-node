# ถอนการติดตั้ง Docker Snap แล้วลงใหม่จาก APT
```
sudo snap remove docker

# ลงใหม่แบบ non-snap
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```
# Clean-Join-Node-Agent-
Clean &amp; Join Node (Agent) ใน Kubernetes
```
journalctl -u rancher-system-agent.service
```
