## Questions

1) How can you set an IngressClass as default in your cluster?
   ==> ingressclass.kubernetes.io/is-default-class annotation: true
2) How can you make a single-service Ingress?
  ==> Ingress w/ default-backend, no rules

<details> 
  <summary markdown="span">Answer</summary>

    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: test-ingress
    spec:
      defaultBackend:
        service:
          name: test
          port:
            number: 80
</details>

### 1) We have deployed two applications. Explore the setup.
Note: They are in a different namespace.
<details> 
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get deploy -A
    NAMESPACE     NAME              READY   UP-TO-DATE   AVAILABLE   AGE
    app-space     default-backend   1/1     1            1           2m18s
    app-space     webapp-video      1/1     1            1           2m19s
    app-space     webapp-wear       1/1     1            1           2m19s
    kube-system   coredns           2/2     2            2           8m34s
    root@controlplane:~# k get pods -A
    NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
    app-space     default-backend-5cf9bfb9d-sllsf        1/1     Running   0          2m22s
    app-space     webapp-video-84f8655bd8-p77tk          1/1     Running   0          2m22s
    app-space     webapp-wear-6ff9445955-tcfs6           1/1     Running   0          2m22s
    kube-system   coredns-74ff55c5b-7stpt                1/1     Running   0          8m24s
    kube-system   coredns-74ff55c5b-pgqkl                1/1     Running   0          8m25s
    kube-system   etcd-controlplane                      1/1     Running   0          8m33s
    kube-system   kube-apiserver-controlplane            1/1     Running   0          8m33s
    kube-system   kube-controller-manager-controlplane   1/1     Running   0          8m33s
    kube-system   kube-flannel-ds-rlpvt                  1/1     Running   0          8m25s
    kube-system   kube-proxy-n5zhf                       1/1     Running   0          8m25s
    kube-system   kube-scheduler-controlplane            1/1     Running   0          8m33s
    root@controlplane:~# k get svc -A
    NAMESPACE     NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
    app-space     default-http-backend   ClusterIP   10.102.68.85    <none>        80/TCP                   2m24s
    app-space     video-service          ClusterIP   10.102.16.97    <none>        8080/TCP                 2m25s
    app-space     wear-service           ClusterIP   10.100.102.70   <none>        8080/TCP                 2m25s
    default       kubernetes             ClusterIP   10.96.0.1       <none>        443/TCP                  8m42s
    kube-system   kube-dns               ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP,9153/TCP   8m40s

</details>

### 2) Let us now deploy an Ingress Controller. First, create a namespace called ingress-space.
We will isolate all ingress related objects into its own namespace.
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k create ns ingress-space
    namespace/ingress-space created
    root@controlplane:~# k config set-context --current --namespace=ingress-space
    Context "kubernetes-admin@kubernetes" modified.
</details>

### 3) The NGINX Ingress Controller requires a ConfigMap object. Create a ConfigMap object in the ingress-space.
Use the spec given below. No data needs to be configured in the ConfigMap.
Name: nginx-configuration
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k create cm nginx-configuration
    configmap/nginx-configuration created
</details>

### 4) The NGINX Ingress Controller requires a ServiceAccount. Create a ServiceAccount in the ingress-space namespace.
Use the spec provided below.
Name: ingress-serviceaccount
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k create sa ingress-serviceaccount
    serviceaccount/ingress-serviceaccount created
</details>

### 5) We have created the Roles and RoleBindings for the ServiceAccount. Check it out!!
<details>
  <summary markdown="span">Answer</summary>

root@controlplane:~# k get rolebinding/ingress-role-binding -oyaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
  name: ingress-role-binding
  namespace: ingress-space
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ingress-role
subjects:
- kind: ServiceAccount
  name: ingress-serviceaccount

root@controlplane:~# k get role/ingress-role -oyaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
  name: ingress-role
  namespace: ingress-space
rules:
- apiGroups:
  - ""
  resources:
  - configmaps
  - pods
  - secrets
  - namespaces
  verbs:
  - get
- apiGroups:
  - ""
  resourceNames:
  - ingress-controller-leader-nginx
  resources:
  - configmaps
  verbs:
  - get
  - update
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - create
- apiGroups:
  - ""
  resources:
  - endpoints
  verbs:
  - get


</details>

### 6) Let us now deploy the Ingress Controller. Create a deployment using the file given.
The Deployment configuration is given at /root/ingress-controller.yaml. There are several issues with it. Try to fix them.
- Deployed in the correct namespace.
- Replicas: 1
- Use the right image
- Name: ingress-space
<details>
  <summary markdown="span">Answer</summary>
    
    NAMESPACE - WRONG
    ARGS: 
        - /nginx-ingress-controller
        SHOULD BE: - ./nginx-ingress-controller
    APIVERSION: WRONG!!
    
    
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: ingress-controller
    namespace: ingress-space
  spec:
    replicas: 1
    selector:
      matchLabels:
        name: nginx-ingress
    template:
      metadata:
        labels:
          name: nginx-ingress
          namespace: ingress-space
      spec:
        serviceAccountName: ingress-serviceaccount
        containers:
          - name: nginx-ingress-controller
            image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
            args:
              - /nginx-ingress-controller
              - --configmap=$(POD_NAMESPACE)/nginx-configuration
              - --default-backend-service=app-space/default-http-backend
            env:
              - name: POD_NAME
                valueFrom:
                  fieldRef:
                    fieldPath: metadata.name
              - name: POD_NAMESPACE
                valueFrom:
                  fieldRef:
                    fieldPath: metadata.namespace
            ports:
            - name: http
              containerPort: 80
            - name: https
              containerPort: 443
</details>

### 7) Let us now create a service to make Ingress available to external users.
Create a service following the given specs.
- Name: ingress
- Type: NodePort
- Port: 80
- TargetPort: 80
- NodePort: 30080
- Namespace: ingress-space
- Use the right selector
<details>
  <summary markdown="span">Answer</summary>
  
  root@controlplane:~# k create svc nodeport ingress --tcp=80:80 --node-port=30080 --dry-run=client -oyaml
  apiVersion: v1
  kind: Service
  metadata:
    creationTimestamp: null
    labels:
      app: ingress
    name: ingress
  spec:
    ports:
    - name: 80-80
      nodePort: 30080
      port: 80
      protocol: TCP
      targetPort: 80
    selector:
      name: nginx-ingress
    type: NodePort
  status:
    loadBalancer: {}
  
  root@controlplane:~# k expose deploy/ingress-controller --name=ingress --type=NodePort --dry-run=client -oyaml -n=ingress-space
  apiVersion: v1
  kind: Service
  metadata:
    creationTimestamp: null
    name: ingress
  spec:
    ports:
    - name: port-1
      port: 80
      protocol: TCP
      nodePort: 30080
      targetPort: 80
    - name: port-2
      port: 443
      protocol: TCP
      targetPort: 443
    selector:
      name: nginx-ingress
    type: NodePort
  status:
    loadBalancer: {}
  </details>

### 8) Create the ingress resource to make the applications available at /wear and /watch on the Ingress service.
Create the ingress in the app-space namespace.
- Ingress Created
- Path: /wear
- Path: /watch
- Configure correct backend service for /wear
- Configure correct backend service for /watch
- Configure correct backend port for /wear service
- Configure correct backend port for /watch service
Create the ingress in the app-space namespace. 
<details>
  <summary markdown="span">Answer</summary>

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wear-watch
  namespace: app-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /wear
        pathType: Prefix
        backend:
          service:
           name: wear-service
           port: 
            number: 8080
      - path: /watch
        pathType: Prefix
        backend:
          service:
           name: video-service
           port:
            number: 8080

</details>

### 9) Access the application using the Ingress tab on top of your terminal.
Make sure you can access the right applications at /wear and /watch paths.
<details>
  <summary markdown="span">Answer</summary>

</details>

### 10)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 11)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 12)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 13)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 14)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 15)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 16)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 17)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 18)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 19)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 20)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 21)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 22)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 23)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 24)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 25)
<details>
  <summary markdown="span">Answer</summary>

</details>

## TABLE TEMPLATES



1) Creat

  
  apiVersion: extensions/v1beta1
  kind: Deployment
  metadata:
    name: ingress-controller
    namespace: ingress-
  spec:
    replicas: 1
    selector:
      matchLabels:
        name: nginx-ingress
    template:
      metadata:
        labels:
          name: nginx-ingress
      spec:
        serviceAccountName: ingress-serviceaccount
        containers:
          - name: nginx-ingress-controller
            image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
            args:
              - /nginx-ingress-controller
              - --configmap=$(POD_NAMESPACE)/nginx-configuration
              - --default-backend-service=app-space/default-http-backend
            env:
              - name: POD_NAME
                valueFrom:
                  fieldRef:
                    fieldPath: metadata.name
              - name: POD_NAMESPACE
                valueFrom:
                  fieldRef:
                    fieldPath: metadata.namespace
            ports:
              - name: http
                  containerPort: 80
              - name: https
                containerPort: 443


### 2-Col | w/ Steps
| STEP  |               |               |       
| ----- | ------------- | ------------- |
| 1     |               |               |               
| 2     |               |               |               
| 3     |               |               |               
| 4     |               |               |               
| 5     |               |               |               
| 6     |               |               |               
| 7     |               |               |               
| 8     |               |               |               
| 9     |               |               |               
| 10    |               |               |               


### 2-Col | w/ Steps
|       |               |               |       
| ----- | ------------- | ------------- |
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |  
