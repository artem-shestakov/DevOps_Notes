# Pods

## Commands and Args
Arguments to the entrypoint and entrypoint array describe in `spec.containers`
```yaml
spec:
  containers:
    - image: artemshestakov/fortune:args
      name: fortune
      args: ["5"]
``` 

### Environment variable

```yaml
containers:
    - image: artemshestakov/fortune:args
      name: fortune
      env:
        - name: INTERVAL
          value: 10
```
Variable references $(VAR_NAME)
```yaml
env:
        - name: FNAME
          value: Jone
        - name: LNAME
          value: Be
        - name: FNAME
          value: "$(FNAME) $(LNAME)"
```

## Readiness probe
### Exec probe

Create **readinessProbe** section in `spec.template.spec.containers` and apply it(only for new created pods).
```yaml
readinessProbe:
  exec: 
    command:
      - ls  
      - /var/ready
```
In example check exit code of
```shell script
ls /var/ready
```
```shell script
$ kubectl get po
NAME          READY   STATUS    RESTARTS   AGE
probe-m9tsd   0/1     Running   0          6s
```
After creating `/var/ready` file:
```shell script
NAME          READY   STATUS    RESTARTS   AGE
probe-m9tsd   1/1     Running   0          115s
```
```shell script
kubectl describe po probe-m9tsd

...
Readiness:      exec [ls /var/ready] delay=0s timeout=1s period=10s #success=1 #failure=3
...
```