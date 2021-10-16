# Questions

curl https://raw.githubusercontent.com/Kojorising/CKA_Prep/main/alias.sh > alias.sh && source alias.sh && rm alias.sh

## ClipBoard Notes

Have 1-25 #s ready

No Comment == Already DONE

## Review

4) 4% Pod Ready if Service is reachable | Probes




==> Use
1) find [SEARCH-DIR] | grep [TARGET-STR]
2) k config get-contexts
3) wc - l - 
4) kubectl get events
5) CERTS/
   kc rolebinding  --serviceaccount=[NS][SA]
   k auth can-i --as system:serviceaccount:[NS][SA]
6) REDIRECTING OUTPUTS
    - Stderr & StdOut - &>
7) 

## Overview
0) 0%
1) 1% Context-Switching
   - k config get-contexts -oname
2) 3% Schedule/Master
3) 1% STS
4) 4% Pod Ready if Service is reachable | Probes
5) 1% Kubectl Sorting
6) 8% Volume/Deploy
7) 1% Node and Pod Resource Usage (k top)
   - kubectl top pod --containers=true
8) 2% Get Master Information
9) 5% Kill Scheduler, Manual Scheduling (MISSED) - GOODish
   - Scheduler, basically only assigns **nodeName** field to a Pod
     > controlplane $ kg pods
     NAME    READY   STATUS    RESTARTS   AGE
     nginx   1/1     Running   0          11s
     controlplane $ kg pods -A | grep -c scheduler
     0
10) 6% RBAC ServiceAccount Role RoleBinding - GOOD
    > k -n project-hamster auth can-i create secret \
    --as system:serviceaccount:project-hamster:processor
11) 4% DaemonSet on all Nodes - GOOD
12) 6% Deployment on all Nodes - GOOD
13) 4% Multi Containers and Pod shared Volume - STUPID
14) 2% Find out Cluster Information
15) 3% ClusterEvents - GOOD
    > kubectl get events
    > kg ev
16) 2% Namespaces and Api Resources
    >  k -n project-hamster get role --no-headers | wc -l
17) 3% Docker
18) 8% Fix Kubelet
19) 3% Create Secret and mount into Pod
20) 10% Update Kubernetes Version and join cluster (HARD)
    > km config print join-defaults
    > km token create --print-join-command --ttl=0
21) 2% Create a Static Pod and Service
22) 2% Check how long certificates are valid
    > kubeadm certs check-expiration
    > kubeadm certs renew apiserver
23) 2% Kubelet client/server cert info - NOT DONE
    - kubelet certificate directory - Search for "--cert-dir" Arg (Either via ps aux or 10-kubeadm.conf)
24) 9% Network-Policy
25) 8% Etcd-Backup
> e snapshot save $ETCD_ARGS /tmp/etcd-backup.db 
> e snapshot restore $ETCD_ARGS /tmp/etcd-backup.db --data-dir=/var/lib/etcd-backup.db
> cat /etc/kubernetes/manifests/etcd.yaml | sed "s;/var/lib/etcd;/var/lib/etcd-backup;" | tee etcd.yaml
> cat etcd.yaml > /etc/kubernetes/manifests/etcd.yaml

## 0)
Instructions
You should avoid using deprecated kubectl commands as these might not work in the exam.

There are three Kubernetes clusters and 8 nodes in total:

cluster1-master1
cluster1-worker1
cluster1-worker2
cluster2-master1
cluster2-worker1
cluster3-master1
cluster3-worker1
cluster3-worker2
Rules
You're only allowed to have one other browser tab open with the Kubernetes documentation

https://kubernetes.io/docs
https://github.com/kubernetes
https://kubernetes.io/blog
Notes
You have a notepad (top right) where you can store plain text. This is useful to store questions you skipped and might try again at the end.

Difficulty
This simulator is more difficult than the real certification. We think this gives you a greater learning effect and also confidence to score in the real exam. Most of the simulator scenarios require good amount of work and can be considered "hard". In the real exam you will also face these "hard" scenarios, just less often. There are probably also fewer questions in the real exam.

SSH Access
As the k8s@terminal user you can connect via ssh to every node, like ssh cluster1-master1. Using kubectl as root user on a master node you can connect to the api-server of just that cluster.

File system
User k8s@terminal has root permissions using sudo should you face permission issues. Whenever you're asked to write or edit something in /opt/course/... it should be done so in your main terminal and not on any of the master or worker nodes.

K8s contexts
Using kubectl from k8s@terminal you can reach the api-servers of all available clusters through different pre-configured contexts. The command to switch to the correct Kubernetes context will be listed on top of every question when needed.

Ctrl/Cmd-F Search
Do not use the browser search via Ctrl-F or Cmd-F beause this will render the brower terminal unusuable. If this happened you can simply reload your browser page.
<details> 
  <summary markdown="span">Answer</summary>

</details>

## 1) Task weight: 1%

You have access to multiple clusters from your main terminal through kubectl contexts. Write all those context names into /opt/course/1/contexts.

Next write a command to display the current context into /opt/course/1/context_default_kubectl.sh, the command should use kubectl.

Finally write a second command doing the same thing into /opt/course/1/context_default_no_kubectl.sh, but without the use of kubectl.
<details>
  <summary markdown="span">Answer</summary>

k8s@terminal:~$ k config view | grep name: | sed "s/.*name://" | sort | uniq | tee /opt/course/1/contexts
k8s-c1-H
k8s-c2-AC
k8s-c3-CCC

k8s@terminal:~$ echo "kubectl config current-context" > /opt/course/1/context_default_kubectl.sh
k8s@terminal:~$ sh /opt/course/1/context_default_kubectl.sh
k8s-c1-H

k8s@terminal:~$ echo "cat $HOME/.kube/config | grep current-context | sed "s/.*current-context://" | xargs" | tee /opt/course/1/context_default_no_kubectl.sh
cat /home/k8s/.kube/config | grep current-context | sed s/.*current-context:// | xargs

</details>

## 2) 3% | Schedule Pod on Master Node
Use context: kubectl config use-context k8s-c1-H

Create a single Pod of image httpd:2.4.41-alpine in Namespace default. The Pod should be named pod1 and the container should be named pod1-container. This Pod should only be scheduled on a master node, do not add new labels any nodes.

Shortly write the reason on why Pods are by default not scheduled on master nodes into /opt/course/2/master_schedule_reason .
<details>
  <summary markdown="span">Answer</summary>

    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: pod1
      name: pod1
      namespace: default
    spec:
      nodeName: cluster1-master1 
      containers:
      - image: httpd:2.4.41-alpine
        name: pod1-container
        resources: {}
      dnsPolicy: ClusterFirst
      restartPolicy: Always
    status: {}
    
    k8s@terminal:~$ echo "Because master node may be default initialized with some Taints that prevent Pods from being scheduled onto it" > /opt/course/2/master_schedule_reason

</details>

## 3) 1% | Scale down StatefulSet
Use context: kubectl config use-context k8s-c1-H
There are two Pods named o3db-* in Namespace project-c13. C13 management asked you to scale the Pods down to one replica to save resources. Record the action.
<details>
  <summary markdown="span">Answer</summary>

    k -n project-c13 scale sts o3db --replicas 1 --record

    k8s@terminal:~$ kg sts $C13
    NAME   READY   AGE
    o3db   2/2     136d
</details>

## 4) 4% | Pod Ready if Service is reachable
Task weight: 4%
Use context: kubectl config use-context k8s-c1-H
Do the following in Namespace default. Create a single Pod named ready-if-service-ready of image nginx:1.16.1-alpine. Configure a LivenessProbe which simply runs true. Also configure a ReadinessProbe which does check if the url http://service-am-i-ready:80 is reachable, you can use wget -T2 -O- http://service-am-i-ready:80 for this. Start the Pod and confirm it isn't ready because of the ReadinessProbe.
Create a second Pod named am-i-ready of image nginx:1.16.1-alpine with label id: cross-server-ready. The already existing Service service-am-i-ready should now have that second Pod as endpoint.
Now the first Pod should be in ready state, confirm that.
<details>
  <summary markdown="span">Answer</summary>

k8s@terminal:~$ kg pods | grep "ready\|NAME"
NAME                       READY   STATUS    RESTARTS   AGE
ready-if-service-ready     0/1     Running   0          40s

k8s@terminal:~$ kg svc --show-labels
NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE    LABELS
kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP   136d   component=apiserver,provider=kubernetes
service-am-i-ready   ClusterIP   10.103.185.10   <none>        80/TCP    136d   id=cross-server-ready
k8s@terminal:~$ k run am-i-ready --image=nginx:1.16.1-alpine -l id=cross-server-ready
pod/am-i-ready created
k8s@terminal:~$ kg pods | grep "ready\|NAME"
NAME                       READY   STATUS    RESTARTS   AGE
am-i-ready                 1/1     Running   0          6s
ready-if-service-ready     0/1     Running   0          119s
k8s@terminal:~$ kg pods | grep "ready\|NAME"
NAME                       READY   STATUS    RESTARTS   AGE
am-i-ready                 1/1     Running   0          10s
ready-if-service-ready     1/1     Running   0          2m3s

</details>


28 Minutes 

## 5) 1% | Kubectl sorting 
There are various Pods in all namespaces. Write a command into /opt/course/5/find_pods.sh which lists all Pods sorted by their AGE (metadata.creationTimestamp).
Write a second command into /opt/course/5/find_pods_uid.sh which lists all Pods sorted by field metadata.uid. Use kubectl sorting for both commands.

<details>
  <summary markdown="span">Answer</summary>

k8s@terminal:~$ kg pods -ocustom-columns=NAME:.metadata.creationTimestamp,AGE:.metadata.name | grep -v NAME | sort
2021-05-04T11:10:46Z   web-test-6c77dcfbc-gx4g9
2021-05-04T11:10:46Z   web-test-6c77dcfbc-mklkf
2021-05-04T11:10:46Z   web-test-6c77dcfbc-rslcd
2021-05-04T11:10:49Z   special
2021-09-17T20:01:24Z   pod1
2021-09-17T20:16:05Z   ready-if-service-ready
2021-09-17T20:17:58Z   am-i-ready
k8s@terminal:~$


k8s@terminal:~$ echo "kubectl get pods -Aocustom-columns=NAME:.metadata.creationTimestamp,AGE:.metadata.name | grep -v NAME | sort" | tee /opt/course/5/find_pods.sh
kubectl get pods -Aocustom-columns=NAME:.metadata.creationTimestamp,AGE:.metadata.name | grep -v NAME | sort
k8s@terminal:~$ echo "kubectl get pods -Aocustom-columns=NAME:.metadata.creationTimestamp,UID:.metadata.uid | grep -v NAME | sort" | tee /opt/course/5/find_pods.sh
kubectl get pods -Aocustom-columns=NAME:.metadata.creationTimestamp,UID:.metadata.uid | grep -v NAME | sort'


=====READ WHOLE QUESTION=====
k8s@terminal:~$ echo "kubectl get pods -A --sort-by='{.metadata.creationTimestamp}'" | tee /opt/course/5/find_pods.sh
kubectl get pods -A --sort-by='{.metadata.creationTimestamp}'
k8s@terminal:~$ echo "kubectl get pods -A --sort-by='{.metadata.uid}'" | tee /opt/course/5/find_pods_uid.sh
kubectl get pods -A --sort-by='{.metadata.uid}'

</details>

35 MIN

## 6) 8% | Storage, PV, PVC, Pod volume
Use context: kubectl config use-context k8s-c1-H

Create a new PersistentVolume named safari-pv. It should have a capacity of 2Gi, accessMode ReadWriteOnce, hostPath /Volumes/Data and no storageClassName defined.

Next create a new PersistentVolumeClaim in Namespace project-tiger named safari-pvc . It should request 2Gi storage, accessMode ReadWriteOnce and should not define a storageClassName. The PVC should bound to the PV correctly.

Finally create a new Deployment safari in Namespace project-tiger which mounts that volume at /tmp/safari-data. The Pods of that Deployment should be of image httpd:2.4.41-alpine.

<details>
  <summary markdown="span">Answer</summary>

------
apiVersion: v1
kind: PersistentVolume
metadata:
  name: safari-pv
  namespace: project-tiger
spec:
  accessModes: ["ReadWriteOnce"]
  hostPath: { path: "/Volumes/Data" }
  capacity: { storage: 2Gi }
------ 
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: safari-pvc
  namespace: project-tiger
spec:
  accessModes: ["ReadWriteOnce"]
  resources: 
    requests:  { storage: 2Gi }
------ 
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: safari
  name: safari
spec:
  replicas: 1
  selector:
    matchLabels:
      app: safari
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: safari
    spec:
      volumes:
      - name: pv-vol
        persistentVolumeClaim:
          claimName: safari-pvc
      containers:
      - image: httpd:2.4.41-alpine
        name: httpd
        volumeMounts:
        - name: pv-vol
          mountPath: "/tmp/safari-data"
        resources: {}
status: {}

</details>

## 7) 1% | Node and Pod Resource Usage (WRONG)
Use context: kubectl config use-context k8s-c1-H
The metrics-server hasn't been installed yet in the cluster, but it's something that should be done soon. Your college would already like to know the kubectl commands to:
    show node resource usage
    show Pod and their containers resource usage
Please write the commands into /opt/course/7/node.sh and /opt/course/7/pod.sh.
<details>
  <summary markdown="span">Answer</summary>

    k8s@terminal:~$ echo "k top node" > /opt/course/7/node.sh
    k8s@terminal:~$ echo "k top pod" > /opt/course/7/pod.sh
kubectl top pod --containers=true
</details>

## 8) 2% | Get Master Information
Ssh into the master node with ssh cluster1-master1. Check how the master components kubelet, kube-apiserver, kube-scheduler, kube-controller-manager and etcd are started/installed on the master node. Also find out the name of the DNS application and how it's started/installed on the master node.

Write your findings into file /opt/course/8/master-components.txt. The file should be structured like:

-> /opt/course/8/master-components.txt
kubelet: [TYPE]
kube-apiserver: [TYPE]
kube-scheduler: [TYPE]
kube-controller-manager: [TYPE]
etcd: [TYPE]
dns: [TYPE] [NAME]
Choices of [TYPE] are: not-installed, process, static-pod, pod
<details> 
  <summary markdown="span">Answer</summary>
    
    kubelet: process
    kube-apiserver: static-pod
    kube-scheduler: static-pod
    kube-controller-manager: static-pod
    etcd: static-pod
    dns: pod coredns

</details>

## 9) 5% | Kill Scheduler, Manual Scheduling ( TERRIBLE QUESTION )
Ssh into the master node with ssh cluster2-master1. Temporarily stop the kube-scheduler, this means in a way that you can start it again afterwards.
Create a single Pod named manual-schedule of image httpd:2.4-alpine, confirm its started but not scheduled on any node.
Now you're the scheduler and have all its power, manually schedule that Pod on node cluster2-master1. Make sure it's running.
Start the kube-scheduler again and confirm its running correctly by creating a second Pod named manual-schedule2 of image httpd:2.4-alpine and check if it's running on cluster2-worker1.

<details>
  <summary markdown="span">Answer</summary>

    root@cluster2-master1:~# mv /etc/kubernetes/manifests/kube-scheduler.yaml /etc/kubernetes
    root@cluster2-master1:~# ls  /etc/kubernetes
    admin.conf  controller-manager.conf  kubelet.conf  kube-scheduler.yaml  manifests  pki  scheduler.conf
    root@cluster2-master1:~# kg pods -A | grep scheduler

</details>

## 10) 6% | RBAC ServiceAccount Role RoleBinding
kubectl config use-context k8s-c1-H 
Create a new ServiceAccount processor in Namespace project-hamster. Create a Role and RoleBinding, both named processor as well. These should allow the new SA to only create Secrets and ConfigMaps in that Namespace.
<details>
  <summary markdown="span">Answer</summary>
    
    #### A) Create ServiceAccount 
    k8s@terminal:~$ kc sa processor -n=project-hamster
    serviceaccount/processor created
    
    #### B) Create Role
    k8s@terminal:~$ kc role processor --verb=create --resource=secrets,configmaps $d
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      creationTimestamp: null
      name: processor
    rules:
    - apiGroups:
      - ""
      resources:
      - secrets
      - configmaps
      verbs:
      - create
    
    #### NOTE) Tried creating rolebinding with current user to check perms
    k8s@terminal:~$ whoami
    k8s
    
    #### C) Create RoleBinding
    k8s@terminal:~$ kc rolebinding processor --role=processor -n=project-hamster --serviceaccount=project-hamster:processor --user=k8s $d
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      creationTimestamp: null
      name: processor
      namespace: project-hamster
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: processor
    subjects:
    - apiGroup: rbac.authorization.k8s.io
      kind: User
      name: k8s
    - kind: ServiceAccount
      name: processor.
      namespace: project-hamster
      
    
    ### ROLEBINDING - Worked for current user
    k8s@terminal:~$ k auth can-i --list --as=k8s | grep "configmaps\|secrets"
    configmaps                                      []                  []               [create]
    secrets                                         []                  []               [create]
    ### ROLEBINDING - Not sure for service account
    k8s@terminal:~$ k auth can-i --list --as=processor | grep "configmaps\|secrets"
    k8s@terminal:~$

</details>

## 11) 4% | DaemonSet on all Nodes
Use context: kubectl config use-context k8s-c1-H. SO BAD!!
Use Namespace project-tiger for the following. Create a DaemonSet named ds-important with image httpd:2.4-alpine and labels id=ds-important and uuid=18426a0b-5f59-4e10-923f-c0e078e82462. The Pods it creates should request 10 millicore cpu and 10 megabytes memory. The Pods of that DaemonSet should run on all nodes.
<details>
  <summary markdown="span">Answer</summary>

RECALL - HOW TO CREATE A DAEMONSET??

1) Remove "Status"
2) Remove "Replicas"
3) Change Deployment -> Daemonset

apiVersion: apps/v1
kind: DaemonSet
metadata:
  creationTimestamp: null
  labels:
    app: ds-important
    id: ds-important
    uuid: 18426a0b-5f59-4e10-923f-c0e078e82462
  name: ds-important
spec:
  selector:
    matchLabels:
      app: ds-important
      id: ds-important
      uuid: 18426a0b-5f59-4e10-923f-c0e078e82462
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: ds-important
        id: ds-important
        uuid: 18426a0b-5f59-4e10-923f-c0e078e82462
    spec:
      containers:
      - image: httpd:2.4-alpine
        name: httpd
        resources: 
          requests:
            cpu: 10m
            memory: 10Mi

</details>

## 12) 6% | Deployment on all Nodes
Use context: kubectl config use-context k8s-c1-H
Use Namespace project-tiger for the following. Create a Deployment named deploy-important with label id=very-important (the pods should also have this label) and 3 replicas. It should contain two containers, the first named container1 with image nginx:1.17.6-alpine and the second one named container2 with image kubernetes/pause.
There should be only ever one Pod of that Deployment running on one worker node. We have two worker nodes: cluster1-worker1 and cluster1-worker2. Because the Deployment has three replicas the result should be that on both nodes one Pod is running. The third Pod won't be scheduled, unless a new worker node will be added.
In a way we kind of simulate the behaviour of a DaemonSet here, but using a Deployment and a fixed number of replicas.

<details>
  <summary markdown="span">Answer</summary>


https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#an-example-of-a-pod-that-uses-pod-affinity
NOTE 
- Topology Key is required (PodAffinity/PodAntiAffinity)
  ==> Usually key ==  kubernetes.io/hostname
- 

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      creationTimestamp: null
      labels:
        app: deploy-important
        id: very-important
      name: deploy-important
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: deploy-important
          id: very-important
      strategy: {}
      template:
        metadata:
          creationTimestamp: null
          labels:
            app: deploy-important
            id: very-important
        spec:
          affinity:
            podAntiAffinity:
              requiredDuringSchedulingIgnoredDuringExecution: 
              - topologyKey: kubernetes.io/hostname
                labelSelector:
                  matchLabels:
                    id: very-important
          containers:
          - image: nginx:1.17.6-alpine
            name: container1 
            resources: {}
          - image: kubernetes/pause
            name: container2
            resources: {}
    
    k8s@terminal:~$ kg pods -owide | grep deploy-important
    deploy-important-cc477694b-55k6m       2/2     Running   0          75s    10.44.0.21   cluster1-worker1   <none>           <none>
    deploy-important-cc477694b-8f9pt       0/2     Pending   0          24s    <none>       <none>             <none>           <none>
    deploy-important-cc477694b-b7qsc       2/2     Running   0          24s    10.47.0.31   cluster1-worker2   <none>           <none>
  
Warning  FailedScheduling  63s (x3 over 65s)  default-scheduler  0/3 nodes are available: 1 node(s) had taint {node-role.kubernetes.io/master: }, 
that the pod didn't tolerate, 2 node(s) didn't match pod affinity/anti-affinity, 2 node(s) didn't satisfy existing pods anti-affinity rules.
</details>

## 13) 4% | Multi Containers and Pod shared Volume
Use context: kubectl config use-context k8s-c1-H

Create a Pod named multi-container-playground in Namespace default with three containers, named c1, c2 and c3. There should be a volume attached to that Pod and mounted into every container, but the volume shouldn't be persisted or shared with other Pods.
Container c1 should be of image nginx:1.17.6-alpine and have the name of the node where its Pod is running on value available as environment variable MY_NODE_NAME.
Container c2 should be of image busybox:1.31.1 and write the output of the date command every second in the shared volume into file date.log. You can use while true; do date >> /your/vol/path/date.log; sleep 1; done for this.
Container c3 should be of image busybox:1.31.1 and constantly write the content of file date.log from the shared volume to stdout. You can use tail -f /your/vol/path/date.log for this.
Check the logs of container c3 to confirm correct setup.

<details>
  <summary markdown="span">Answer</summary>
    
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: multi-container-playground
      name: multi-container-playground
      namespace: default
    spec:
      volumes:
      - name: empty-vol
        emptyDir: {}
      containers:
      - image: nginx:1.17.6-alpine
        name: c1
        resources: {}
        volumeMounts:
        - name: empty-vol
          mountPath: /tmp
        env:
        - name: MY_NODE_NAME
          valueFrom:
            fieldRef: 
              fieldPath: spec.nodeName
      - image: busybox:1.31.1
        name: c2
        resources: {}
        volumeMounts:
        - name: empty-vol
          mountPath: /tmp
        command:
        - /bin/sh
        - -c
        - while true; do date >> /tmp/date.log; sleep 1; done
      - image: busybox:1.31.1
        name: c3
        resources: {}
        volumeMounts:
        - name: empty-vol
          mountPath: /tmp
        command:
        - /bin/sh
        - -c
        - tail -f  /tmp/date.log
      dnsPolicy: ClusterFirst
      restartPolicy: Always
    status: {}
    
    k8s@terminal:~$ kl multi-container-playground -c=c3
    Sat Sep 18 18:39:02 UTC 2021
    Sat Sep 18 18:39:03 UTC 2021
    Sat Sep 18 18:39:04 UTC 2021
    Sat Sep 18 18:39:05 UTC 2021
    Sat Sep 18 18:39:06 UTC 2021
    Sat Sep 18 18:39:07 UTC 2021
    Sat Sep 18 18:39:08 UTC 2021
    Sat Sep 18 18:39:09 UTC 2021
    Sat Sep 18 18:39:10 UTC 2021
    Sat Sep 18 18:39:11 UTC 2021
    Sat Sep 18 18:39:12 UTC 2021
    Sat Sep 18 18:39:13 UTC 2021
    Sat Sep 18 18:39:14 UTC 2021
    Sat Sep 18 18:39:15 UTC 2021
    Sat Sep 18 18:39:16 UTC 2021
    Sat Sep 18 18:39:17 UTC 2021
    Sat Sep 18 18:39:18 UTC 2021
    Sat Sep 18 18:39:19 UTC 2021
</details>

## 14) 2% | Find out Cluster Information
Use context: kubectl config use-context k8s-c1-H
You're ask to find out following information about the cluster k8s-c1-H:

How many master nodes are available?
How many worker nodes are available?
What is the Pod CIDR of cluster1-worker1?
What is the Service CIDR?
Which Networking (or CNI Plugin) is configured and where is its config file?
Which suffix will static pods have that run on cluster1-worker1?
Write your answers into file /opt/course/14/cluster-info, structured like this:

-> /opt/course/14/cluster-info
1: [ANSWER]
2: [ANSWER]
3: [ANSWER]
4: [ANSWER]
5: [ANSWER]
6: [ANSWER]
<details>
  <summary markdown="span">Answer</summary>

k8s@terminal:~$ kg nodes -Aowide
NAME               STATUS   ROLES                  AGE    VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
cluster1-master1   Ready    control-plane,master   137d   v1.21.0   192.168.100.11   <none>        Ubuntu 18.04.5 LTS   4.15.0-124-generic   docker://20.10.2
cluster1-worker1   Ready    <none>                 137d   v1.21.0   192.168.100.12   <none>        Ubuntu 18.04.5 LTS   4.15.0-124-generic   docker://20.10.2
cluster1-worker2   Ready    <none>                 137d   v1.21.0   192.168.100.13   <none>        Ubuntu 18.04.5 LTS   4.15.0-124-generic   docker://20.10.2
k8s@terminal:~$ kd node/cluster1-worker1 | grep -i cidr
PodCIDR:                      10.244.1.0/24
PodCIDRs:                     10.244.1.0/24
k8s@terminal:~$ ssh cluster1-master1 "cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep ip-range"
    - --service-cluster-ip-range=10.96.0.0/12
k8s@terminal:~$ ssh cluster1-master1 "cat /etc/cni/net.d/*"
{
    "cniVersion": "0.3.0",
    "name": "weave",
    "plugins": [
        {
            "name": "weave",
            "type": "weave-net",
            "hairpinMode": true
        },
        {
            "type": "portmap",
            "capabilities": {"portMappings": true},
            "snat": true
        }
    ]
}
k8s@terminal:~$ ssh cluster1-master1 "ls /etc/cni/net.d/"
10-weave.conflist

k8s@terminal:~$ kg pods -Aowide | grep cluster1-worker1
default           nginx-cluster1-worker1                     1/1     Running            0          22s    10.44.0.22       cluster1-worker1   <none>           <none>
</details>

## 15) 3% | Cluster Event Logging (NO IDEA)
Use context: kubectl config use-context k8s-c2-AC
Write a command into /opt/course/15/cluster_events.sh which shows the latest events in the whole cluster, ordered by time. Use kubectl for it.
Now kill the kube-proxy Pod running on node cluster2-worker1 and write the events this caused into /opt/course/15/pod_kill.log.
Finally kill the main docker container of the kube-proxy Pod on node cluster2-worker1 and write the events into /opt/course/15/container_kill.log.
Do you notice differences in the events both actions caused?

<details>
  <summary markdown="span">Answer</summary>

</details>

## 16) 2% | Namespaces and Api Resources 
Use context: kubectl config use-context k8s-c1-H
Create a new Namespace called cka-master.
Write the names of all namespaced Kubernetes resources (like Pod, Secret, ConfigMap...) into /opt/course/16/resources.txt.
Find the project-* Namespace with the highest number of Roles defined in it and write its name and amount of Roles into /opt/course/16/crowded-namespace.txt.

<details>
  <summary markdown="span">Answer</summary>
k8s@terminal:~$ kubectl api-resources -h

k8s@terminal:~$ kubectl api-resources --namespaced=true -o=name | sed "s;\..*;;" | tr '\n' ','
bindings,configmaps,endpoints,events,limitranges,persistentvolumeclaims,pods,podtemplates,replicationcontrollers,resourcequotas,secrets,serviceaccounts,services,controllerrevisions,daemonsets,deployments,replicasets,statefulsets,localsubjectaccessreviews,horizontalpodautoscalers,cronjobs,jobs,leases,endpointslices,events,ingresses,ingresses,networkpolicies,poddisruptionbudgets,rolebindings,roles,csistoragecapacities,


k8s@terminal:~$ kg roles -A | grep -c project-c14  
300

</details>

## 17) 3% - DOCKER
Use context: kubectl config use-context k8s-c1-H
In Namespace project-tiger create a Pod named tigers-reunite of image httpd:2.4.41-alpine with labels pod=container and container=pod. Find out on which node the Pod is scheduled. Ssh into that node and find the docker container(s) belonging to that Pod.
Write the docker IDs of the container(s) and the process/command these are running into /opt/course/17/pod-container.txt.
Finally write the logs of the main docker container (from the one you specified in your yaml) into /opt/course/17/pod-container.log using the docker command.

<details>
  <summary markdown="span">Answer</summary>

    sedGrep() { grep $1 | sed "s;$1;;" | xargs; }

    k8s@terminal:~$ k run tigers-reunite --image=httpd:2.4.41-alpine -l pod=container,container=pod 
    pod/tigers-reunite created
    
    k8s@terminal:~$ kd pods/tigers-reunite | sedGrep .*Node:
    cluster1-worker2/192.168.100.13
    
    root@cluster1-worker2:~# docker ps | grep tigers-reunite
    19ebe3b047f1   54b0995a6305             "httpd-foreground"       5 minutes ago   Up 5 minutes             k8s_tigers-reunite_tigers-reunite_project-tiger_80b27925-4f00-4c2b-be7f-d6ad59c1ecea_0
    0c11bdd2c65f   k8s.gcr.io/pause:3.4.1   "/pause"                 5 minutes ago   Up 5 minutes             k8s_POD_tigers-reunite_project-tiger_80b27925-4f00-4c2b-be7f-d6ad59c1ecea_0
    
    docker logs 19ebe3b047f1
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.47.0.33. Set the 'ServerName' directive globally to suppress this message
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.47.0.33. Set the 'ServerName' directive globally to suppress this message
    [Sat Sep 18 20:12:53.028205 2021] [mpm_event:notice] [pid 1:tid 140067529362760] AH00489: Apache/2.4.41 (Unix) configured -- resuming normal operations
    [Sat Sep 18 20:12:53.028281 2021] [core:notice] [pid 1:tid 140067529362760] AH00094: Command line: 'httpd -D FOREGROUND'
</details>

## 18) 8% | Fix Kubelet
Use context: kubectl config use-context k8s-c3-CCC
There seems to be an issue with the kubelet not running on cluster3-worker1. Fix it and confirm that cluster3 has node cluster3-worker1 available in Ready state afterwards. Schedule a Pod on cluster3-worker1.
Write the reason of the is issue into /opt/course/18/reason.txt.
<details>
  <summary markdown="span">Answer</summary>

k8s@terminal:~$ ssh cluster3-worker1 "systemctl status kubelet"
● kubelet.service - kubelet: The Kubernetes Node Agent
   Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
  Drop-In: /etc/systemd/system/kubelet.service.d
           └─10-kubeadm.conf
   Active: inactive (dead) since Tue 2021-05-04 11:00:49 UTC; 4 months 15 days ago
     Docs: https://kubernetes.io/docs/home/
 Main PID: 8024 (code=exited, status=0/SUCCESS)

May 04 11:00:43 cluster3-worker1 kubelet[8024]: E0504 11:00:43.690037    8024 aws_credentials.go:77] while getting AWS credentials NoCredentialProviders: no valid providers in chain. Deprecated.
May 04 11:00:43 cluster3-worker1 kubelet[8024]:         For verbose messaging see aws.Config.CredentialsChainVerboseErrors
May 04 11:00:45 cluster3-worker1 kubelet[8024]: I0504 11:00:45.868667    8024 cni.go:239] "Unable to update cni config" err="no networks found in /etc/cni/net.d"
May 04 11:00:46 cluster3-worker1 kubelet[8024]: I0504 11:00:46.677313    8024 pod_container_deletor.go:79] "Container not found in pod's containers" containerID="aaabe735c0ff0d32eeead315ca03087d3a415fe0ed44d1adac0739f1d123a0eb"
May 04 11:00:47 cluster3-worker1 kubelet[8024]: E0504 11:00:47.680778    8024 kubelet.go:2218] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized"
May 04 11:00:48 cluster3-worker1 systemd[1]: kubelet.service: Current command vanished from the unit file, execution of the command list won't be resumed.
May 04 11:00:48 cluster3-worker1 kubelet[8024]: I0504 11:00:48.630794    8024 pod_container_deletor.go:79] "Container not found in pod's containers" containerID="dfb1cbde047e6ebc1ed74184b9197c9d6fb96eb78d13d7f2cda9d9179af4d56c"
May 04 11:00:49 cluster3-worker1 systemd[1]: Stopping kubelet: The Kubernetes Node Agent...
May 04 11:00:49 cluster3-worker1 kubelet[8024]: I0504 11:00:49.708717    8024 dynamic_cafile_content.go:182] Shutting down client-ca-bundle::/etc/kubernetes/pki/ca.crt
May 04 11:00:49 cluster3-worker1 systemd[1]: Stopped kubelet: The Kubernetes Node Agent.

k8s@terminal:~$ kubectl get pods -Aowide | grep cluster3-worker1
kube-system   kube-proxy-c5n54                           0/1     ContainerCreating   0          137d   192.168.100.32   cluster3-worker1   <none>           <none>
kube-system   weave-net-mlwm4                            0/2     Init:0/1            0          137d   192.168.100.32   cluster3-worker1   <none>           <none>


root@cluster3-worker1:/etc# journalctl -u kubelet | grep Failed
May 04 11:00:12 cluster3-worker1 kubelet[4982]: E0504 11:00:12.237907    4982 server.go:292] "Failed to run kubelet" err="failed to run Kubelet: running with swap on is not supported, please disable swap! or set --fail-swap-on flag to false. /proc/swaps contained: [Filename\t\t\t\tType\t\tSize\tUsed\tPriority /dev/vda2                               partition\t1999868\t6668\t-2]"
May 04 11:00:12 cluster3-worker1 systemd[1]: kubelet.service: Failed with result 'exit-code'.
May 04 11:00:12 cluster3-worker1 kubelet[5715]: E0504 11:00:12.624604    5715 server.go:204] "Failed to load kubelet config file" err="failed to load Kubelet config file /var/lib/kubelet/config.yaml, error failed to read kubelet config file \"/var/lib/kubelet/config.yaml\", error: open /var/lib/kubelet/config.yaml: no such file or directory" path="/var/lib/kubelet/config.yaml"
May 04 11:00:12 cluster3-worker1 systemd[1]: kubelet.service: Failed with result 'exit-code'.
May 04 11:00:23 cluster3-worker1 kubelet[7480]: E0504 11:00:23.113932    7480 server.go:204] "Failed to load kubelet config file" err="failed to load Kubelet config file /var/lib/kubelet/config.yaml, error failed to read kubelet config file \"/var/lib/kubelet/config.yaml\", error: open /var/lib/kubelet/config.yaml: no such file or directory" path="/var/lib/kubelet/config.yaml"
May 04 11:00:23 cluster3-worker1 systemd[1]: kubelet.service: Failed with result 'exit-code'.
May 04 11:00:33 cluster3-worker1 kubelet[7633]: E0504 11:00:33.926024    7633 server.go:204] "Failed to load kubelet config file" err="failed to load Kubelet config file /var/lib/kubelet/config.yaml, error failed to read kubelet config file \"/var/lib/kubelet/config.yaml\", error: open /var/lib/kubelet/config.yaml: no such file or directory" path="/var/lib/kubelet/config.yaml"
May 04 11:00:34 cluster3-worker1 systemd[1]: kubelet.service: Failed with result 'exit-code'.
May 04 11:00:41 cluster3-worker1 kubelet[8024]: E0504 11:00:41.549085    8024 nodelease.go:49] "Failed to get node when trying to set owner ref to the node lease" err="nodes \"cluster3-worker1\" not found" node="cluster3-worker1"
May 04 11:00:42 cluster3-worker1 kubelet[8024]: I0504 11:00:42.426665    8024 manager.go:600] "Failed to retrieve checkpoint" checkpoint="kubelet_internal_checkpoint" err="checkpoint is not found"

### Says no Kubelet config, but I see one...
root@cluster3-worker1:/var/lib/kubelet# ls
config.yaml  cpu_manager_state  device-plugins  kubeadm-flags.env  pki  plugins  plugins_registry  pod-resources  pods

### KUBELET EXEC's MAY BE MIXED UP
root@cluster3-worker1:~# which kubelet
/usr/bin/kubelet
root@cluster3-worker1:~# systemctl status kubelet | grep "/usr/local/bin/kubelet"
  Process: 10107 ExecStart=/usr/local/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS (code=exited, status=203/EXEC)

root@cluster3-worker1:/etc/systemd/system/kubelet.service.d# vi 10-kubeadm.conf 
root@cluster3-worker1:/etc/systemd/system/kubelet.service.d# systemctl restart kubelet
Warning: The unit file, source configuration file or drop-ins of kubelet.service changed on disk. Run 'systemctl daemon-reload' to reload units.

k8s@terminal:~$ kg pods -Aowide | grep "nginx\|NAME"
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE    IP               NODE               NOMINATED NODE   READINESS GATES
default       nginx                                      1/1     Running   0          21s    10.44.0.1        cluster3-worker1   <none>           <none>


k8s@terminal:~$ cat /opt/course/18/reason.txt
1) Swap was enabled - "Failed to run kubelet" err="failed to run Kubelet: running with swap on is not supported, please disable swap! or set --fail-swap-on flag to false.
2) ExecStart:
   a) Pointed to - /usr/local/bin/kubelet
   b) Should have pointed - /user/bin/kubelet
   
</details>

## 19) 3% | Create Secret and mount into Pod
this task can only be solved if questions 18 or 20 have been successfully implemented and the k8s-c3-CCC cluster has a functioning worker node
Use context: kubectl config use-context k8s-c3-CCC
Do the following in a new Namespace secret. Create a Pod named secret-pod of image busybox:1.31.1 which should keep running for some time, it should be able to run on master nodes as well.
There is an existing Secret located at /opt/course/19/secret1.yaml, create it in the secret Namespace and mount it readonly into the Pod at /tmp/secret1.
Create a new Secret in Namespace secret called secret2 which should contain user=user1 and pass=1234. These entries should be available inside the Pod's container as environment variables APP_USER and APP_PASS.
Confirm everything is working.
<details>
  <summary markdown="span">Answer</summary>
    
    k8s@terminal:~$ kd nodes | grep "Unschedulable\|Taints:"
    Taints:             node-role.kubernetes.io/master:NoSchedule
    Unschedulable:      false
    Taints:             <none>
    Unschedulable:      false
    
    
    k8s@terminal:~$ k create secret generic secret2 --from-literal=user=user1 --from-literal=pass=1234 -n=secret 
    secret/secret2 created
    
    k8s@terminal:~$ cat /opt/course/19/secret1.yaml | sed "s/todo/secret\n/" | k create -f - 
    secret/secret1 created
    k8s@terminal:~$ k run secret-pod --image=busybox:1.31.1 -n=secret $d -- /bin/sh -c "sleep 4800;"
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: secret-pod
      name: secret-pod
      namespace: secret
    spec:
      nodeName: cluster3-master1
      volumes:
      - name: secret-vol
        secret: 
          secretName: secret1
      containers:
      - args:
        - /bin/sh
        - -c
        - sleep 4800;
        image: busybox:1.31.1
        name: secret-pod
        resources: {}
        volumeMounts:
        - name: secret-vol
          mountPath: /tmp/secret1
        env:
        - name: APP_USER
          valueFrom:
            secretKeyRef:
              name:  secret2
              key: user
        - name: APP_PASS
          valueFrom:
            secretKeyRef:
              name:  secret2
              key: pass
      dnsPolicy: ClusterFirst
      restartPolicy: Always
    status: {}
    
    
    
    
    k8s@terminal:~$ kx secret-pod -- env | grep APP
    APP_USER=user1
    APP_PASS=1234
    k8s@terminal:~$ kx secret-pod -- cat /tmp/secret1/halt | grep -c ''
    83

</details>

## 20) 10% Node - NOT-DONE
Your coworker said node cluster3-worker2 is running an older Kubernetes version and is not even part of the cluster. Update kubectl and kubeadm to the version that's running on cluster3-master1. Then add this node to the cluster, you can use kubeadm for this.
<details>
  <summary markdown="span">Answer</summary>
    
    ==> WASN"T SURE HOW TO ADD Other Node w/out Join
    
    
    k8s@terminal:~$ kg nodes
    NAME               STATUS     ROLES                  AGE    VERSION
    cluster3-master1   Ready      control-plane,master   136d   v1.21.0
    cluster3-worker1   NotReady   <none>                 136d   v1.21.0
    
    root@cluster3-master1:~# kubeadm version -o=short
    v1.21.0
    
    
    apt-get update
    apt list -a kubeadm | grep 1.21.0
    apt list -a kubelet | grep 1.21.0
    apt-get install -y kubeadm=1.21.0-00
    apt-get install -y kubelet=1.21.0-00
    
    root@cluster3-master1:~# km config print join-defaults
    apiVersion: kubeadm.k8s.io/v1beta2
    caCertPath: /etc/kubernetes/pki/ca.crt
    discovery:
      bootstrapToken:
        apiServerEndpoint: kube-apiserver:6443
        token: abcdef.0123456789abcdef
        unsafeSkipCAVerification: true
      timeout: 5m0s
      tlsBootstrapToken: abcdef.0123456789abcdef
    kind: JoinConfiguration
    nodeRegistration:
      criSocket: /var/run/dockershim.sock
      name: cluster3-master1
      taints: null

    root@cluster3-worker2:~# km join kube-apiserver:6443 --tls-bootstrap-token=abcdef.0123456789abcdef
    [discovery.bootstrapToken: Invalid value: "": using token-based discovery without caCertHashes can be unsafe. Set unsafeSkipCAVerification as true in your kubeadm config file or pass --discovery-token-unsafe-skip-ca-verification flag to continue, discovery.bootstrapToken.token: Invalid value: "": the bootstrap token is invalid]
    To see the stack trace of this error execute with --v=5 or higher
    root@cluster3-worker2:~# km join kube-apiserver:6443 --tls-bootstrap-token=abcdef.0123456789abcdef --discovery-token-unsafe-skip-ca-verification=true
    discovery.bootstrapToken.token: Invalid value: "": the bootstrap token is invalid
    To see the stack trace of this error execute with --v=5 or higher
    root@cluster3-worker2:~# km join kube-apiserver:6443 --tls-bootstrap-token abcdef.0123456789abcdef --discovery-token-unsafe-skip-ca-verification=true
    discovery.bootstrapToken.token: Invalid value: "": the bootstrap token is invalid
    To see the stack trace of this error execute with --v=5 or higher
    root@cluster3-worker2:~# km join kube-apiserver:6443 --token=abcdef.0123456789abcdef
    discovery.bootstrapToken: Invalid value: "": using token-based discovery without caCertHashes can be unsafe. Set unsafeSkipCAVerification as true in your kubeadm config file or pass --discovery-token-unsafe-skip-ca-verification flag to continue
    To see the stack trace of this error execute with --v=5 or higher
    root@cluster3-worker2:~# km join kube-apiserver:6443 --token=abcdef.0123456789abcdef --discovery-token-unsafe-skip-ca-verification=true
    [preflight] Running pre-flight checks
    
    
    ^C
    I0918 17:23:49.495289   17534 token.go:78] [discovery] Created cluster-info discovery client, requesting info from "kube-apiserver:6443"
    I0918 17:23:49.499066   17534 round_trippers.go:454] GET https://kube-apiserver:6443/api/v1/namespaces/kube-public/configmaps/cluster-info?timeout=10s  in 2 milliseconds
    I0918 17:23:49.499135   17534 token.go:215] [discovery] Failed to request cluster-info, will try again: Get "https://kube-apiserver:6443/api/v1/namespaces/kube-public/configmaps/cluster-info?timeout=10s": dial tcp: lookup kube-apiserver on 8.8.8.8:53: no such host
        
</details>

## 21) 2% StaticPod/NodePort
Create a Static Pod named my-static-pod in Namespace default on cluster3-master1. It should be of image nginx:1.16-alpine and have resource requests for 10m CPU and 20Mi memory.

Then create a NodePort Service named static-pod-service which exposes that static Pod on port 80 and check if it has Endpoints and if its reachable through the cluster3-master1 internal IP address. You can connect to the internal node IPs from your main terminal.
<details>
  <summary markdown="span">Answer</summary>

k run my-static-pod --image=nginx:1.16-alpine --namespace=default --port=80 $d
k expose pod/my-static-pod-cluster3-master1 --type=NodePort --name=static-pod-service

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: my-static-pod
  name: my-static-pod
  namespace: default
spec:
  containers:
  - image: nginx:1.16-alpine
    name: my-static-pod
    ports:
    - containerPort: 80
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

root@cluster3-master1:~# kg pods
NAME                             READY   STATUS    RESTARTS   AGE
my-static-pod-cluster3-master1   1/1     Running   0          26s
root@cluster3-master1:~# kg ep
NAME                 ENDPOINTS             AGE
kubernetes           192.168.100.31:6443   136d
static-pod-service   10.32.0.4:80          4s

</details>

## 22) 2% | Check how long certificates are valid
Check how long the kube-apiserver server certificate is valid on cluster2-master1. Do this with openssl or cfssl. Write the exipiration date into /opt/course/22/expiration.

Also run the correct kubeadm command to list the expiration dates and confirm both methods show the same date.

Write the correct kubeadm command that would renew the apiserver server certificate into /opt/course/22/kubeadm-renew-certs.sh.
<details>
  <summary markdown="span">Answer</summary>

root@cluster2-master1:/etc/kubernetes/pki# cat /etc/kubernetes/pki/apiserver.crt | openssl x509 -text -noout | grep -e "Not After"
Not After : Sep 17 19:48:09 2022 GMT

root@cluster2-master1:~# kubeadm certs check-expiration
[check-expiration] Reading configuration from the cluster...
[check-expiration] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'

CERTIFICATE                EXPIRES                  RESIDUAL TIME   CERTIFICATE AUTHORITY   EXTERNALLY MANAGED
admin.conf                 Sep 17, 2022 19:48 UTC   364d                                    no      
apiserver                  Sep 17, 2022 19:48 UTC   364d            ca                      no      
apiserver-etcd-client      Sep 17, 2022 19:48 UTC   364d            etcd-ca                 no      
apiserver-kubelet-client   Sep 17, 2022 19:48 UTC   364d            ca                      no      
controller-manager.conf    Sep 17, 2022 19:48 UTC   364d                                    no      
etcd-healthcheck-client    Sep 17, 2022 19:48 UTC   364d            etcd-ca                 no      
etcd-peer                  Sep 17, 2022 19:48 UTC   364d            etcd-ca                 no      
etcd-server                Sep 17, 2022 19:48 UTC   364d            etcd-ca                 no      
front-proxy-client         Sep 17, 2022 19:48 UTC   364d            front-proxy-ca          no      
scheduler.conf             Sep 17, 2022 19:48 UTC   364d                                    no      

CERTIFICATE AUTHORITY   EXPIRES                  RESIDUAL TIME   EXTERNALLY MANAGED
ca                      May 02, 2031 10:48 UTC   9y              no      
etcd-ca                 May 02, 2031 10:48 UTC   9y              no      
front-proxy-ca          May 02, 2031 10:48 UTC   9y              no   



Sep 17 19:48:09 2022 GMT
kubeadm certs check-expiration
kubeadm certs renew apiserver
</details>

## 23) 2% | Kubelet client/server cert info
Node cluster2-worker1 has been added to the cluster using kubeadm and TLS bootstrapping.

Find the "Issuer" and "Extended Key Usage" values of the cluster2-worker1:

kubelet client certificate, the one used for outgoing connections to the kube-apiserver.
kubelet server certificate, the one used for incoming connections from the kube-apiserver.
Write the information into file /opt/course/23/certificate-info.txt.

Compare the "Issuer" and "Extended Key Usage" fields of both certificates and make sense of these.
<details>
  <summary markdown="span">Answer</summary>

root@cluster2-worker1:/etc/kubernetes# ls manifests/
root@cluster2-worker1:/etc/kubernetes# ls pki/
ca.crt

NOT sure where the data is?

openssl x509 -text -noout

</details>

## 24) 9% | NetworkPolicy
There was a security incident where an intruder was able to access the whole cluster from a single hacked backend Pod.
To prevent this create a NetworkPolicy called np-backend in Namespace project-snake. It should allow the backend-* Pods only to:

connect to db1-* Pods on port 1111
connect to db2-* Pods on port 2222
Use the app label of Pods in your policy.

After implementation, connections from backend-* Pods to vault-* Pods on port 3333 should for example no longer work.

<details>
  <summary markdown="span">Answer</summary>

kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: np-backend
  namespace: project-snake
spec:
  policyTypes: ["Egress"]
  podSelector:
    matchLabels:
      app: backend
  egress:
  - ports:
    - port: 1111
    - port: 2222
    to:
    - podSelector:
        matchLabels:
          app: db

k8s@terminal:~$ kd netpol/np-backend
Name:         np-backend
Namespace:    project-snake
Created on:   2021-09-17 21:36:35 +0000 UTC
Labels:       <none>
Annotations:  <none>
Spec:
  PodSelector:     app=backend
  Not affecting ingress traffic
  Allowing egress traffic:
    To Port: 1111/TCP
    To Port: 2222/TCP
    To:
      PodSelector: app=db
  Policy Types: Egress


</details>

## 25) 8% | Etcd Snapshot Save and Restore
kubectl config use-context k8s-c3-CCC
Make a backup of etcd running on cluster3-master1 and save it on the master node at /tmp/etcd-backup.db.
Then create a Pod of your kind in the cluster.
Finally restore the backup, confirm the cluster is still working and that the created Pod is no longer with us.
<details>
  <summary markdown="span">Answer</summary>

root@cluster3-master1:~# e snapshot save $ETCD_ARGS /tmp/etcd-backup.db
Snapshot saved at /tmp/etcd-backup.db
root@cluster3-master1:~# k run nginx --image=nginx
pod/nginx created
root@cluster3-master1:~# kg pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   0/1     Pending   0          4s

!!!!!WRONG 
root@cluster3-master1:~# e snapshot restore $ETCD_ARGS /tmp/etcd-backup.db
2021-09-17 21:10:14.378029 I | mvcc: restore compact to 8919
2021-09-17 21:10:14.405195 I | etcdserver/membership: added member 8e9e05c52164694d [http://localhost:2380] to cluster cdf818194e3a8c32

root@cluster3-master1:~# cat /etc/kubernetes/manifests/etcd.yaml | sed "s;/var/lib/etcd;/var/lib/etcd-backup;" | tee etcd.yaml
root@cluster3-master1:~# cat etcd.yaml > /etc/kubernetes/manifests/etcd.yaml

!!!!! RIGHT
root@cluster3-master1:~# e snapshot restore $ETCD_ARGS --data-dir=/var/lib/etcd-backup /tmp/etcd-backup.db
2021-09-17 21:15:04.111776 I | mvcc: restore compact to 8919
2021-09-17 21:15:04.148688 I | etcdserver/membership: added member 8e9e05c52164694d [http://localhost:2380] to cluster cdf818194e3a8c32


root@cluster3-master1:~# kg pods
No resources found in default namespace.

</details>



## EXTRA-1) Find Pods first to be terminated
Check all available Pods in the Namespace project-c13 and find the names of those that would
probably be terminated first if the nodes run out of resources (cpu or memory) to schedule all Pods. 
Write the Pod names into /opt/course/e1/pods-not-stable.txt.
<details>
  <summary markdown="span">Answer</summary>

DEPLOY-1=$RANDOM
kc deploy deploy1 --image=nginx && k scale deploy1 --replicas=5 && k set resources deploy/deploy1 --limits=cpu=200m,memory=512Mi --requests=cpu=150m,memory=300Mi
  
    root@controlplane:~# kg pods --no-headers -ocustom-columns=LIMIT:.spec.containers[*].resources.requests,NAME:.metadata.name | sort 
    <none>                       nginx
    map[cpu:100m memory:256Mi]   my-deploy-5b4845c7bd-5rr7m
    map[cpu:100m memory:256Mi]   my-deploy-5b4845c7bd-9tg4r
    map[cpu:100m memory:256Mi]   my-deploy-5b4845c7bd-l8fch
    map[cpu:100m memory:256Mi]   my-deploy-5b4845c7bd-tzc67
    map[cpu:100m memory:256Mi]   my-deploy-5b4845c7bd-vqqvp
    map[cpu:150m memory:300Mi]   deploy1-7dc5866f56-hjjm2
    map[cpu:150m memory:300Mi]   deploy1-7dc5866f56-lvjrt
    map[cpu:150m memory:300Mi]   deploy1-7dc5866f56-s76lm
    map[cpu:150m memory:300Mi]   deploy1-7dc5866f56-sjgp9
    map[cpu:150m memory:300Mi]   deploy1-7dc5866f56-wt5wb

</details>

## EXTRA-2) Create own Scheduler and use it
Create a second kube-scheduler named my-shiny-scheduler which can just be a blunt copy from the existing default one and use as much of it as possible. Make sure both schedulers are running along side each other correctly.
Create a Pod named use-my-shiny-scheduler image httpd:2.4-alpine which uses the new scheduler and confirm the Pod is running.
<details>
  <summary markdown="span">Answer</summary>
  
  root@controlplane:~# wget https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/admin/sched/my-scheduler.yaml
  root@controlplane:~# cat my-scheduler.yaml | sed "s;gcr.io/my-gcp-project/my-kube-scheduler:1.0;k8s.gcr.io/kube-scheduler:v1.20.0;" > 2.yaml

  In pod, add ".spec.schedulerName:" Field

  
  
</details>

## EXTRA-3) Curl Manually Contact API
There is an existing ServiceAccount secret-reader in Namespace project-hamster. Create a Pod of image curlimages/curl:7.65.3 named tmp-api-contact which uses this ServiceAccount. 
Make sure the container keeps running. Exec into the Pod and use curl to access the Kubernetes Api of that cluster manually, listing all available secrets. You can ignore insecure https connection. Write the command(s) for this into file /opt/course/e4/list-secrets.sh.
<details>
  <summary markdown="span">Answer</summary>

</details>

Extra Question 1 | 


apiVersion: apps/v1
kind: Daemonset
metadata:
  creationTimestamp: null
  labels:
    app: ds-important
    id: ds-important
    uuid: 18426a0b-5f59-4e10-923f-c0e078e82462
  name: ds-important
spec:
  selector:
    matchLabels:
      app: ds-important
      id: ds-important
      uuid: 18426a0b-5f59-4e10-923f-c0e078e82462
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: ds-important
        id: ds-important
        uuid: 18426a0b-5f59-4e10-923f-c0e078e82462
    spec:
      containers:
      - image: httpd:2.4-alpine
        name: httpd
        resources: 
          requests:
            cpu: 10m
            memory: 10Mi
         


apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    component: kube-scheduler
    tier: control-plane
  name: my-shiny-scheduler                              # change
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-scheduler
    - --authentication-kubeconfig=/etc/kubernetes/scheduler.conf
    - --authorization-kubeconfig=/etc/kubernetes/scheduler.conf
    - --bind-address=127.0.0.1
    - --kubeconfig=/etc/kubernetes/scheduler.conf
    - --leader-elect=false                              # change
    - --scheduler-name=my-shiny-scheduler               # add
    - --port=12345                                      # change
    - --secure-port=12346                               # add
    image: k8s.gcr.io/kube-scheduler:v1.20.1
    imagePullPolicy: IfNotPresent
    livenessProbe:
      failureThreshold: 8
      httpGet:
        host: 127.0.0.1
        path: /healthz
        port: 12346                                     # change
        scheme: HTTPS
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    name: kube-scheduler
    resources:
      requests:
        cpu: 100m
    startupProbe:
      failureThreshold: 24
      httpGet:
        host: 127.0.0.1
        path: /healthz
        port: 12346                                     # change
        scheme: HTTPS
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    volumeMounts:
    - mountPath: /etc/kubernetes/scheduler.conf
      name: kubeconfig
      readOnly: true
  hostNetwork: true
  priorityClassName: system-node-critical
  volumes:
  - hostPath:
      path: /etc/kubernetes/scheduler.conf
      type: FileOrCreate
    name: kubeconfig


apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx2
spec:
  schedulerName: my-scheduler
  containers:
  - image: nginx
    name: nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
