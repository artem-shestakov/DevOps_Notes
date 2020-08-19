# Stage 1. Replace the IP address in all config files
oldip=10.0.2.15
newip=10.0.0.10

cd /etc/kubernetes

# Find all config files with old IP
sudo find . -type f | sudo xargs grep $oldip

# Replace old IP on new IP
sudo find . -type f | sudo xargs sed -i "s/$oldip/$newip/"

# Check changes
sudo find . -type f | sudo xargs grep $newip

# Stage 2. Backup /etc/kubernetes/pki
mkdir ~/k8s-old-pki
sudo cp -Rvf /etc/kubernetes/pki/* ~/k8s-old-pki

# Stage 3. Find certs with the old IP address
cd /etc/kubernetes/pki
sudo sh -c 'for f in $(find -name "*.crt"); do openssl x509 -in $f -text -noout > $f.txt; done'
sudo grep -Rl $oldip .
sudo sh -c 'for f in $(find -name "*.crt"); do rm $f.txt; done'

# find all the config map names
configmaps=$(kubectl -n kube-system get cm -o name | \
  awk '{print $1}' | \
  cut -d '/' -f 2)


# fetch all for filename reference
dir=$(mktemp -d)
for cf in $configmaps; do
  kubectl -n kube-system get cm $cf -o yaml > $dir/$cf.yaml
done

# have grep help you find the files to edit, and where
grep -Hn $dir/* -e $oldip

# edit those files, in my case, grep only returned these two:
kubectl -n kube-system edit cm kubeadm-config
kubectl -n kube-system edit cm kube-proxy

# Stage  Change IP in distro


# Update key ad cert
kubeadm alpha certs renew all
kubeadm alpha certs renew apiserver
kubeadm alpha certs renew etcd-peer

# Restart services
sudo systemctl restart kubelet
sudo systemctl restart docker

# Update admin config for current user
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config