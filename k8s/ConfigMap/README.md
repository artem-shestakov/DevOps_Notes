# ConfigMap (CM)
## Creating by manifest
### Use CM as command line argument

### Use CM as environment variable
Use key-value items
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fortune-config
data:
  sleep-interval: "25"
```
Setup each environment variables by describing ConfigMap keys in `valueFrom.configMapKeyRef`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: fortune
spec:
  containers:
    - image: artemshestakov/fortune:env
      name: fortune
      env:
        # Env variable
        - name: INTERVAL
          valueFrom:
            configMapKeyRef:
              # ConfigMap name and key
              name: fortune-config
              key: sleep-interval
      volumeMounts:
        - name: html
          mountPath: /var/htdocs
    - image: nginx:alpine
      name: web-server
      volumeMounts:
        - name: html
          mountPath: /usr/share/nginx/html
      ports:
        - containerPort: 80
          protocol: TCP
  volumes:
    - name: html
      emptyDir: {}
```

### Use CM as volume
Add data to ConfigMap:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx
data:
  # Use this key as config file
  nginx.config: |
    server {
          listen       80;
          server_name  _;
          location / {
              return 200 'ConfigMap';
          }
    }
```
Setup volume into pod:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web
spec:
  containers:
    - name: nginx
      image: nginx
      # Mount volume to /etc/nginx/conf.d
      volumeMounts:
        - name: config
          mountPath: /etc/nginx/conf.d
          readOnly: true
  volumes:
    # Volume type ConfigMap
    - name: config
      configMap:
        name: nginx
        items:
          # Use key from ConfigMap and save inside pod as config file
          - key: nginx.config
            path: sample.conf
```
>If you omit the `items` array entirely, every key in the ConfigMap becomes a file with the same name as the key

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

