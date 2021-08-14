## Role-Based Access Control

### 1) Inspect the environment and identify the authorization modes configured on the cluster.
Check the kube-apiserver settings.
<details> 
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get pod/kube-apiserver-controlplane -n kube-system -oyaml | grep --regexp="--authorization-mode"
    - --authorization-mode=Node,RBAC
</details>

### 2) How many roles exist in the default namespace?
<details>
  <summary markdown="span">Answer</summary>


    root@controlplane:~# k get role
    No resources found in default namespace.
</details>

### 3) How many roles exist in all namespaces together?
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get role -A | grep -c -v "NAMESPACE"
    12
    
    root@controlplane:~# k get role -A 
    NAMESPACE     NAME                                             CREATED AT
    blue          developer                                        2021-07-29T20:37:05Z
    kube-public   kubeadm:bootstrap-signer-clusterinfo             2021-07-29T20:30:56Z
    kube-public   system:controller:bootstrap-signer               2021-07-29T20:30:54Z
    kube-system   extension-apiserver-authentication-reader        2021-07-29T20:30:54Z
    kube-system   kube-proxy                                       2021-07-29T20:30:58Z
    kube-system   kubeadm:kubelet-config-1.20                      2021-07-29T20:30:55Z
    kube-system   kubeadm:nodes-kubeadm-config                     2021-07-29T20:30:55Z
    kube-system   system::leader-locking-kube-controller-manager   2021-07-29T20:30:54Z
    kube-system   system::leader-locking-kube-scheduler            2021-07-29T20:30:54Z
    kube-system   system:controller:bootstrap-signer               2021-07-29T20:30:54Z
    kube-system   system:controller:cloud-provider                 2021-07-29T20:30:54Z
    kube-system   system:controller:token-cleaner                  2021-07-29T20:30:54Z
</details>

### 4) What are the resources the kube-proxy role in the kube-system namespace is given access to?
<details>
  <summary markdown="span">Answer</summary>
    
    root@controlplane:~# k get role/kube-proxy -n=kube-system -ocustom-columns=:.rules[].resources | xargs
    [configmaps]


    root@controlplane:~# k get role/kube-proxy -n=kube-system -oyaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
    creationTimestamp: "2021-07-29T20:30:58Z"
    managedFields:
    - apiVersion: rbac.authorization.k8s.io/v1
      fieldsType: FieldsV1
      fieldsV1:
      f:rules: {}
      manager: kubeadm
      operation: Update
      time: "2021-07-29T20:30:58Z"
      name: kube-proxy
      namespace: kube-system
      resourceVersion: "307"
      uid: 645c70ad-406d-40ac-bbe0-be2335f6976a
      rules:
    - apiGroups:
        - ""
          resourceNames:
        - kube-proxy
          resources:
        - configmaps
          verbs:
        - get
</details>

### 5) What actions can the kube-proxy role perform on configmaps?
<details>
  <summary markdown="span">Answer</summary>
        
    root@controlplane:~# k get role/kube-proxy -n=kube-system -ocustom-columns=:.rules[].verbs | xargs
    [get]
</details>

### 6) Which of the following statements are true?
<details>
  <summary markdown="span">Answer</summary>

    ANSWER - B

    Choices:
        A) kube-proxy role can delete the configmap it created
        B) kube-proxy role can get details of configmap object by the name kube-proxy
        C) kube-proxy role can only view and update configmap object by the name kube-proxy
</details>

### 7) Which account is the kube-proxy role assigned to it?
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get rolebinding -A -ocustom-columns=NAME:.metadata.name,SUBJECT:.subjects[].name | grep kube-proxy
    kube-proxy                                          system:bootstrappers:kubeadm:default-node-token

    root@controlplane:~# k get rolebinding -A -ocustom-columns=NAME:.metadata.name,SUBJECT:.subjects[].name
    NAME                                                SUBJECT
    dev-user-binding                                    dev-user
    kubeadm:bootstrap-signer-clusterinfo                system:anonymous
    system:controller:bootstrap-signer                  bootstrap-signer
    kube-proxy                                          system:bootstrappers:kubeadm:default-node-token
    kubeadm:kubelet-config-1.20                          system:nodes
    kubeadm:nodes-kubeadm-config                         system:bootstrappers:kubeadm:default-node-token
    system::extension-apiserver-authentication-reader   system:kube-controller-manager
    system::leader-locking-kube-controller-manager      system:kube-controller-manager
    system::leader-locking-kube-scheduler               system:kube-scheduler
    system:controller:bootstrap-signer                  bootstrap-signer
    system:controller:cloud-provider                    cloud-provider
    system:controller:token-cleaner                     token-cleaner

</details>

### 8) A user dev-user is created. User's details have been added to the kubeconfig file. Inspect the permissions granted to the user. Check if the user can list pods in the default namespace.
Use the --as dev-user option with kubectl to run commands as the dev-user.

<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k auth can-i list pods --as dev-user
    no
</details>

### 9) Create the necessary roles and role bindings required for the dev-user to create, list and delete pods in the default namespace.
Use the given spec:

<details>
  <summary markdown="span">Answer</summary>


        kind: Role
        apiVersion: rbac.authorization.k8s.io/v1
        metadata:
            namespace: default
            name: developer
        rules:
        - apiGroups: [""]
          resources: ["pods"]
          verbs: ["list", "create"]
        
        ---
        kind: RoleBinding
        apiVersion: rbac.authorization.k8s.io/v1
        metadata:
        name: dev-user-binding
        subjects:
        - kind: User
          name: dev-user
          apiGroup: rbac.authorization.k8s.io
      roleRef:
          kind: Role
          name: developer
          apiGroup: rbac.authorization.k8s.io
        
        
        

</details>

### 10)
<details>
  <summary markdown="span">Answer</summary>

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
creationTimestamp: "2021-07-29T20:37:05Z"
managedFields:
- apiVersion: rbac.authorization.k8s.io/v1
  fieldsType: FieldsV1
  fieldsV1:
  f:roleRef:
  f:apiGroup: {}
  f:kind: {}
  f:name: {}
  f:subjects: {}
  manager: kubectl-create
  operation: Update
  time: "2021-07-29T20:37:05Z"
  name: dev-user-binding
  namespace: blue
  resourceVersion: "954"
  uid: abb6090f-ed1d-465f-b3e1-69d427674d35
  roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: developer
  subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: dev-user

</details>

### 11) Grant the dev-user permissions to create deployments in the blue namespace.
Remember to add both groups "apps" and "extensions".
<details>
  <summary markdown="span">Answer</summary>


    ----
    kind: Role
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
    namespace: blue
    name: deploy-role
    rules:
    - apiGroups: ["apps", "extensions"]
      resources: ["deployments"]
      verbs: ["create"]
    
    ----
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
    name: dev-user-deploy-binding
    namespace: blue
    subjects:
    - kind: User
      name: dev-user
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: Role
      name: deploy-role
      apiGroup: rbac.authorization.k8s.io

</details>

### 12)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 13)
<details>
  <summary markdown="span">Answer</summary>

</details>
