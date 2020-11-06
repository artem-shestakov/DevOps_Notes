# ConfigMap
## Create by CLI
Create by literal
```shell script
$ kubectl create configmap fortune-config --from-literal=sleep-interval=25
configmap/fortune-config created
```

Create from file:
```shell script
$ kubectl create configmap my-config --from-file=config-file.conf

$ kubectl create configmap my-config --from-file=customkey=config-file.conf
```

Create from directory:
```shell script
$ kubectl create configmap my-config --from-file=/path/to/dir
```

## Send ConfigMap to Pod
Settings pod ENV variable in `spec.containers.env` section:
```yaml
spec:
  containers:
    - image: artemshestakov/fortune:env
      name: fortune
      env:
        - name: INTERVAL
          valueFrom:
            configMapKeyRef:
              name: fortune-config
              key: sleep-interval
```
> Use `configMapKeyRef.optional: true` to start container without ConfigMap