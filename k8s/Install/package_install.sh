# Disable SWAP
sudo swapoff -a

# Delete SWAP from fstab
sudo vim /etc/fstab

# Reboot system
sudo systemctl reboot

# Add Google pero gpg key
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add repository and update package list
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update

# Check package version
apt-cache policy kubelet | head -n 20
apt-cache policy kubeadm | head -n 20

# Install packages
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl docker.io

# Check status
sudo systemctl status kubelet.service
sudo systemctl status docker.service 

# Eneble services
sudo systemctl enable kubelet.service
sudo systemctl enable docker.service

