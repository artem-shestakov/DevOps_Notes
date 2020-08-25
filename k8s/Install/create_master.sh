# Initialize master
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address 10.0.0.10

# Make current user admin for kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# You should now deploy a pod network to the cluster.
# Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
# https://kubernetes.io/docs/concepts/cluster-administration/addons/

# Install the Tigera Calico operator and custom resource definitions
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml

# Install Calico by creating the necessary custom resource.
# Before creating this manifest, read its contents and make sure its settings are correct for your environment.
# For example, you may need to change the default IP pool CIDR to match your pod network CIDR.
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml

#Confirm that all of the pods are running with the following command
watch kubectl get pods -n calico-system
# or check all system pods and Calico pod
kubectl get pods --all-namespaces

# Remove the taints on the master so that you can schedule pods on it
kubectl taint nodes --all node-role.kubernetes.io/master-

# Confirm that you now have a node in your cluster with the following command
kubectl get nodes -o wide

# Check status kubelet (before kubeadmin init it was exited)
sudo systemctl status kubelet.service

# Check config files and manifests
sudo ls -l /etc/kubernetes
sudo ls -l /etc/kubernetes/manifests/
