## Questions

### 1) How many nodes are part of this cluster?
<details> 
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get nodes | grep -vc NAME
    2
</details>

### 2) What is the Internal IP address of the controlplane node in this cluster?
<details>
  <summary markdown="span">Answer</summary> 

    root@controlplane:~# k get nodes/controlplane -ocustom-columns=:.status.addresses[].address | xargs
    10.149.81.6

    root@controlplane:~# k get nodes/controlplane -owide
    NAME           STATUS   ROLES                  AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
    controlplane   Ready    control-plane,master   26m   v1.20.0   10.149.81.6   <none>        Ubuntu 18.04.5 LTS   5.4.0-1049-gcp   docker://19.3.0
</details>

### 3) What is the network interface configured for cluster connectivity on the master node?
node-to-node communication

<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# ip a | grep 10.149.81.6/24
    inet 10.149.81.6/24 brd 10.149.81.255 scope global eth0

    root@controlplane:~# ip -f inet addr show | grep 10.149.81.6
    inet 10.149.81.6/24 brd 10.149.81.255 scope global eth0

    root@controlplane:~# ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    valid_lft forever preferred_lft forever
    2: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:4b:6c:fe:2b brd ff:ff:ff:ff:ff:ff
    inet 172.12.0.1/24 brd 172.12.0.255 scope global docker0
    valid_lft forever preferred_lft forever
    3: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue state UNKNOWN group default
    link/ether 2e:4d:23:f6:12:bd brd ff:ff:ff:ff:ff:ff
    inet 10.244.0.0/32 brd 10.244.0.0 scope global flannel.1
    valid_lft forever preferred_lft forever
    4: cni0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue state UP group default qlen 1000
    link/ether 4e:0a:f9:f8:d2:db brd ff:ff:ff:ff:ff:ff
    inet 10.244.0.1/24 brd 10.244.0.255 scope global cni0
    valid_lft forever preferred_lft forever
    5: vethe2a987d6@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue master cni0 state UP group default
    link/ether ce:19:f3:d2:af:ef brd ff:ff:ff:ff:ff:ff link-netnsid 2
    23045: eth0@if23046: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default
    link/ether 02:42:0a:95:51:06 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.149.81.6/24 brd 10.149.81.255 scope global eth0
    valid_lft forever preferred_lft forever
    6: veth4c6bccf6@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue master cni0 state UP group default
    link/ether 9a:d6:16:b5:98:17 brd ff:ff:ff:ff:ff:ff link-netnsid 3
    23049: eth1@if23050: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:11:00:4d brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet 172.17.0.77/16 brd 172.17.255.255 scope global eth1
    valid_lft forever preferred_lft forever
</details>

### 4) What is the MAC address of the interface on the master node?
<details>
  <summary markdown="span">Answer</summary>

    STEPS: 
    1) Get interface name -  "ip -f inet addr show | grep [CLUSTER-IP]"
    ==> inet 10.149.81.6/24 brd 10.149.81.255 scope global eth0

    2) Use Interface name (End of ^^) For MAC -  "ip -f link addr show eth0"
    ==> 23045: eth0@if23046: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default
        link/ether 02:42:0a:95:51:06 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    
    root@controlplane:~# ip addr show eth0
    23045: eth0@if23046: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default
    link/ether 02:42:0a:95:51:06 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.149.81.6/24 brd 10.149.81.255 scope global eth0
    valid_lft forever preferred_lft forever
    
    root@controlplane:~# ip -f link addr show eth0
    23045: eth0@if23046: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default
    link/ether 02:42:0a:95:51:06 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    
    root@controlplane:~# ip -f inet addr show eth0
    23045: eth0@if23046: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default  link-netnsid 0
    inet 10.149.81.6/24 brd 10.149.81.255 scope global eth0
    valid_lft forever preferred_lft forever

    02:42:0a:95:51:06 

    

</details>

### 5) What is the IP address assigned to node01?
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get nodes/node01 -ocustom-columns=:.status.addresses[].address | xargs
    10.149.81.9
</details>

### 6) What is the MAC address assigned to node01?
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# arp node01
    Address                  HWtype  HWaddress           Flags Mask            Iface
    10.149.81.8              ether   02:42:0a:95:51:07   C                     eth0

    OR

    root@controlplane:~# ssh node01

    root@node01:~# ip addr show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    valid_lft forever preferred_lft forever
    2: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:c7:83:84:62 brd ff:ff:ff:ff:ff:ff
    inet 172.12.0.1/24 brd 172.12.0.255 scope global docker0
    valid_lft forever preferred_lft forever
    3: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue state UNKNOWN group default
    link/ether ae:0b:69:19:39:16 brd ff:ff:ff:ff:ff:ff
    inet 10.244.1.0/32 brd 10.244.1.0 scope global flannel.1
    valid_lft forever preferred_lft forever
    24645: eth0@if24646: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default
    link/ether 02:42:0a:95:51:09 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.149.81.9/24 brd 10.149.81.255 scope global eth0
    valid_lft forever preferred_lft forever
    24647: eth1@if24648: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:11:00:52 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet 172.17.0.82/16 brd 172.17.255.255 scope global eth1
    valid_lft forever preferred_lft forever
    root@node01:~# ip -f inet addr show | grep 10.149.81.9
    inet 10.149.81.9/24 brd 10.149.81.255 scope global eth0
    root@node01:~# ip -f link addr show eth0
    24645: eth0@if24646: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default
    link/ether 02:42:0a:95:51:09 brd ff:ff:ff:ff:ff:ff link-netnsid 0

    

</details>

### 7) We use Docker as our container runtime. What is the interface/bridge created by Docker on this host?
<details>
  <summary markdown="span">Answer</summary>

    RECALL: Docker's bridge is always "docker0" on Host

</details>

### 8) What is the state of the interface docker0?
<details>
  <summary markdown="span">Answer</summary>

    ==> DOWN

    root@controlplane:~# ip link show docker0
    2: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default
    link/ether 02:42:4b:6c:fe:2b brd ff:ff:ff:ff:ff:ff
</details>

### 9) If you were to ping google from the master node, which route does it take?
What is the IP address of the Default Gateway?

<details>
  <summary markdown="span">Answer</summary>

    172.17.0.1 
    
    root@controlplane:~# ip route | grep via
    default via 172.17.0.1 dev eth1
    10.244.1.0/24 via 10.244.1.0 dev flannel.1 onlink

    root@controlplane:~# ip route
    default via 172.17.0.1 dev eth1
    10.149.81.0/24 dev eth0 proto kernel scope link src 10.149.81.6
    10.244.0.0/24 dev cni0 proto kernel scope link src 10.244.0.1
    10.244.1.0/24 via 10.244.1.0 dev flannel.1 onlink
    172.12.0.0/24 dev docker0 proto kernel scope link src 172.12.0.1 linkdown
    172.17.0.0/16 dev eth1 proto kernel scope link src 172.17.0.77
</details>

### 10) What is the port the kube-scheduler is listening on in the controlplane node?
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get pods/kube-scheduler-controlplane -n=kube-system -oyaml | grep port
                f:port: {}
                f:port: {}
        - --port=0
            port: 10259
            port: 10259

    root@controlplane:~# netstat -nplt
    Active Internet connections (only servers)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
    tcp        0      0 127.0.0.1:10259         0.0.0.0:*               LISTEN      3883/kube-scheduler
    tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      531/systemd-resolve
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      796/sshd            
    tcp        0      0 127.0.0.11:46497        0.0.0.0:*               LISTEN      -                   
    tcp        0      0 127.0.0.1:10248         0.0.0.0:*               LISTEN      4964/kubelet        
    tcp        0      0 127.0.0.1:10249         0.0.0.0:*               LISTEN      6126/kube-proxy     
    tcp        0      0 127.0.0.1:2379          0.0.0.0:*               LISTEN      3989/etcd           
    tcp        0      0 10.149.81.6:2379        0.0.0.0:*               LISTEN      3989/etcd           
    tcp        0      0 10.149.81.6:2380        0.0.0.0:*               LISTEN      3989/etcd           
    tcp        0      0 127.0.0.1:2381          0.0.0.0:*               LISTEN      3989/etcd           
    tcp        0      0 127.0.0.1:40719         0.0.0.0:*               LISTEN      4964/kubelet        
    tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      768/ttyd            
    tcp        0      0 127.0.0.1:10257         0.0.0.0:*               LISTEN      4016/kube-controlle
    tcp6       0      0 :::22                   :::*                    LISTEN      796/sshd            
    tcp6       0      0 :::8888                 :::*                    LISTEN      5116/kubectl        
    tcp6       0      0 :::10250                :::*                    LISTEN      4964/kubelet        
    tcp6       0      0 :::6443                 :::*                    LISTEN      4117/kube-apiserver
    tcp6       0      0 :::10256                :::*                    LISTEN      6126/kube-proxy

</details>

### 11) Notice that ETCD is listening on two ports. Which of these have more client connections established?
<details>
  <summary markdown="span">Answer</summary>

    ==> 2379

    root@controlplane:~# netstat -nplt | grep etcd
    tcp        0      0 127.0.0.1:2379          0.0.0.0:*               LISTEN      3989/etcd           
    tcp        0      0 10.149.81.6:2379        0.0.0.0:*               LISTEN      3989/etcd           
    tcp        0      0 10.149.81.6:2380        0.0.0.0:*               LISTEN      3989/etcd           
    tcp        0      0 127.0.0.1:2381          0.0.0.0:*               LISTEN      3989/etcd


    Correct! That's because 2379 is the port of ETCD to which all control plane components connect to. 
    2380 is only for etcd peer-to-peer connectivity. When you have multiple master nodes. In this case we don't.
</details>  

### 12) 
<details>
  <summary markdown="span">Answer</summary>

</details>

### 13)
<details>
  <summary markdown="span">Answer</summary>

</details>
