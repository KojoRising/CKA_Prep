## CKA Curriculum Checklist
### 1) 25% - Cluster Architecture, Installation, & Configuration
1) ***Manage role based access control (RBAC)***
2) Use Kubeadm to install a basic cluster
3) Manage a highly-available Kubernetes cluster
4) Provision underlying infrastructure to deploy a Kubernetes cluster
5) ***Perform a version upgrade on a Kubernetes cluster using Kubeadm***
6) ***Implement etcd backup and restore***
### 2) 15% - Workloads & Scheduling
1) **Understand deployments and how to perform rolling update and rollbacks**
2) ***Use ConfigMaps and Secrets to configure applications***
3) **Know how to scale applications**
4) *Understand the primitives used to create robust, self-healing, application deployments*
5) **Understand how resource limits can affect Pod scheduling**
6) Awareness of manifest management and common templating tools
### 3) 20% - Services & Networking
1) Understand host networking configuration on the cluster nodes
2) Understand connectivity between Pods
3) **Understand ClusterIP, NodePort, LoadBalancer service types and endpoints**
4) *Know how to use Ingress controllers and Ingress resources*
5) **Know how to configure and use CoreDNS**
6) **Choose an appropriate container network interface plugin**
### 4) 10% - Storage
1) Understand storage classes, persistent volumes
2) Understand volume mode, access modes and reclaim policies for volumes
3) Understand persistent volume claims primitive
4) Know how to configure applications with persistent storage
### 5) 30% - Troubleshooting
1) Evaluate cluster and node logging
2) Understand how to monitor applications
3) Manage container stdout & stderr logs
4) Troubleshoot application failure
5) Troubleshoot cluster component failure
6) Troubleshoot networking

# 1) Remembrance

### 1 | Intro
### 2 | Core Concepts
### 3 | Scheduling
### 4 | Logging & Monitoring
### 5 | Application Lifecycle Management
### 6 | Cluster Maintenance
#### 6.1 | OS-Upgrades
#### 6.2 | Cluster-Upgrades
#### 6.3 | Backup-&-Restore-Methods(etcd)
MAIN-STEPS
0) Save Args
> alias e='ETCDCTL_API=3 etcdctl'
> ETCD_ARGS="--key=/etc/kubernetes/pki/etcd/server.key --cert=/etc/kubernetes/pki/etcd/server.crt --cacert=/etc/kubernetes/pki/etcd/ca.crt"
1) Snapshot Save
> e snapshot save $ETCD_ARGS /opt/snapshot-pre-boot.db
2) Snapshot Restore 
> e snapshot restore $ETCD_ARGS --data-dir=/var/lib/etcd-backup /opt/snapshot-pre-boot.db
3) Change etcd yaml
> STR="/var/lib/etcd"
> sed "s;$STR;$STR-backup;" -i /etc/kubernetes/manifests/etcd.yaml``
### 7 | Security
#### 7.1 | View-Certificate-Details
CRT_DIR="/etc/kubernetes/pki"
ETCD:
--cert-file=$CRT_DIR/etcd/server.crt
--trusted-ca-file=$CRT_DIR/etcd/ca.crt
KUBE-APISERVER
--trusted-certfile
--trusted-private-key-file

--etcd-certfile
--etcd-keyfile
--etcd-cacert

--kubelet-client-cert
--kubelet-client-key



#### 7.2 | Certificates-API

OPENSSL

| Step   |  ARG-COUNT    |
| ------ | ------------- |
| Admin1 | 1             |             
| Admin2 | 4             |         
| Admin3 | 4             |            
| CA1    | 1             |
| CA2    | 4             |
| CA3    | 5             |

#### 7.3 | Kube-Config
#### 7.4 | RBAC
#### 7.5 | Cluster-Roles
#### 7.6 | Service-Accounts
#### 7.7 | Image-Security
    
    > k create secret docker-registry NAME
        --docker-server
        --docker-username=user 
        --docker-password=password 
        --docker-email=email

    > spec.containers[*]
        imagePullSecrets
        - name: [SECRET-NAME]

#### 7.8 | Security-Context
#### 7.9 | Network-Policies
### 9 | Networks

#### CNI-Weave
- Components: Daemonset
- Directories: /etc/cni/net.d, /opt/cni/bin
- Responsible:
    1) Pod IPs - via IPALLOC_RANGE env variable
       
#### CNI-Flannel
- Components: Daemonset, ConfigMap
- Directories: /etc/cni/net.d, /opt/cni/bin
- Responsible:
    1) Pod IPs - via /etc/cni/net.d/cni-conf.json File (Intra-Container) 
        - grep "Network"

#### Kube-Proxy
- Components: Daemonset, ConfigMap
- Responsible: 
    1) Forwarding Rules
    2) Kube-Proxy Mode (K Logs)

#### DNS
- Components: Deployment(coredns), ConfigMap(coredns), SVC (kube-dns)
- Directories: /etc/coredns/Corefile (INTRA-POD)
- Responsible:
    1) Name Resolution - Hostname-IP Translation  
    2) Cluster's Top-Level-Domain
    3) Whether Pod Records are created or not

## 1) FINAL FINAL

### 1 | Intro
### 2 | Core Concepts
### 3 | Scheduling
Custom-Scheduler Changes: [2,2+2,2+2]
TWO-FOUR-FOUR!!

### 4 | Logging & Monitoring
### 5 | Application Lifecycle Management
### 6 | Cluster Maintenance
#### 6.1 | OS-Upgrades
#### 6.2 | Cluster-Upgrades
#### 6.3 | Backup-&-Restore-Methods(etcd)
### 7 | Security
#### 7.1 | View-Certificate-Details
openssl genrsa -out admin.key 2048
openssl req -new -key admin.key -out admin.csr -subj "/CN=kube-admin\O=system:masters"
openssl x509 -req -in admin.csr -out admin.crt -CA ca.crt -CAkey ca.key

openssl genrsa -out ca.key 2048
openssl req -new -key ca.key -out ca.csr -subj "/CN=KUBERNETES-CA"
openssl x509 -req -in ca.csr -out ca.crt -signkey ca.key
#### 7.2 | Certificates-API
kg csr/[CSR] $CC=.status.certificate
kubectl proxy && curl http://localhost:6443 -k
#### 7.3 | Kube-Config
kube-config Fields
    1) "cluster" [CA/S]
    2) "user" [CC/CK]
    3) "context" [N/U/C]

k config get-[clusters/contexts/users]
k config view --kubeconfig=CUSTOM-CONFIG

k config set-credentials USER --username=USER --embed-certs --client-certificate=CERT --client-key=KEY
k config set-context CONTEXT --user=USER --cluster=CLUSTER --namespace=NAMESPACE
=> 4 CUSTOM-KUBE-CONFIGS 
#### 7.4 | RBAC
kc role [ROLE] --verb=create,watch,get,update,delete --resource=pods,sc $d
Rolebinding/ClusterRolebinding:
kc rolebinding [RB] --role=[ROLE] --user=[USER]

VERBS=[create, get, update, delete, list, watch]
#### 7.5 | Cluster-Roles
#### 7.6 | Service-Accounts
1) Yaml? [SIA]
2) Get tokens used in Service-account?
3) Set New Service-Account (On Deployment)?

#### 7.7 | Image-Security
#### 7.8 | Security-Context
Check current user for a pod? => kx my-pod -- whoami
#### 7.9 | Network-Policies
### 9 | Networks
#### 9.1 | Explore Environment
#### 9.2 | CNI Weave
RECALL:
1) /etc/cni/net.d/*. Contains net-conf.json
2) /opt/cni/bin

NOTE: Default Pod Gateway can change per node

root@controlplane:~# ip a | grep inet | grep weave 
    inet 10.50.0.1/16 brd 10.50.255.255 scope global weave

root@node01:~# ip a | grep inet | grep weave
  inet 10.50.192.0/16 brd 10.50.255.255 scope global weave
#### 9 | Networking General Question
    
# DNS Debugging:

root@controlplane:~# k run busybox2 --image=busybox:1.28 --rm -it -- /bin/sh  
If you don't see a command prompt, try pressing enter.
/ # nslookup nginx-resolver-service
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      nginx-resolver-service
Address 1: 10.102.237.141 nginx-resolver-service.default.svc.cluster.local
/ # exit
Session ended, resume using 'kubectl attach busybox2 -c busybox2 -i -t' command when the pod is running
pod "busybox2" deleted
root@controlplane:~# k run busybox2 --image=busybox --rm -it -- /bin/sh 
If you don't see a command prompt, try pressing enter.
/ # nslookup nginx-resolver-service
Server:         10.96.0.10
Address:        10.96.0.10:53

** server can't find nginx-resolver-service.default.svc.cluster.local: NXDOMAIN

*** Can't find nginx-resolver-service.svc.cluster.local: No answer
*** Can't find nginx-resolver-service.cluster.local: No answer
*** Can't find nginx-resolver-service.us-central1-a.c.kk-lab-prod.internal: No answer
