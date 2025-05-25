sudo hostnamectl set-hostname longhorn-node-01

helm repo add longhorn https://charts.longhorn.io
helm repo update

kubectl create namespace longhorn-system

helm install longhorn longhorn/longhorn --namespace longhorn-system
