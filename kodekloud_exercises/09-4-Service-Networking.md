## Questions

### 1) What network range are the nodes in the cluster part of?
<details> 
  <summary markdown="span">Answer</summary>

    10.29.219.0

    root@controlplane:~# ip -f inet addr | grep eth0  
    8860: eth0@if8861: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default  link-netnsid 0
    inet 10.29.219.3/24 brd 10.29.219.255 scope global eth0
    root@controlplane:~# k get nodes -oyaml | grep -e "- address:"
    - address: 10.29.219.3
    - address: controlplane
    - address: 10.29.219.6
    - address: node01
</details>

### 2) What is the range of IP addresses configured for PODs on this cluster?
<details>
  <summary markdown="span">Answer</summary>

    LOOK FOR IPALLOC_RANGE =>   10.50.0.0/16

    root@controlplane:~# k get pod/weave-net-2hsxz -n=kube-system -ocustom-columns=:spec.containers[] | grep IPALLOC_RANGE
    map[command:[/home/weave/launch.sh] env:[map[name:HOSTNAME valueFrom:map[fieldRef:map[apiVersion:v1 fieldPath:spec.nodeName]]] map[name:IPALLOC_RANGE value:10.50.0.0/16] map[name:INIT_CONTAINER value:true]] image:docker.io/weaveworks/weave-kube:2.8.1 imagePullPolicy:IfNotPresent name:weave readinessProbe:map[failureThreshold:3 httpGet:map[host:127.0.0.1 path:/status port:6784 scheme:HTTP] periodSeconds:10 successThreshold:1 timeoutSeconds:1] resources:map[requests:map[cpu:50m memory:100Mi]] securityContext:map[privileged:true] terminationMessagePath:/dev/termination-log terminationMessagePolicy:File volumeMounts:[map[mountPath:/weavedb name:weavedb] map[mountPath:/host/var/lib/dbus name:dbus] map[mountPath:/host/etc/machine-id name:machine-id readOnly:true] map[mountPath:/run/xtables.lock name:xtables-lock] map[mountPath:/var/run/secrets/kubernetes.io/serviceaccount name:weave-net-token-fd2gz readOnly:true]]]
    
    root@controlplane:~# k get pod/weave-net-2hsxz -n=kube-system -ocustom-columns=:spec.containers[0].env[1].value | xargs
    10.50.0.0/16
</details>

### 3) What is the IP Range configured for the services within the cluster?
<details>
  <summary markdown="span">Answer</summary>
    
    10.96.0.0/12

    root@controlplane:~# k get po/kube-apiserver-controlplane -n=kube-system -oyaml | grep -e --service-cluster-ip-range
    - --service-cluster-ip-range=10.96.0.0/12

    root@controlplane:~# k get po/kube-apiserver-controlplane -n=kube-system -ocustom-columns=:.spec.containers[].command \  
    | sed "s/ /\n/g" | grep -e --service-cluster-ip-range
    --service-cluster-ip-range=10.96.0.0/12
</details>

### 4) How many kube-proxy pods are deployed in this cluster?
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get pods -A | grep -v NAME | grep -c kube-proxy
    2

    root@controlplane:~# k get pods -A
    NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
    kube-system   coredns-74ff55c5b-bxp8t                1/1     Running   0          56m
    kube-system   coredns-74ff55c5b-gwr5c                1/1     Running   0          56m
    kube-system   etcd-controlplane                      1/1     Running   0          56m
    kube-system   kube-apiserver-controlplane            1/1     Running   0          56m
    kube-system   kube-controller-manager-controlplane   1/1     Running   0          56m
    kube-system   kube-proxy-9ph5v                       1/1     Running   0          56m
    kube-system   kube-proxy-k559l                       1/1     Running   0          55m
    kube-system   kube-scheduler-controlplane            1/1     Running   0          56m
    kube-system   weave-net-2hsxz                        2/2     Running   0          55m
    kube-system   weave-net-8k4tt                        2/2     Running   1          56m
</details>

### 5) What type of proxy is the kube-proxy configured to use?
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k logs po/kube-proxy-k559l -n=kube-system  
    W0814 17:11:44.508538       1 proxier.go:661] Failed to load kernel module ip_vs_wrr with modprobe. You can ignore this message when kube-proxy is running inside container without mounting /lib/modules
    W0814 17:11:44.511851       1 proxier.go:661] Failed to load kernel module ip_vs_sh with modprobe. You can ignore this message when kube-proxy is running inside container without mounting /lib/modules
    I0814 17:11:44.700199       1 node.go:172] Successfully retrieved node IP: 10.29.219.6
    I0814 17:11:44.700353       1 server_others.go:142] kube-proxy node IP is an IPv4 address (10.29.219.6), assume IPv4 operation
    W0814 17:11:44.817639       1 server_others.go:578] Unknown proxy mode "", assuming iptables proxy
    I0814 17:11:44.928383       1 server_others.go:185] Using iptables Proxier.
    I0814 17:11:45.036406       1 server.go:650] Version: v1.20.0
    I0814 17:11:45.118541       1 conntrack.go:52] Setting nf_conntrack_max to 1572864
    I0814 17:11:45.202490       1 conntrack.go:100] Set sysctl 'net/netfilter/nf_conntrack_tcp_timeout_established' to 86400
    I0814 17:11:45.208706       1 config.go:224] Starting endpoint slice config controller
    I0814 17:11:45.208750       1 shared_informer.go:240] Waiting for caches to sync for endpoint slice config
    I0814 17:11:45.208808       1 config.go:315] Starting service config controller
    I0814 17:11:45.208813       1 shared_informer.go:240] Waiting for caches to sync for service config
    I0814 17:11:45.309144       1 shared_informer.go:247] Caches are synced for service config
    I0814 17:11:45.309213       1 shared_informer.go:247] Caches are synced for endpoint slice config

</details>

### 6) How does this Kubernetes cluster ensure that a kube-proxy pod runs on all nodes in the cluster?
Inspect the kube-proxy pods and try to identify how they are deployed
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get ds -A
    NAMESPACE     NAME         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
    kube-system   kube-proxy   2         2         2       2            2           kubernetes.io/os=linux   76m
    kube-system   weave-net    2         2         2       2            2           <none>                   76m
</details>
