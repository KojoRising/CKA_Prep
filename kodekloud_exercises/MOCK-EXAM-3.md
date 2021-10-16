## Questions

curl https://raw.githubusercontent.com/Kojorising/CKA_Prep/main/alias.sh > alias.sh && source alias.sh && rm alias.sh

## Tough Questions
1)
2)
3)
4)
5)
6)
7)
8)
9)
10)


SIDE-QUESTION/ERROR:

root@controlplane:~# k run hr-pod --image=redis:alpine -n=hr -l environment=production,tier=frontend --env environment=production,tier=frontend $d
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    environment: production
    tier: frontend
  name: hr-pod
  namespace: hr
spec:
  containers:
  - env:
    - name: environment
      value: production,tier=frontend
    image: redis:alpine
    name: hr-pod
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

### 1) Create a new service account with the name pvviewer. Grant this Service account access to list all PersistentVolumes in the cluster by creating an appropriate cluster role called pvviewer-role and ClusterRoleBinding called pvviewer-role-binding.
Next, create a pod called pvviewer with the image: redis and serviceAccount: pvviewer in the default namespace.
<details> 
  <summary markdown="span">Answer</summary>

    root@controlplane:~# kc sa pvviewer   
    serviceaccount/pvviewer created
    root@controlplane:~# kc clusterrole pvviewer-role --verb=list --resource=persistentvolume   
    clusterrole.rbac.authorization.k8s.io/pvviewer-role created
    root@controlplane:~# kc clusterrolebinding pvviewer-role-binding --clusterrole=pvviewer-role --serviceaccount=default:pvviewer   
    clusterrolebinding.rbac.authorization.k8s.io/pvviewer-role-binding created
    root@controlplane:~# k run pvviewer --image=redis --serviceaccount=pvviewer   
    pod/pvviewer created
</details>

### 2) List the InternalIP of all nodes of the cluster. Save the result to a file /root/CKA/node_ips.
Answer should be in the format: InternalIP of controlplane<space>InternalIP of node01 (in a single line)
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# kd nodes -A | grep IP | sed "s/.*://" | xargs | tee /root/CKA/node_ips
    10.54.173.9 10.54.173.12
</details>

### 3) Create a pod called multi-pod with two containers.
Container 1, name: alpha, image: nginx
Container 2: name: beta, image: busybox, command: sleep 4800

Environment Variables:
container 1:
name: alpha

Container 2:
name: beta
<details>
  <summary markdown="span">Answer</summary>

    k run alpha --image=nginx --env name=alpha $d

    k run beta --image=busybox --env name=beta $d -- /bin/sh -c "sleep 4800"
    
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: multipod
      name: multipod
    spec:
      containers:
      - env:
        - name: name
          value: alpha
        image: nginx
        name: alpha
        resources: {}
      - args:
        - /bin/sh
        - -c 
        - sleep 4800
        env:
        - name: name
          value: beta
        image: busybox
        name: beta
        resources: {}
      dnsPolicy: ClusterFirst
      restartPolicy: Always
    status: {}

    root@controlplane:~# kg pods
    NAME       READY   STATUS    RESTARTS   AGE
    multipod   2/2     Running   0          22s
    pvviewer   1/1     Running   0          10m

</details>

### 4) Create a Pod called non-root-pod , image: redis:alpine
runAsUser: 1000
fsGroup: 2000
<details>
  <summary markdown="span">Answer</summary>

    
    root@controlplane:~# k run non-root-pod --image=redis:alpine $d
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: non-root-pod
      name: non-root-pod
    spec:
      securityContext: 
        fsGroup: 2000
        runAsUser: 1000
      containers:
      - image: redis:alpine
        name: non-root-pod
        resources: {}
      dnsPolicy: ClusterFirst
      restartPolicy: Always
    status: {}
    
    root@controlplane:~# kx non-root-pod -- whoami
    whoami: unknown uid 1000
</details>

### 5) We have deployed a new pod called np-test-1 and a service called np-test-service. Incoming connections to this service are not working. Troubleshoot and fix it.
Create NetworkPolicy, by the name ingress-to-nptest that allows incoming connections to the service over port 80.
Important: Don't delete any current objects deployed.
<details>
  <summary markdown="span">Answer</summary>

kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
    name: ingress-to-nptest
spec: 
    policyTypes: [ "Ingress" ]
    podSelector: 
        matchLabels:
            run: np-test-1
    ingress:
      - ports: [ { port: 80 }]

    # Testing: 
    root@controlplane:~# curl -m 3 10.50.192.3
    curl: (28) Connection timed out after 3000 milliseconds

    # Creating Pod
    root@controlplane:~# kcf 5.yaml
    networkpolicy.networking.k8s.io/ingress-to-nptest created
    
    root@controlplane:~# curl -m 3 10.50.192.3
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
</details>

### 6) Taint the worker node node01 to be Unschedulable. Once done, create a pod called dev-redis, image redis:alpine, to ensure workloads are not scheduled to this worker node. Finally, create a new pod called prod-redis and image: redis:alpine with toleration to be scheduled on node01.
key: env_type, value: production, operator: Equal and effect: NoSchedule
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k taint node node01 env_type=production:NoSchedule
    node/node01 tainted
    
    root@controlplane:~# k run dev-redis --image=redis:alpine
    pod/dev-redis created
    
    root@controlplane:~# kg pod -owide | grep "dev-redis\|NAME"
    NAME           READY   STATUS             RESTARTS   AGE     IP            NODE           NOMINATED NODE   READINESS GATES
    dev-redis      1/1     Running            0          38s     10.50.0.5     controlplane   <none>           <none>

    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: prod-redis
      name: prod-redis
    spec:
      tolerations: 
        - effect: NoSchedule
          key: env_type
          operator: Equal
          value: production
      containers:
      - image: redis:alpine
        name: prod-redis
        resources: {}
      dnsPolicy: ClusterFirst
      restartPolicy: Always
    status: {}
        
    root@controlplane:~# kg pods -owide | grep "redis\|NAME"
    NAME           READY   STATUS             RESTARTS   AGE     IP            NODE           NOMINATED NODE   READINESS GATES
    dev-redis      1/1     Running            0          3m30s   10.50.0.5     controlplane   <none>           <none>
    prod-redis     1/1     Running            0          33s     10.50.192.5   node01         <none>           <none>
</details>

### 7) Create a pod called hr-pod in hr namespace belonging to the production environment and frontend tier . image: redis:alpine
Use appropriate labels and create all the required objects if it does not exist in the system already.
<details>
  <summary markdown="span">Answer</summary>

root@controlplane:~# kg ns -A | grep -c hr
0

root@controlplane:~# kc ns hr
namespace/hr created

root@controlplane:~# k run hr-pod --image=redis:alpine -n=hr -l environment=production,tier=frontend   
pod/hr-pod created

root@controlplane:~# kg pod -n=hr  --show-labels | grep "hr-pod\|NAME"
NAME     READY   STATUS    RESTARTS   AGE   LABELS
hr-pod   1/1     Running   0          65s   environment=production,tier=frontend

</details>

### 8) A kubeconfig file called super.kubeconfig has been created under /root/CKA. There is something wrong with the configuration. Troubleshoot and fix it.
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# cat /root/CKA/super.kubeconfig | grep server:
    server: https://controlplane:9999

    root@controlplane:~# k config view | grep server
    server: https://controlplane:6443

    root@controlplane:~# sed -i "s/:9999/:6443/" /root/CKA/super.kubeconfig 
    root@controlplane:~# cat /root/CKA/super.kubeconfig | grep server
    server: https://controlplane:6443
</details>

### 9) We have created a new deployment called nginx-deploy. scale the deployment to 3 replicas. Has the replica's increased? Troubleshoot the issue and fix it.
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# cat /etc/kubernetes/manifests/kube-controller-manager.yaml > kube-contro1ler-manager.yaml
    root@controlplane:~# cat kube-contro1ler-manager.yaml | sed "s/contro1ler/controller/" > /etc/kubernetes/manifests/kube-controller-manager.yaml
    root@controlplane:~# k delete pod/kube-controller-manager-controlplane $N
    pod "kube-controller-manager-controlplane" deleted
    
    root@controlplane:~# kg pod -A | grep controller
    kube-system   kube-controller-manager-controlplane   1/1     Running   0          108s
    
    root@controlplane:~# k scale deploy/nginx-deploy --replicas=3
    deployment.apps/nginx-deploy scaled
    root@controlplane:~# kg deploy
    NAME           READY   UP-TO-DATE   AVAILABLE   AGE
    nginx-deploy   3/3     3            3           26m
</details>



==== ALLOW-ALL-INCOMING ====
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
    name: ingress-to-nptest
spec:
    policyTypes: ["Ingress"]
    podSelector: 
        matchLabels:
            run: np-test-1
    ingress: [{}]
_____________________________
root@controlplane:~# kd netpol/ingress-to-nptest
Name:         ingress-to-nptest
Namespace:    default
Created on:   2021-09-07 20:52:45 +0000 UTC
Labels:       <none>
Annotations:  <none>
Spec:
  PodSelector:     run=np-test-1
  Allowing ingress traffic:
    To Port: <any> (traffic allowed to all ports)
    From: <any> (traffic not restricted by source)
  Not affecting egress traffic
  Policy Types: Ingress

==== ALLOW-ALL-SPECIFIC PORT ====
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
    name: ingress-to-nptest
spec:
    policyTypes: ["Ingress"]
    podSelector: 
        matchLabels:
            run: np-test-1
    ingress: 
        - ports: [{port: 80}]
_____________________
Name:         ingress-to-nptest
Namespace:    default
Created on:   2021-09-07 20:55:01 +0000 UTC
Labels:       <none>
Annotations:  <none>
Spec:
  PodSelector:     run=np-test-1
  Allowing ingress traffic:
    To Port: 80/TCP
    From: <any> (traffic not restricted by source)
  Not affecting egress traffic
  Policy Types: Ingress

==== ALLOW-ALL-SPECIFIC PORT ====
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
    name: ingress-to-nptest
spec:
    policyTypes: ["Ingress"]
    podSelector: 
        matchLabels:
            run: np-test-1
    ingress: 
        - from:
            - namespaceSelector:
                matchLabels:
                    app: default


# 6 // NOT WORKING????

root@controlplane:~# kg pods -owide | grep "NAME\|nginx"
NAME           READY   STATUS    RESTARTS   AGE     IP            NODE           NOMINATED NODE   READINESS GATES
nginx          1/1     Running   0          67s     10.50.192.5   node01         <none>           <none>
root@controlplane:~# kdNodes
Name:               controlplane
Taints:             <none>
Unschedulable:      false
  InternalIP:  10.43.196.9
Name:               node01
Taints:             env_type=production:NoSchedule
Unschedulable:      false
  InternalIP:  10.43.196.12
root@controlplane:~# kg pods -owide | grep "NAME\|nginx"
NAME           READY   STATUS    RESTARTS   AGE     IP            NODE           NOMINATED NODE   READINESS GATES
nginx          1/1     Running   0          74s     10.50.192.5   node01         <none>           <none>


apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: prod-redis
  name: prod-redis
spec:
  tolerations:
  - effect: NoSchedule
    value: production
    key: env_type
  containers:
  - image: redis:alpine
    name: prod-redis
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
