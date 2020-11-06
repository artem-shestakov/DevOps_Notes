# Ingress

## TLS connection
Create open and secret keys:
```shell script
$ openssl genrsa -out tls.key 2048
$ openssl req -new -x509 -key tls.key -out tls.cert -days 360 -subj /CN=foo.example.com
```
Create k8s secret:
```shell script
$ kubectl create secret tls tls-secret --cert=tls.cert --key=tls.key 
secret/tls-secret created
```

Add spec.tls section in [manifest](https://github.com/artem-shestakov/DevOps_Notes/blob/master/k8s/Ingress/ingress-tls.yaml)
```yaml
spec:
  tls:
  - hosts:
    - foo.example.com
    secretName: tls-secret
```

Update/Create ingress.
```shell script
$ kubectl apply -f ingress.yaml 
ingress.extensions/kubia configured
```

