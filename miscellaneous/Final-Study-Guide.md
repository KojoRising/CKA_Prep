## YAML REMEMBERING

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
==== KUBE-CONFIG-YAML ====
1) "cluster" [CA/S]
2) "user" [CC/CK]
3) "context" [N/U/C]
#### 7.4 | RBAC
==== Role/ClusterRole ====
1) rules [VARR]
   
==== Rolebinding/ClusterRolebinding ====
1) roleRef[NAK]
2) subjects [NAKN]
#### 7.5 | Cluster-Roles
#### 7.6 | Service-Accounts
1) Yaml? [SIA]
#### 7.7 | Image-Security
#### 7.8 | Security-Context
1) What is the user used to execute the sleep process within the ubuntu-sleeper pod?
5) Update pod ubuntu-sleeper to run as Root user and with the SYS_TIME capability.
#### 7.9 | Network-Policies

`
# Remembrance

### 1 | Intro
### 2 | Core Concepts
### 3 | Scheduling
### 4 | Logging & Monitoring
### 5 | Application Lifecycle Management
### 6 | Cluster Maintenance
### 7 | Security


#### 7.1 | View-Certificate-Details
1) APISERVER > --tls-{cert,private-key}-file
> apiserver.{key, crt}
2) Etcd > --etcd-{cafile, certfile, keyfile}
> apiserver-etcd-client.{key,crt}
3) Kubelet > --kubelet-client-{certificate, key}
> apiserver-kubelet-client.{key,crt}
#### 7.2 | Certificates-API
#### 7.3 | Kube-Config
#### 7.4 | RBAC
#### 7.5 | Cluster-Roles
1) ROLES.CLUSTERROLES => rules.VAR
2) ROLEBINDINGS/CLUSTERROLEBINDINGS => roleRef.NAK/subjects.NAKN
#### 7.6 | Service-Accounts
#### 7.7 | Image-Security
    
    > k create secret docker-secret
    > spec.containers[*]
        imagePullSecrets
        - name: [SECRET-NAME]
#### 7.8 | Security-Context
#### 7.9 | Network-Policies
