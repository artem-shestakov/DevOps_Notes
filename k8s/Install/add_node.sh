# Connect to node
ssh <username>@<ipaddress>

# Switch off swap
sudo swapoff -a
sudo vim /etc/fstab

# Install packages
# Use commands from package_install.sh


# List of tokens
kubeadm token list

# or generate new token
kubeadm token create

# Get hash of master token
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256

# Then you can join any number of worker nodes by running the following on each as root:
kubeadm join 10.0.0.10:6443 --token <master token> \
    --discovery-token-ca-cert-hash sha256:<master_hash_token>

# Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
kubectl get nodes