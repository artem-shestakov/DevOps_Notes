# Volumes
## emptyDir
Mount volume to container in `containers.image`:
```yaml
- image: nginx:alpine
      name: web-server
      volumeMounts:
        - name: html
          mountPath: /usr/share/nginx/html
          readOnly: true
```
Volume type is described in `pod.spec.volumes`: 
```yaml
volumes:
      - name: html
        emptyDir: {}
```
Type volume and size describe in `spec.volumes.emptyDir`:
```yaml
volumes:
    - name: html
      emptyDir:
        medium: Memory
        sizeLimit: 100Mi
```

## gitRepo
URL repository in `spec.volumes.gitRepo`
```yaml
volumes:
    - name: html
      gitRepo:
        repository: <git repo url>
        revision: master
        directory: .
```

## hostPath
Only for read or write host files
```yaml
volumes:
  - name: test-volume
    hostPath:
      path: /data
      type: Directory
```
Types:
1. DirectoryOrCreate
- If nothing exists at the given path, an empty directory will be created there as needed with permission set to 0755, having the same group and ownership with Kubelet.

2. Directory	
- A directory must exist at the given path
3. FileOrCreate	
- If nothing exists at the given path, an empty file will be created there as needed with permission set to 0644, having the same group and ownership with Kubelet.   
4. File	
- A file must exist at the given path
    
5. Socket	
- A UNIX socket must exist at the given path
    
6. CharDevice	
- A character device must exist at the given path
    
7. BlockDevice	
- A block device must exist at the given path


## gcePersistentDisk
Describe disk in `spec.volumes`
```yaml
volumes:
  - name: your-volume   # Volume name
    gcePersistentDisk:  # Disk type
      pdName: mydisk    # Disk name in 
      fsType: ext4      # FS type
```

>Create GCE disk
>```shell script
>$ gcloud container clusters list
>NAME          LOCATION        MASTER_VERSION   MASTER_IP     ...
>test-cluster  europe-west1-d  1.16.13-gke.401  34.77.183.43  ...
>
>$ gcloud compute disks create --size=10GiB --zone=europe-west1-d mydisk
>NAME    ZONE            SIZE_GB  TYPE         STATUS
>mydisk  europe-west1-d  10       pd-standard  READY
>```

## awsElasticBlockStore

Describe disk in `spec.volumes`
```yaml
volumes:
  - name: your-volume   # Volume name
    awsElasticBlockStore:  # Disk type
      pdName: mydisk    # Disk name in 
      fsType: ext4      # FS type
```

## PersistentVolume

Create PersistentVolume [manifest](https://github.com/artem-shestakov/DevOps_Notes/blob/master/k8s/Volumes/persistentVolume.yaml):
```yaml
spec:
  capacity:
    storage: 10Gi                         # Volume capacity
  accessModes:
    - ReadWriteOnce                       # Read and write one
    - ReadOnlyMany                        # Only read many
  persistentVolumeReclaimPolicy: Retain   # Save after use
  gcePersistentDisk:                      # Persistent disk type
    pdName: mydisk
    fsType: ext4
```

Check PV:
```shell script
$ kubectl get pv
NAME          CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
database-pv   10Gi       RWO,ROX        Retain           Available                                   10s
```

### PersistentVolumeClaim

Create [claim](https://gitlab.com/artem-shestakov/devops/-/blob/master/k8s/Volumes/persistentVolumeClaim.yaml):
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: database-pvc
spec:
  resources:
    requests:
      storage: 10Gi
  accessModes:
    - readWriteOnce
  storageClassName: ""
```

>For bound to a manual pre-provisioned PersistentVolume use
>```shell script
>storageClassName: ""
>```
>Without this new PersistentVolume will be created by "provisioner" and default StorageClass.

Check created claim and persistent volume:
```shell script
$ kubectl get pvc
NAME           STATUS   VOLUME        CAPACITY   ACCESS MODES   STORAGECLASS   AGE
database-pvc   Bound    database-pv   10Gi       RWO,ROX                       7s

$ kubectl get pv
NAME          CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                  STORAGECLASS   REASON   AGE
database-pv   10Gi       RWO,ROX        Retain           Bound    default/database-pvc
```

### StorageClass

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
  zone: europe-west1-d
```

```shell script
$ kubectl get pvc
NAME        STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mongo-pvc   Bound    pvc-b8fc20d9-0021-4e21-a208-ee9d73817e4e   10Gi       RWO            fast           11s
```