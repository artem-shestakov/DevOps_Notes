kubectl run hello-world --image=gcr.io/google-samples/hello-app:1.0

# get Pods info
kubectl get pods
kubectl get pods -o wide

# Get logs of Pod
kubectl logs hello-world

# Execute command inside container
kubectl exec -it hello-world /bin/sh

# Get information about Pod
kubectl describe pods hello-world | more

# Expose service from pod
kubectl expose pod hello-world --port=80 --target-port=8080

# Get services
kubectl get services
kubectl describe services hello-world | more

# Get the endpoints of service
kubectl get endpoints hello-world

# Remove Service and Pod
kubectl delete services hello-world
kubectl delete pods hello-world
