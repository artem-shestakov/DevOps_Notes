# Auto-completion kubectl
sudo apt-get install bash-completion -y
echo "source <(kubectl completion bash)" >> ~/.bashrc
source ~/.bashrc
# Check completion
kubectl g+Tab -> get

# Help
kubectl -h
kubectl get -h

# Cluster information
kubectl cluster-info

# Node status and roles
kubectl get nodes -o wide

# List of pods
kubectl get pods
kubectl get pods --all-namespaces

# List od system pods
kubectl get pods --namespace kube-system
kubectl get pods --namespace kube-system -o wide

# List of everything
kubectl get all --all-namespaces

# API resources
kubectl api-resources

# Explain resources
kubectl explain pod
kubectl explain pod.spec
kubectl explain pod.spec.nodeName

# Getting descriptions
kubectl describe node <your_node>