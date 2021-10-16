# FINAL FINAL Study Guide

curl https://raw.githubusercontent.com/Kojorising/CKA_Prep/main/alias.sh > alias.sh && source alias.sh && rm alias.sh


### 1 | Intro

### 2 | Core Concepts
#### 2.1 | Etcd
#### 2.2 | Kube-API Server 
#### 2.3 | Kube Controller Manager
#### 2.4 | Kube Scheduler
#### 2.5 | Services | ClusterIP,LoadBalancer,NodePort

### 3 | Scheduling
#### 3.1 | Manual Scheduling
#### 3.2 | Taints & Tolerations
#### 3.3 | NodeSelectors
#### 3.4 | Node Affinity
#### 3.5 | DaemonSets
#### 3.6 | Static Pods
==> Also Mirror Pods
#### 3.7 | Multiple Schedulers

### 4 | Logging & Monitoring
#### 4.1 | Monitor Cluster Components
#### 4.2 | Monitor Application Logs

### 5 | Application Lifecycle Management
==> Deployments/Pods/Init-Containers, etc. (Basically from CKAD)

### 6 | Cluster Maintenance
#### 6.1 | OS-Upgrades
#### 6.2 | Cluster-Upgrades
==> kubeadm upgrade plan
==> kubeadm upgrade apply v1.19.15 (Upgrading all Master-Node Components)
==> kubeadm upgrade node (Upgrading Worker Nodes)
==> systemctl restart kubelet (IF NOT RESTARTING)
#### 6.3 | Backup-&-Restore-Methods(etcd)
==> etcdctl snapshot save /opt/snapshot.db // Saving Etcd Backup
==> etcdctl snapshot restore /opt/snapshot.db --data-dir=/var/lib/etcd-backup // Restoring etcd backup

### 7 | Security
#### 7.1 | TLS Certificate Creation/View-Certificate-Details
Overview: Key, CSR (Certificate Signing Request), CRT (Certifiicate) via Kubectl/Kubeadm/OpenSSL
=> Creating Admin Credentials
==> openssl genrsa -out admin.key 2048
==> openssl req -new -in admin.key -out admin.csr -subj="CN=/kubernetes-admin"
==> openssl x509 -req -in admin.csr -out admin.crt -CA ca.crt -CAkey ca.key 

=> Creating Self-Signed Certificate for K8s
==> openssl genrsa -out ca.key 2048
==> openssl req -new -in ca.key -out ca.csr -subj="CN=/kubernetes-ca"
==> openssl x509 -req -in ca.csr -out ca.crt -signkey ca.key

=> Translating CSRs/CRTs
==> cat CSR | openssl req -text -noout
==> cat CRT | openssl x509 -text -noout
#### 7.2 | Certificates-API
- Creating Kubernetes CSR 
==> kubectl certificate [approve/deny] csr/CSR
- Kubeadm Certs-Related Commands
==> kubeadm certs check-expiration
==> kubeadm certs renew
#### 7.3 | Kube-Config
- Kubectl config | Creating User + Contexts
==> k config set-credentials [JOHN] --username=john --client-certificate=/john.crt --client-key=/john.key --embed-certs
==> k config set-context [USER@CLUSTER] --cluster=kubernetes --user=john --namespace=NAMESPACE
#### 7.4 | RBAC
kc role [ROLE] --verb=create,get,update,delete,watch,list --resource=pods,sc
kc rolebinding [RB] --role=[ROLE] --user=[USER] --serviceaccount=default:my-service-account
#### 7.5 | Cluster-Roles
- Similar to Above
#### 7.6 | Service-Accounts
- Setting namespaces in pods/deployments
- Attaching secrets to ServiceAccounts
#### 7.7 | Image-Security
- Creating docker-registry secrets and using them to pull from private repositories
- Putting these secrets in a pod to be able to pull private images
#### 7.8 | Security-Context
- From CKAD
#### 7.9 | Network-Policies
- Good amount of Practice on these
- Configuring Network Policies to
1) Default-Deny-All
2) Default-Accept-All
3) Accept-Traffic-Only-Certain-Port
4) Accept-Traffic-Current-Namespace
5) Accept-Traffic-All-Namespaces-Except-Current
etc. etc. ... 
   
### 8 | Storage
- PVs, PVCs, SCs, basically from CKAD, etc. (Not using any Cloud Providers, tho)

### 9 | Networks
#### 9.1 | Explore Environment
#### 9.2 | CNI Weave
#### 9.3 | Deploy-Network-Solution
- Installing Flannel onto Fresh Cluster
#### 9.4 | Networking-Weave
- Installing Weave onto Fresh Cluster
- Changing/Configuring Default Pod IP Subnet 
#### 9.5 | Service-Networking
- Configuring Default ClusterIP Service's IP Subnet
#### 9.6 | Explore-DNS
- CoreDNS (ConfigMap+Deployment+KubeDNS Service)
#### 9.7 | Ingress
- Ingress Controller (Deployment + CM + SA + Roles/Rolebindings)
- Ingress Resource 
    - Single IP,Single Host,Multiple Paths
    - Single IP,Multiple Hosts (Name based virtual hosting)
### 10 | Design & Install a K8s Cluster
#### 10.1 | Choosing Kubernetes Infrastructure
#### 10.2 | Configuring High Availability
#### 10.3 | HA Etcd

### 11 | Install Kubernetes "The Kubeadm Way"
- Basically given a set of VMs (we used Vagrant), install a Fresh K8s Cluster on top of them. Main Steps were:
1)
> a) Letting iptables see bridged traffic
> b) Installing/Configuring Container Runtime
> c) Configuring CGroup Driver (between Kubelet & Container runtime)
2) 
> a) Install KubeAdm, Kubectl, & Kubelet (On all Nodes)
> b) Initialize Controlplane - kubeadm init
3)
> a) Install Pod-Networking Solution
> b) Join Worker Nodes - kubeadm join

### 12 | E2E Tests on K8s Cluster (SKIPPED)

### 13 Troubleshooting 
find 
#### 13.1 | Application Failure
#### 13.2 | ControlPlane Failure
#### 13.3 | WorkerNode Failure
#### 13.4 | Network Failure




# Final Remembering

### 1 | Intro
### 2 | Core Concepts
### 3 | Scheduling
### 4 | Logging & Monitoring
### 5 | Application Lifecycle Management
### 6 | Cluster Maintenance
- USE "-v=6" for all kubeadm commands
- While upgrading Master, DON'T UPGRADE WORKER NODE!! (Until Master is done)
### 7 | Security
#### 7.9 | Network-Policies
- REVIEW FLASHCARDS
- REVIEW NEGATIONS
### 8 | Storage
### 9 | Network

### 10 | Design & Install a K8s Cluster
### 11 | Install Kubernetes "The Kubeadm Way"
### 12 | E2E Tests on K8s Cluster (SKIPPED)
### 13 Troubleshooting


### 1 | Intro

### 2 | Core Concepts
#### 2.1 | Etcd
#### 2.2 | Kube-API Server 
#### 2.3 | Kube Controller Manager
#### 2.4 | Kube Scheduler
#### 2.5 | Services | ClusterIP,LoadBalancer,NodePort

### 3 | Scheduling
#### 3.1 | Manual Scheduling
#### 3.2 | Taints & Tolerations
#### 3.3 | NodeSelectors
#### 3.4 | Node Affinity
#### 3.5 | DaemonSets
#### 3.6 | Static Pods
#### 3.7 | Multiple Schedulers

### 4 | Logging & Monitoring
#### 4.1 | Monitor Cluster Components
#### 4.2 | Monitor Application Logs

### 5 | Application Lifecycle Management

### 6 | Cluster Maintenance
#### 6.1 | OS-Upgrades
#### 6.2 | Cluster-Upgrades
#### 6.3 | Backup-&-Restore-Methods(etcd)

### 7 | Security
#### 7.1 | TLS Certificate Creation/View-Certificate-Details
#### 7.2 | Certificates-API
#### 7.3 | Kube-Config
#### 7.4 | RBAC
#### 7.5 | Cluster-Roles
#### 7.6 | Service-Accounts
#### 7.7 | Image-Security
#### 7.8 | Security-Context
#### 7.9 | Network-Policies
### 8 | Storage

### 9 | Networks
#### 9.1 | Explore Environment
#### 9.2 | CNI Weave
#### 9.3 | Deploy-Network-Solution
#### 9.4 | Networking-Weave
#### 9.5 | Service-Networking
#### 9.6 | Explore-DNS
#### 9.7 | Ingress
### 10 | Design & Install a K8s Cluster
#### 10.1 | Choosing Kubernetes Infrastructure
#### 10.2 | Configuring High Availability
#### 10.3 | HA Etcd

### 11 | Install Kubernetes "The Kubeadm Way"
### 12 | E2E Tests on K8s Cluster (SKIPPED)

### 13 Troubleshooting 
#### 13.1 | Application Failure
#### 13.2 | ControlPlane Failure
#### 13.3 | WorkerNode Failure
#### 13.4 | Network Failure
