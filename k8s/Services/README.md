#Services
## ClusterIP
### Headless (get IP pods instead of service)
To create **headless** service add in `spec`
```shell script
spec:
  clusterIP: None
```
Check and get IP by DNS
```shell script
$ kubectl get svc
NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
headless   ClusterIP   None            <none>        80/TCP           24s

$ kubectl exec dnsutils -- nslookup headless
Server:		10.96.0.10
Address:	10.96.0.10#53

Name:	headless.default.svc.cluster.local
Address: 192.168.192.222
Name:	headless.default.svc.cluster.local
Address: 192.168.253.20
Name:	headless.default.svc.cluster.local
Address: 192.168.192.221
```
> Getting DNS utils pod:
>```shell script
>kubectl run dnsutils --image=tutum/dnsutils --command -- sleep infinity
>```