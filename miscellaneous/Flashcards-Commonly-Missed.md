## 1 | FLASHCARDS | Commonly Missed

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
1) Authorization Modes allowed [4+2]?
#### 7.6 | Service-Accounts
1) Default Container Location -> /var/run/secrets/kubernetes/io/serviceaccount
2) Check SA Permissions?
- k get rolebindings/clusterrolebindings -ocustom-columns=NAME:.metadata.name,RSC:.subjects[*].name | grep -e "$SA_NAME\|NAME"
#### 7.7 | Image-Security

#### 7.8 | Security-Context
#### 7.9 | Network-Policies
1) netpol.spec [PIPE]? 
