##TEST NOTES

### Aliases/Variables
> ingImg="quay.io/-controller/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0"

> d="--dry-run=client -oyaml"

### Commands
1) Pod Creation
> k run ingress-controller --image=$ingImg --serviceaccount=ingress-serviceaccount --port=80 --env POD_NAME=a --env POD_NAMESPACE=b -n=ingress-space $d -- "./nginx-kubernetes-controller"
2) Deployment Creation
> k create deploy ingress-controller -n=ingress-space --image=$ingImg $d
3) Nodeport-Service Creation
> k expose deploy/ingress-controller --type=NodePort --name=ingress -n=ingress-space $d
4) 


### Ingress | General Questions
- In an ingress, what happens if no rules are specified or if no rule matches?
    - All traffic is sent to the default backend.
1) How can you set an IngressClass as default in your cluster?
   ==> ingressclass.kubernetes.io/is-default-class annotation: true
2) How can you make a single-service Ingress?
   ==> Ingress w/ default-backend, no rules

### Ingress | Common Mistakes
#### Controller
- Pod Args - Might be ***/nginx-ingress-controller*** (no "./"  )
- Service Exposing - NodePort is for "http" port 
- 

#### Resource
- "paths" is not an array (no "-" before paths)
- paths.backend // NOT backEnd (Capital E)
- "port" // NOT "ports"
- * spec.rules[0].http.paths[0].pathType: Unsupported value: "suffix": supported values: "Exact", "ImplementationSpecific", "Prefix"
* spec.rules[0].http.paths[1].pathType: Unsupported value: "suffix": supported values: "Exact", "ImplementationSpecific", "Prefix"

root@controlplane:~# k run nginx-ingress --image=nginx-ingress-controller:0.21.0 --serviceaccount=ingress-serviceaccount --port=80  --env POD_NAME=nginx-ingress --env POD_NAMESPACE=ingress-space $D -n=ingress-space -- ./nginx-ingress-controller

    k run nginx-ingress
    --image=nginx-ingress-controller:0.21.0
    --serviceaccount=ingress-serviceaccount
    --port=80
    --env POD_NAME=nginx-ingress
    --env POD_NAMESPACE=ingress-space
    --dry-run=client -oyaml
    -n=ingress-space
    -- ./nginx-ingress-controller

<details>
  <summary markdown="span">Output,Post-Modification</summary>

        apiVersion: v1
        kind: Pod
        metadata:
          creationTimestamp: null
          labels:
            run: nginx-ingress
          name: nginx-ingress
          namespace: ingress-space
        spec:
          serviceAccountName: ingress-serviceaccount
          containers:
          - args:
            - ./nginx-ingress-controller
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
            image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
            name: nginx-ingress
            ports:
            - containerPort: 80
              name: http
            - containerPort: 443
              name: https
            resources: {}
          dnsPolicy: ClusterFirst
          restartPolicy: Always
        status: {}
</details>


2) k create deploy ingress-controller --image=nginx -n=ingress-space $D

TODO: Copying Pod Template to Deployment
NOTE - Deployment image doesn't matter
1) Grab Pod-Template up to "metadata"
2) Change Pod's Label-Key (run -> app)


<details>
  <summary markdown="span">INITIAL-DEPLOY</summary>

        apiVersion: apps/v1
        kind: Deployment
        metadata:
          creationTimestamp: null
          labels:
            app: ingress-controller
          name: ingress-controller
          namespace: ingress-space
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: ingress-controller
          strategy: {}
          template:
            metadata:
              creationTimestamp: null
              labels:
                app: ingress-controller
            spec:
              containers:
              - image: nginx
                name: nginx
                resources: {}
        status: {}
</details>


<details>
  <summary markdown="span">Modified-Deploy</summary>

        apiVersion: apps/v1
        kind: Deployment
        metadata:
          creationTimestamp: null
          labels:
            app: nginx-ingress
          name: ingress-controller
          namespace: ingress-space
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: nginx-ingress
          strategy: {}
          template:
            metadata:
              labels:
                app: nginx-ingress
              name: nginx-ingress
              namespace: ingress-space
            spec:
              serviceAccountName: ingress-serviceaccount
              containers:
              - args:
                - ./nginx-ingress-controller
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
                image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
                name: nginx-ingress
                ports:
                - containerPort: 80
                  name: http
                - containerPort: 443
                  name: https
                resources: {}
              dnsPolicy: ClusterFirst
              restartPolicy: Always
        status: {}
</details>



==== RESOURCE ====

<details>
  <summary markdown="span">Answer</summary>
    
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
        name: ingress
        namespace: app-space
    spec:
        rules:
        - http:
            paths:
            - path: /watch
              pathType: Prefix
              backend:
                service:
                    name: video-service
                    port:
                        number: 80
            - path: /wear
              pathType: Prefix
              backend:
                service:
                    name: wear-service
                    port:
                        number: 80
</details>



apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  name: ingress
  namespace: ingress-space
spec:
  ports:
  - name: http
    port: 80
    nodePort: 30080
    protocol: TCP
    targetPort: 80
  - name: https
    port: 443
    protocol: TCP
    targetPort: 443
  selector:
    name: nginx-ingress
  type: NodePort
status:
  loadBalancer: {}


apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
    name: ingress
    namespace: app-space
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

            
            
