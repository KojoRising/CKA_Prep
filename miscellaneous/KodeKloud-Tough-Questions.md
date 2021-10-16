# Commonly Missed k8s CKA Questions

## Best Question Sections
#### 6.2 | Cluster-Upgrades
#### 7.2 | Certificates-API
#### 7.5 | Cluster-Roles
#### 7.7 | Image-Security
#### 7.9 | Network-Policies
#### 9.2 | CNI Weave
#### 9.4 | Service Networking


## 1 | KodeKloud | Commonly Missed

### 1 | Intro

### 2 | Core Concepts

### 3 | Scheduling

### 4 | Logging & Monitoring

### 5 | Application Lifecycle Management

### 6 | Cluster Maintenance

#### 6.1 | OS-Upgrades
#### 6.2 | Cluster-Upgrades <==
#### 6.3 | Backup & Restore Methodologies <== 

### 7 | Security
#### 7.1 | View-Certificate-Details
#### 7.2 | Certificates-API <==
#### 7.3 | Kube-Config <==
#### 7.4 | RBAC <==
#### 7.5 | Cluster-Roles <==
#### 7.6 | Service-Accounts <==
1) How can you get service account tokens in a service?
> k get sa/dashboard-sa -ocustom-columns=:.secrets[*].name

2) How can you set a new service account on a deployment?
> k set serviceaccount [RSC]/[NAME] [SA]

3) Where are Service-Accounts mounted by default in Container?
> /var/run/secrets/kubernetes.io/serviceaccount

4) How can you check permissions a particular SA gives?
> k get rolebindings,clusterrolebindings -A -ocustom-columns=NAME:.metadata.name,ACCOUNT:.subjects[*].name | grep [ACCOUNT]

#### 7.7 | Image-Security <==
#### 7.8 | Security-Context <==
1) What is the user used to execute the sleep process within the ubuntu-sleeper pod?
5) Update pod ubuntu-sleeper to run as Root user and with the SYS_TIME capability.
#### 7.9 | Network-Policies <==
10) Create a network policy to allow traffic from the Internal application only to the payroll-service and db-service.

### 9 | Networks
#### 9.1 | Explore Environment
#### 9.2 | CNI Weave
#### 9.3 | Deploy Networking Solution
#### 9.4 | Networking Weave
2) What is the Networking Solution used by this cluster?
> cat /etc/cni/net.d/* | grep name
6) What is the POD IP address range configured by weave?
> root@controlplane:~# kd ds/weave-net -n=kube-system | grep IPALLOC_RANGE
>  root@controlplane:~# ip -f inet addr show weave | grep inet
7) What is the default gateway configured on the PODs scheduled on node01?
#### 9.5 | Service Networking
1) What network range are the nodes in the cluster part of?
> ip -f inet addr | grep inet | grep eth0
2) What is the range of IP addresses configured for PODs on this cluster?
> ip -f inet addr | grep inet | grep weave
> Check IPALLOC_RANGE
3) What is the IP Range configured for the services within the cluster?
> cat etc/kubernetes/manifests/kube-apiserver.yaml | grep ip-range
5) What type of proxy is the kube-proxy configured to use?
#### 9.6 | ExploreDNS
8) What is the root domain/zone configured for this kubernetes cluster?
10) What name can be used to access the hr web server from the test Application? <== GREAT ONE!!!
#### 9.7 | Ingress-1
#### 9.8 | Ingress-2




## GENERAL FACTS

### 1 | Intro
### 2 | Core Concepts
### 3 | Scheduling
### 4 | Logging & Monitoring
### 5 | Application Lifecycle Management
### 6 | Cluster Maintenance
### 7 | Security
#### 7.1 | View-Certificate-Details
#### 7.2 | Certificates-API
#### 7.3 | Kube-Config
#### 7.4 | RBAC
#### 7.5 | Cluster-Roles
#### 7.6 | Service-Accounts
#### 7.7 | Image-Security
#### 7.8 | Security-Context
#### 7.9 | Network-Policies
### 8 | Storage
### 9 | Networking
#### 9.1 | Explore Environment
#### 9.2 | CNI Weave
#### 9.3 | Deploy Networking Solution
#### 9.4 | Networking Weave

#### 9.5 | Service Networking
Tags: ConfigMap, k logs,
#### 9.6 | ExploreDNS
Tags: ConfigMap, k logs, Deploy,
1) coreDNS General 
   - Components
   - Is a Deployment
   - Exposed via "kube-dns" svc
- Corefile - Configmap/coredns 
   - Passed to deploy/coredns
   - Mounted in - /etc/coredns/Corefile
#### 9.7 | Ingress-1
#### 9.8 | Ingress-2
### 10 | Design & Install a k8s Cluster
### 11 | Install k8s the Kubeadm Way
### 12 | End2End_Tests_K8s_Cluster


<details>
  <summary markdown="span">Answer</summary>

</details>

<details>
  <summary markdown="span">Answer</summary>

</details>

<details>
  <summary markdown="span">Answer</summary>

</details>
