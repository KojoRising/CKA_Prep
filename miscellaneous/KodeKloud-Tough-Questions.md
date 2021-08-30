# Commonly Missed k8s CKA Questions

## Best Question Sections
#### 6.2 | Cluster-Upgrades
#### 7.2 | Certificates-API
#### 7.5 | Cluster-Roles
#### 7.9 | Network-Policies

## 1 | KodeKloud | Commonly Missed

### 1 | Intro
### 2 | Core Concepts
### 3 | Scheduling
### 4 | Logging & Monitoring
### 5 | Application Lifecycle Management
### 6 | Cluster Maintenance

#### 6.1 | OS-Upgrades
#### 6.2 | Cluster-Upgrades 
#### 6.3 | Backup & Restore Methodologies 

### 7 | Security


#### 7.1 | View-Certificate-Details
#### 7.2 | Certificates-API
#### 7.3 | Kube-Config
#### 7.4 | RBAC
#### 7.5 | Cluster-Roles
#### 7.6 | Service-Accounts
#### 7.7 | Image-Security
#### 7.8 | Security-Context
1) What is the user used to execute the sleep process within the ubuntu-sleeper pod?
5) Update pod ubuntu-sleeper to run as Root user and with the SYS_TIME capability.
#### 7.9 | Network-Policies
10) Create a network policy to allow traffic from the Internal application only to the payroll-service and db-service.
Use the spec given on the below. You might want to enable ingress traffic to the pod to test your rules in the UI.
Policy Name: internal-policy
Policy Type: Egress
Egress Allow: payroll
Payroll Port: 8080
Egress Allow: mysql
MySQL Port: 3306

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

RECALL:

1) ROLES.CLUSTERROLES => rules.VARR
2) ROLEBINDINGS/CLUSTERROLEBINDINGS => roleRef.NAK/subjects.NAKN


1) How can you find cluster-wide authorizations?
> k get pod -n=kube-system -oyaml | grep authorization-mode


1) How can you check if you can get a particular Resource-By-Name?

        root@controlplane:~# k auth can-i get pods -n=blue --as=dev-user
        no
        root@controlplane:~# k auth can-i get pods/blue-app -n=blue --as=dev-user
        yes
        root@controlplane:~# k auth can-i get pods/blue-ap -n=blue --as=dev-user
        no


#### 7.6 | Service Account  https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/#serviceaccount-admission-controller
1) How can you find the serviceaccount used for a deployment?

<details>
  <summary markdown="span">Answer</summary>

    Check the deployment's PODS (Not Deployment directly)

    controlplane $ k get deploy/web-dashboard -oyaml | grep service
    controlplane $ k get pod/web-dashboard-548dff47bd-l8kd7 -oyaml | grep service
        - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      serviceAccount: default
      serviceAccountName: default
</details>

1) How can you get service account tokens in a service?
> k get sa/dashboard-sa -ocustom-columns=:.secrets[*].name

2) How can you set a new service account on a deployment?
> k set serviceaccount [RSC]/[NAME] [SA]

3) Where are Service-Accounts mounted by default in Container? 
> /var/run/secrets/kubernetes.io/serviceaccount

4) How can you check permissions a particular SA gives?
> k get rolebindings,clusterrolebindings -A -ocustom-columns=NAME:.metadata.name,ACCOUNT:.subjects[*].name | grep [ACCOUNT]


### 8 | Storage
### 9 | Networking
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
