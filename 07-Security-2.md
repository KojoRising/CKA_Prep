# Security | Certificates Overview


## A) KubeConfig

#### Recall | REST Call to API-Server Communication: Getting Current Pods (In this example)

1) ***REST***: *curl https://my-kube-playground:6443/api/v1/pods --key admin.key --cert admin.crt --cacert ca.crt*
2) ***Kubectl***: kubectl get pods --server my-kube-playground:6443 
    --client-key admin.key --client-certificate admin.crt --certificate-authority ca.crt

![img_12.png](assets/7_certificate_kube_config_intro.png)


*Obviously, this is incredibly tiresome. What can we do to alleviate this?*

### Enter KubeConfig

![img_13.png](assets/7_certificate_kube_config_2.png)

But by default, k8s looks for this file here: 

![img_6.png](assets/7_certificates_kube_config_3.png)

### Kube-Config Structure

#### Structure Overview

1) Clusters - Organized by environments, organizations, cloud-providers, etc.


2) Contexts - Define ***which user account*** can access ***which cluster***
    - Format: ***Cluster:User*** (For "name" field)   
    - NOTE: Can also tie a namespace to a particular context
    

3) Users - How you access these clusters 
    - These users may have different privileges on different clusters

#### Where do our 4 kubectl args (server spec, client-key, client-cert, CA) go in these 3 sections?

1) ***Cluster:*** 
    - --server my-kube-playground:6443 
2) ***User:*** 
   - --client-key admin.key
   - --client-certificate admin.crt
   - --certificate-authority ca.crt

![img_7.png](assets/7_certificate_kube_config_4.png)

![img_7.png](assets/7_certificate_kube_config_5.png)

#### Viewing Current Context ---> kubectl config view 
- By default - Looks for files in ***"$HOME/.kube/config"***
- But you can specify particular file - ***kubectl config view --kubeconfig=[MY_KUBE_CONFIG]***

![img_8.png](assets/7_certificate_kube_config_6.png)

#### Non-file certificate insertion into KubeConfig file

1) Instead of *certificate-authority* field w/ absolute file-path
   - Use ***certificate-authority-data*** field - w/ base64 encoded certificate
![img_8.png](assets/7_certificate_kube_config_7.png)


## B) API Groups

#### Checking API Version - Via REST, we can check many endpoints:

1) /version
2) /api (core) - Basically ***apiVersion: core/v1*** or ***apiVersion: v1***
   ![img.png](assets/7_api_core.png)
3) /apis (named) - 
   ![img_10.png](assets/7_api_named.png)
4) /logs - 
5) /metrics - 
6) /healthz - 


#### Examples: 
- curl https://kube-master:6443/version
- curl https://kube-master:6443/api/v1/pods


#### Curling API-Server | 2 Methods

1) Specify - ***Key,CRT,CA*** (curl http://localhost:6443 -k --key admin.key --cert admin.crt --cacert ca.crt)
![img_11.png](assets/7_api_curl.png)

2) Start - ***kubectl proxy*** (kubectl proxy && curl http://localhost:6443 -k)


## C) Authorization

### AuthZ Types

#### 1) Node Authorizer | (Intra-Cluster)
Authorizes the Kubelet to communicate w/ API-Server

**Intra-Cluster API-Server Access:**
![img_12.png](assets/7_node_authorizer.png)

#### 2) ABAC (Attribute-Based Access Control) | (Inter-Cluster)
Basic Steps - Create a *Policy* object that you pass to API-Server
![img_5.png](assets/7_authZ_abac.png)
  
#### 3) RBAC (Role-Based Access Control) | (Inter-Cluster)

Basic Steps: 
1) Create a Role - W/ Perm specs that you want (ie. Developer, Security, Admin, Contributor, etc.)
2) Give Particular Users - Whatever Role you want

![img_6.png](assets/7_authZ_rbac.png)

#### 4) Webhook (Outsourcing AuthZ) | (Inter-Cluster)

Example: Open Policy Agent (3rd Party Tool)  helps w/ admission control/authZ
![img_6.png](assets/7_authZ_webhook.png)

### Implementing AuthZ

#### By Default - "--authorization-mode=AlwaysAllow"

![img_7.png](assets/7_authZ_api_server.png)

#### Can pass in multiple authZ's - "--authorization-mode=Node,RBAC,Webhook"

NOTE - w/ Multiple authZ's, it is chained in the order it is received

If an AuthZ module denies a request - Forwards request to next module 

- ***Forwards request until an authZ authorizes request***, 
  - ***Then approves User & stops forwarding request*** 

![img_8.png](assets/7_authZ_chain.png)

## D) RBAC

Example: ![img_9.png](assets/7_authZ_rbac_yaml.png)

### Two Components | RBAC

#### A) Role

   PER RULE [3]: Can specify {apiGroups, resources, verbs}, etc.
      - Can have multiple Rules, of course

#### B) Role Binding - Links 1-or-more *User* objects to a *Role* Object

- NOTE: These ***Roles*** fall under namespaces (Default: *default* ns)
   - ***Limiting NS*** - Specify ns in *metadata*

![img_7.png](assets/7_authZ_rbac_role_cmds.png)


### Checking User (your) Access

![img_8.png](assets/7_authZ_rbac_access_check.png)


### Resource Names | Drilling down on Resources 

![img_10.png](assets/7_authZ_rbac_resource_names.png)


## E) ClusterRole & RoleBindings

- There are certain resources that are cluster-scoped, not ns-scoped (ex. Can't specify a ***node*** as part of a ns)
- *Getting Namespaced Resources* - ***kubectl api-resources --namespaced=true***

#### Cluster RoleBindings Usages

Define/Grant perms on...
1) Cluster-scoped resources
2) Namespaced resources => Across ALL Namespaces
3) Namespaced resources

![img_11.png](assets/7_ns_cluster_resources.png)

![img_12.png](assets/7_cluster_role_bindings.png)


## F) Image Security

#### Recall: Image-Name Format

![img_13.png](assets/7_image_security_format.png)


#### Using Private Registry

1) Login/Run
        
        docker login private-registry.io
        docker run private-registry.io/apps/internal-app
2) Create Secret 

        kubectl create secret docker-registry regcred \
        --docker-server=[REGISTRY] \
        --docker-username=[USER] \
        --docker-password=[PW] \
        --docker-email=[EMAIL]

3) Within Pod YAML
    
        spec.imagePullSecrets:
        - name: regcred

![img_14.png](assets/7_image_private_registry.png)


## G) Security Contexts

Recall, when running Docker, we can define a set of security standards:

        docker run --user=1001 ubuntu sleep 3600

        docker run --cap-add MAC_ADMIN ubuntu

We can also define Security Contexts at...

1) Pod Level

   ![img_16.png](assets/7_security_context_pod.png)

2) Container Level

    ![img_16.png](assets/7_security_context_container.png)



