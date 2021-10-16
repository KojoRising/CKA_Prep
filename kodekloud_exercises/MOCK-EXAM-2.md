## Questions


### Summary | WOW
#### 1. 
#### 6.
#### 7.
    DNS-LOOKUPS: 
        - RUN w/in POD!
        - Use nslookup "host-name"
        - Pod Host-name ==> POD-IP w/ "-"s instead of "."s
        - k run $RANDOM --image=busybox:1.28 --restart=Never --rm -it -- nslookup nginx-resolver-service | tee /root/CKA/nginx.svc
#### 8.
    1) How can you run a static-pod on a worker node? 
        - ssh-into-worker nod
    2) How can you run a pod on a particular node without using pod's nodeName/nodeSelector fields, nodeAffinity, or taints/tolerations?
        - Static Pod (SSH into that node, and cat the manifest there)
#### 
#### 




### 6 Steps

1)
- 1. Create Key/CSR [2]
- 2. Create K8s CSR && Approve [2]
- 3. Extract Certificate

2)
- 1. Create Role
- 2. Create Rolebinding

3) Update KubeConfig
- 1. Create User Field [3 args]
- 2. Create Context w/ User [2 args]
- 3. Switch to that Context

### 1) Take a backup of the etcd cluster and save it to /opt/etcd-backup.db.
<details> 
  <summary markdown="span">Answer</summary>

    ETCD-BACKUP: 
        1) Create ETCD_ARGS 
        2) 

    root@controlplane:~# alias e="ETCDCTL_API=3 etcdctl"
    root@controlplane:~# ETCD_ARGS="--cert=/etc/kubernetes/pki/etcd/server.crt --cacert=/etc/kubernetes/pki/etcd/ca.crt --key=/etc/kubernetes/pki/etcd/server.key"
    root@controlplane:~# e snapshot save $ETCD_ARGS /opt/etcd-backup.db
    Snapshot saved at /opt/etcd-backup.db
</details>

### 2) Create a Pod called redis-storage with image: redis:alpine with a Volume of type emptyDir that lasts for the life of the Pod.
Specs on the below.
1) Pod named 'redis-storage' created
2) Pod 'redis-storage' uses Volume type of emptyDir
3) Pod 'redis-storage' uses volumeMount with mountPath = /data/redis
<details>
  <summary markdown="span">Answer</summary>


    root@controlplane:~# k run redis-storage --image=redis:alpine $D
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: redis-storage
  name: redis-storage
spec:
  volumes: 
    - name: empty-vol
      emptyDir: {}
  containers:
  - image: redis:alpine
    name: redis-storage
    volumeMounts:
        - name: empty-vol
          mountPath: /data/redis
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
        
</details>

### 3) Create a new pod called super-user-pod with image busybox:1.28. Allow the pod to be able to set system_time.
The container should sleep for 4800 seconds.
1) Pod: super-user-pod
2) Container Image: busybox:1.28
3) SYS_TIME capabilities for the conatiner?
<details>
  <summary markdown="span">Answer</summary>

    k run super-user-pod --image=busybox:1.28 $d --restart=Never -- /bin/sh -c "sleep 4800;"
    
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: super-user-pod
      name: super-user-pod
    spec:
      containers:
      - image: busybox:1.28
        args:
          - /bin/sh
          - -c 
          - sleep 4800;
        name: super-user-pod
        securityContext: 
            capabilities:
                add: [ "SYS_TIME" ]
        resources: {}
      dnsPolicy: ClusterFirst
      restartPolicy: Always
    status: {}

</details>

### 4) A pod definition file is created at /root/CKA/use-pv.yaml. Make use of this manifest file and mount the persistent volume called pv-1. Ensure the pod is running and the PV is bound.
mountPath: /data
persistentVolumeClaim Name: my-pvc
<details>
  <summary markdown="span">Answer</summary>

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: use-pv
  name: use-pv
spec:
  volumes:
    - name: host-vol
      persistentVolumeClaim:
        claimName: my-pvc
  containers:
  - image: nginx
    name: use-pv
    resources: {}
    volumeMounts:
        - name: host-vol
          mountPath: /data
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

apiVersion: v1
kind: PersistentVolumeClaim
metadata: 
    name: my-pvc
spec:
    volumeName: pv-1
    accessModes:
    - ReadWriteOnce
    resources:
        requests: 
            storage: 10Mi
</details>

### 5) Create a new deployment called nginx-deploy, with image nginx:1.16 and 1 replica. Record the version. Next upgrade the deployment to version 1.17 using rolling update. Make sure that the version upgrade is recorded in the resource annotation.
1) Deployment : nginx-deploy. Image: nginx:1.16
2) Image: nginx:1.16
3) Task: Upgrade the version of the deployment to 1:17
4) Task: Record the changes for the image upgrade
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# kc deploy nginx-deploy --image=nginx:1.16 --save-config    
    deployment.apps/nginx-deploy created

    root@controlplane:~# k set image deploy/nginx-deploy *=nginx:1.17
    deployment.apps/nginx-deploy image updated
</details>

### 6) Create a new user called john. Grant him access to the cluster. John should have permission to create, list, get, update and delete pods in the development namespace . The private key exists in the location: /root/CKA/john.key and csr at /root/CKA/john.csr.
Important Note: As of kubernetes 1.19, the CertificateSigningRequest object expects a signerName.
Please refer the documentation to see an example. The documentation tab is available at the top right of terminal.
1) CSR: john-developer Status:Approved
2) Role Name: developer, namespace: development, Resource: Pods
3) Access: User 'john' has appropriate permissions
<details>
  <summary markdown="span">Answer</summary>


kind: CertificateSigningRequest
apiVersion: certificates.k8s.io/v1
metadata:
    name: john-developer
spec:
    signerName: "kubernetes.io/kube-apiserver-client"
    usages: ["client auth"]
    request: |
        LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZEQ0NBVHdDQVFBd0R6RU5N
        QXNHQTFVRUF3d0VhbTlvYmpDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRApnZ0VQQURDQ0FRb0Nn
        Z0VCQU0wVmlIYVVGbWx4cjY2QVlKWG8va3VxRkIvTmF3dUlhR0h6TG5OVk5UbmJhTzJkCmgxQVcr
        Vk1oTHBnTzJyZTc0bHpydThKM2dJWDJQUDdmdFFuejZPdFlTMFFyZE54ak43SnlWbWY0bHhjdnkx
        M1kKNmFRYU1ORUNXS25wcmJuTmxVS3RHRVU1eC9NY0lSQkJyU2FHaklWUjNqUW5DNE10UGJ6S3Mr
        ZWNGeFZKZzdGMgppNDN1MERmemtRRXVyWEVGMVlka2N0SXZmcXVEQXJhcXFwZCtaOVVmb2REQ3kw
        aHY2ODNqR2F6elFyYWNUQUN5CkVEOTl3RHd5bzZvNzdZUTh0Z1hGU1pLV0gzcllrWDJHM01JeGlW
        bUhLWEZIQnprRUNHNWRYYlpBUkgvbGx5S1QKamE0c3ozNFVYU2xxVzc0MExuLzlBVTEzWGtKenNJ
        dmgxSnJvZW5VQ0F3RUFBYUFBTUEwR0NTcUdTSWIzRFFFQgpDd1VBQTRJQkFRQlBtNy9Vb1pBT0FZ
        OWErK3VEeFI2dGlxTEN6ckNoV2tUMjhQVldXVjZOeHBQQ2R1b0k3M3BUCjd1OTNzSFNDa21tQWIy
        ckN0WlFSQlpMRk9xaklMRzFTcHIrVmFWd2pqTVNYTUxFN1BOVUNYeDRCUDZ0VjRyOEYKYXdtU3JW
        SnRNZ2ZjSHZOcHFqTUE2S3QvQ3UwVFB6WS96SVpZcFI3SUJ6Y2FhWGxqK0FpUmMvUDBQelEyYWov
        Swpvc0dqSHRZRXZJaTE1aHNCYnRnUzhERURBQU1weFc5MDc0aGwrcFlndlBkbmg5M1d4bFVKdmdO
        WU84YktLQXhXCldIdmdEUEZhVDhFUjVBdGgrQmhLa0dtZHNBR01tZDNWMTBmeGZ5VVdnSGxhTzE2
        NzBBSS9ObHJSYU5RRUV4WHcKaE5FYlRLcGgrT0xKcEl0dG42K1U2dGhNaTVzeXZ3VnEKLS0tLS1F
        TkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==



    root@controlplane:~# k create role developer --verb=create,list,get,update,delete --resource=pods -n=development
    role.rbac.authorization.k8s.io/developer created
    root@controlplane:~# k create rolebinding developer --role=developer --user=john  -n=development
    rolebinding.rbac.authorization.k8s.io/developer created
    

    kg csr/john-developer -ocustom-columns=:.status.certificate | xargs | base64 --decode > john.crt
    cp /root/CKA/john.csr john.csr
    cp /root/CKA/john.key john.key
    k config set-credentials john --client-certificate=john.crt --client-key=john.key --username=john
    root@controlplane:~# k config set-context john@kubernetes --cluster=kubernetes --user=john --namespace=development
    root@controlplane:~# k config use-context john@kubernetes


    root@controlplane:~# k auth can-i -n=development --as=john --list | grep "pods\|Resources"
    Resources                                       Non-Resource URLs   Resource Names   Verbs
    pods                                            []                  []               [create list get update delete]
</details>


### 7) Create a nginx pod called nginx-resolver using image nginx, 
expose it internally with a service called nginx-resolver-service. 
Test that you are able to look up the service and pod names from within the cluster. Use the image: busybox:1.28 for dns lookup. 
Record results in /root/CKA/nginx.svc and /root/CKA/nginx.pod
- Pod: nginx-resolver created
- Service DNS Resolution recorded correctly
- Pod DNS resolution recorded correctly
<details>
  <summary markdown="span">Answer</summary>
    
    root@controlplane:~#  k run nginx-resolver --image=nginx --port=80
    pod/nginx-resolver created
    
    root@controlplane:~# k expose pod/nginx-resolver --type=ClusterIP --name=nginx-resolver-service
    service/nginx-resolver exposed
    
    # POD-SERVICE
    root@controlplane:~# k run $RANDOM --image=busybox:1.28 --restart=Never --rm -it -- nslookup nginx-resolver-service | tee /root/CKA/nginx.svc
    Server:    10.96.0.10
    Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local
    
    Name:      nginx-resolver-service
    Address 1: 10.98.164.48 nginx-resolver-service.default.svc.cluster.local
    pod "28192" deleted
    

    # POD-NAME
    root@controlplane:~# k run $RANDOM --image=busybox:1.28 --restart=Never --rm -it -- nslookup 10-50-192-1.default.pod | tee /root/CKA/nginx.pod
    Server:    10.96.0.10
    Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local
    
    Name:      10-50-192-1.default.pod
    Address 1: 10.50.192.1 10-50-192-1.nginx-resolver-service.default.svc.cluster.local
    pod "2399" deleted
    
    ## WGET EXAMPLE
    root@controlplane:~# k run $RANDOM --image=busybox:1.28 --restart=Never --rm -it -- /bin/sh  
    If you don't see a command prompt, try pressing enter.
    Address 1: 10.98.164.48 nginx-resolver-service.default.svc.cluster.local
    / # wget -O- http://nginx-resolver-service
    Connecting to nginx-resolver-service (10.98.164.48:80)
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>


NOTE: If stuff is screwed up, lookup Kube-DNS:

    root@controlplane:~# k run $RANDOM --image=busybox:1.28 --rm -it -n=kube-system -- /bin/sh
    If you don't see a command prompt, try pressing enter.
    / # nslookup kube-dns
    Server:    10.96.0.10
    Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local
    
    Name:      kube-dns
    Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

</details>

### 8) Create a static pod on node01 called nginx-critical with image nginx and make sure that it is recreated/restarted automatically in case of a failure.
Use /etc/kubernetes/manifests as the Static Pod path for example.
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k run nginx-critical --image=nginx $d
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx-critical
  name: nginx-critical
spec:
  containers:
  - image: nginx
    name: nginx-critical
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
    
root@controlplane:~# kg pods -owide | grep -e "NAME\|nginx-critical" 
NAME                          READY   STATUS             RESTARTS   AGE     IP            NODE           NOMINATED NODE   READINESS GATES
nginx-critical-controlplane   1/1     Running            0          2m26s   10.50.0.4     controlplane   <none>           <none>
root@controlplane:~# kg pods/nginx-critical-controlplane -ocustom-columns=:.spec.nodeName

controlplane
root@controlplane:~# cat /etc/kubernetes/manifests/nginx-critical.yaml | grep nodeName: 
  nodeName: node01

root@controlplane:~# ssh node01
root@node01:~# vi /etc/kubernetes/manifests/nginx-critical.yaml
</details>

## REVIEW          

### 6) Certificate Steps: Complete New User

#### 1) Create KEY/CSR/CRT

    a) Create Local Key/CSR

        openssl genrsa -out myuser.key 2048
        openssl req -new -key myuser.key -out myuser.csr

    b)  Create K8s CSR (MANUAL)

        cat myuser.csr | base64 | tr -d "\n"

    c) Approve CSR & Get CRT

       kubectl certficate approve csr/[CSR]
       kubectl get csr[CSR] -ocustom-columns=:.status.certificate | xargs | base64 --decode

#### 2) Create Role/Rolebinding

        k create role [ROLE] --verb=create,list,get,update,delete --resource=pods $d
        k create rolebinding [RB] --role=[ROLE] [--user|--groups|--serviceaccount]

### 3) Update KubeConfig
    # Create User Entry
    1) kubectl config set-credentials [USER] --client-key=[KEY] --client-certificate=[CERT] --embed-certs=true
    # Create Context
    2) kubectl config set-context [USER@CLUSTER] --cluster=[CLUSTER] --user=[USER] #CLUSTER=kubernetes, usually
    # Switch to that context
    3) kubectl config use-context [USER@CLUSTER]

kind: CertificateSigningRequest
apiVersion: certificates.k8s.io/v1
metadata:
    name: john-developer
spec:
    signerName: "kubernetes.io/kube-apiserver-client"
    usages: ["client auth"]
    request: |
        LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZEQ0NBVHdDQVFBd0R6RU5N
        QXNHQTFVRUF3d0VhbTlvYmpDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRApnZ0VQQURDQ0FRb0Nn
        Z0VCQUxoTVVaODJYenBydFY0ZHY4VytBanVqZ3M2dDRhQVNtNTVKVThuS2NLOTJxNEsrCndkbGta
        Zkw3NkhQWDhEYWIxTmt4RTZwWnFuZmQ4QUQ5bkQ0c0QydmQ2alV5bDAyNDFCc2NtbDMwZ3YvSkNr
        VjUKNkZSVld6ZVlVdjc5MmF1WEZxSUJzR2JjUVBvU3hxYUZGR0VBWS9ZU0Nla2xnYlZGNnNCZWxQ
        M2NKRVl6Sms4aQp1ZVR6ZmlUaTJZb3pLN0FSU2lqQ1JNTTkyNWVFYktoZjIzZmhEZEY3SHQyMXp5
        SzYyKzRsZFpFV2wzODVqOVpnCnhPdEswem5OLzRwZG9LaE5XcGxKNjJTdjZ3NStWWitCMldWVDlj
        S1lnS1NlazhQczhWSjdXZjd2THE1alZSbDYKQlpBdkJURy9hZDl3SmVLOHpwSDB5UmNVMmlLaEYr
        b3AvQ3BFdHRNQ0F3RUFBYUFBTUEwR0NTcUdTSWIzRFFFQgpDd1VBQTRJQkFRQkxzTTQ0d0pWQ2FT
        b0xoRHFGcTdvaHlXbzNYdE0xeG5QTnVXUjBoeVNkcWt1MkJMcjZYaVVmCnNPdk9ieGhsREtLdUR4
        aWpaTXFaRjducGFpSkNYeEFSMlcxMzdmeWVFdmVTU3gzdXJOUWcybHpURHpMRUdLV3gKYjBPNEc2
        SjZUNEVyYklZcVpqOXg3dE9xeGhha3dqMTMyNi96d00rb3h6NG10OUpieGppZGpiM2VUcHlZMy9G
        awpmcnZMTHI3dmIxZktpUUlRQ25OT3IrblYzMFFZMWRmUGE2eGk3bVVaM2doeHJiRnRmQ2ZkVkx5
        MzN2alN2V0MrCks3YmQwSTJEZlhFMW5kd3BMNEJxUkgyQi9ZZHVWR3FsN3BwR0tPYmMvMlNHT0NE
        azJvK3BRSGEvZzdia2Q1THEKYkk4ZTJWTGMzeXM0cHRiVXZnRDlxZzNpUjlzQ2phRzYKLS0tLS1F
        TkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==



BUSYBOX NOTE:
k run super-user-pod --image=busybox:1.28 $d --restart=Never -- /bin/sh -c "sleep 4800;"

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: super-user-pod
  name: super-user-pod
spec:
  containers:
  - args:
    - /bin/sh
    - -c
    - sleep 4800
    image: busybox:1.28
    name: super-user-pod
    resources: {}
    securityContext:
      capabilities:
        add: [ "SYS_TIME" ]
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}


kind: PersistentVolumeClaim
apiVersion: v1
metadata:
    name: pvc-1
spec:
   accessModes: ["ReadWriteOnce"]
   resources:
      requests:
        storage: 10Mi
   volumeMode: Filesystem
   volumeName: pv-1

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: use-pv
  name: use-pv
spec:
  volumes: 
    - name: pvc-vol
      persistentVolumeClaim:
        claimName: pvc-1
  containers:
  - image: nginx
    name: use-pv
    resources: {}
    volumeMounts:
        - name: pvc-vol
          mountPath: /data
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}


kind: CertificateSigningRequest
apiVersion: certificates.k8s.io/v1
metadata:
    name: john-developer
spec:
    signerName: "kubernetes.io/kube-apiserver-client"
    usages: [ "client auth" ]
    request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZEQ0NBVHdDQVFBd0R6RU5NQXNHQTFVRUF3d0VhbTlvYmpDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRApnZ0VQQURDQ0FRb0NnZ0VCQU8wdFFNSlN1bXBKSUZmbURxSDNHOHNVRjdiWm5KRnhJclJ2MFBBMWZYbjUzNWYxCjZsUTZSN3NxSDFkTE9BcHduNmRRRUZLSFJJZ0s3anJHcWFwRDZvN3F0eVZxemVDM000ckxPZmxScjdvZE01VFAKKzlYTDN6MUFZQUZ4dzlvYWZFTHVScXlvdHBYOGZ3NkRPVVRqQVdNdGFrR0FzZkRSMEZ3bU0yUmZmTU1KYXpaRgpqVk5La3F3dUp5VEVNVlM3NmY3Y28xc2czVGkyc2xyWHFVTXRZT0cxSVRNTVRBRGdkRDNQSEI0OWI2SHNycUxVCnNPQXhqeThKYWFYcGRpSEtBTDJ3dlhjTjlOcDdDdUd5UWovRjV2OHNUZGJ4SnpuTFJOU0FITExjQVA0VzB6aWgKYURZUG9ZUG5YZ3lRVjVib21tUVZvaFkwWHN0N0dsbWRUWWhWdC9NQ0F3RUFBYUFBTUEwR0NTcUdTSWIzRFFFQgpDd1VBQTRJQkFRQzU5T0svTnREVHN0ZHh5d0RYRFR0dXhlcHJvbU82NnpKUVlvaFF3YUtmN3gwS21xcXpvSWJGCk9ZN2pNRHA5amtKRytmRkM2dGwyNHVUQW9qaVpBaEZRSkpFRDBORHQvTHV6a1ZtREdNbzVaSlMyZzZlaVhqaTQKNm9zMUFJQTkxRjVQQndXb1EzY1N6MEcva2pXUGZQNzQrUWhlMHladHdyQ0tNYnl3WlhRWUlxY2VQWGNkK0w4bQpnS1R6YWVGOFJiUGtLOVNhckVRUHl2SkViZVhKVXlMWmVNUmdQSWlMS2QwMGZKcnNOVjBQWDY2UVlSY21NRHVlClFpUWVnaDBvYU1ub0FZSjVqK2k0Wnl4NDNRcGNrVGliam1xVE1tSmVaakxBOGUxalMrbURTbENFSVBaM05IYkUKVFVDZWtVVXpsY056bEIzY1BSbTBNalJxQWJxamtkU20KLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==


FORGOT TO GRAB CERTIFICATE


root@controlplane:~# k config set-credentials john --embed-certs=true --client-certificate=/root/CKA/john.crt --client-key=/root/CKA/john.key --username=john
User "john" set.
root@controlplane:~# k config set-context john@kubernetes --cluster=kubernetes --user=john --namespace=development
Context "john@kubernetes" created.
root@controlplane:~# k config use-context john@kubernetes
Switched to context "john@kubernetes".
root@controlplane:~# k auth can-i list pods 
yes
root@controlplane:~# k config use-context kubernetes-admin@kubernetes
Switched to context "kubernetes-admin@kubernetes".
root@controlplane:~# k auth can-i list pods 
yes
root@controlplane:~# k auth can-i list deploy 
yes
root@controlplane:~# k config use-context john@kubernetes
Switched to context "john@kubernetes".
root@controlplane:~# k auth can-i list pods 
yes
root@controlplane:~# k auth can-i list deploy 
no

















