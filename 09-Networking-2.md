# Networking | Kubernetes

## Overview
1) Cluster Networking 
2) Pod Networking
3) CNI in Kubernetes
4) CNI Weave
5) IP Address Management

## 1 | Cluster Networking

General Facts:
1) Each Node - Must have an Interface connected to a Network
2) Each Interface - Must have an IP Address Configured for it
3) Each Host (Usually only 1) - Must have Unique HOST-NAME + Unique MAC Address

#### K8s Ports General
| Component| Port
| ---- | ----------- |
| API-Server | 6443 |
| ETCD | 2379 |
| ETCD2 (Multi-Master) | 2380 |
| Kubelet (W+M) | 10250 |
| Scheduler | 10251 |
| Controller-Manager | 10252 |

#### Helpful Commands for Practice Test
![img_7.png](assets/9_networking_cluster_helpful_commands.png)


## 2 | Pod Networking

![img_8.png](assets/9_pod_networking_model.png)
Regarding Pod communication outside current Node, we shouldn't have to care about:
- What IP it is
- What range/subnet it belongs to
- etc.

![img_9.png](assets/9_pod_networking_model_example.png)

### Example Scenario
SETUP: We have a 3-Node Setup on {192.168.1.11,192.168.1.12,192.168.1.13}

### Example | 1. Pod2Pod Communication Per Node
1)  ***Creates Network Namespaces*** - K8s does this on Container Creation
2) ***Create/Setup Bridge Network*** per node: 
- a. Create Bridge per Node: 
> // PER BRIDGE \
> ip link add v-net-0 type bridge \
ip link set dev v-net-0 up

- b. Create IP for each Bridge - Each Node's Bridge should be on its ***own private subnet***
- c. Assign Bridge-IP to Interface

> ip addr add 10.244.1.1/24 dev v-net-0 \
ip addr add 10.244.2.1/24 dev v-net-0 \
ip addr add 10.244.3.1/24 dev v-net-0

3) ***Attach Namespaces to Bridge Network*** - (To DELETE)

4) Now in Each Node, we create a SCRIPT that does the following ***Per-Container!!!***:
- a. Create a Pipe: 
- b. Attach Interfaces - To Container+Bridge: 
- c. Assign IP Addresses to Interfaces: 
- d. Assign Default Routes to Interfaces: 
- e. Bring Up Interface

#### If we have 3 Nodes w/ 2 Containers each, we will run above steps *Six Times!!!*

### Example | 2. Pod2Pod Communication ACROSS Nodes

#### MANUAL WAY
Say the following:
- PodA on Node1 wants to talk to PodC on Node2
- PodA pings PodC
    - Fails bcz it doesn't know about it
    - So the Ping gets Routed to its default route, ***Node1's IP***
    - We need to add a Route to the Node
  
#### Per Node Steps: Given Node1: {PodA,PodB}, Node2: {PodC,PodD}, Node3: {PodE,PodF}
    for node in nodes:
      for other_node in other_nodes:
        for pod in other_node_pods: 
          node ip route add podIP via other-nodeIP

![img_10.png](assets/9_pod_networking_inter_node_complex.png)


#### AUTOMATIC WAY
Use a router to map each network's IP to a Gateway
![img_11.png](assets/9_pod_networking_inter_node_router.png)

#### BREAKDOWN^^ 
Node IPs - { 192.168.1.11, 192.168.1.12. 192.168.1.13 }
Bridge IPs - { 10.244.1.1, 10.244.2.1, 10.244.3.1 }
Bridge Interfaces - { 10.244.1.0/24, 10.244.2.0/24, 10.244.3.0/24 }



### CNI
Tells us how to structure the Script.

#### W/Out CNI
![img_12.png](assets/9_pod_networking_without_cni.png)

#### With CNI
![img_12.png](assets/9_pod_networking_with_cni.png)

### Kubelet
**Recall** - Kubelet per Node is responsible for creating/deleting pods & containers

    // These are passed as args to the Kubelet (On Setup)
    --cni-conf-dir=/etc/cni/net.d
    --cni-bin-dir=/etc/cni/bin
    // Executed in the BIN directory like this:
    ./net-script.sh add [CONT] [NS]


## 3 | CNI in Kubernetes

Where do we specify the CNI Plugins for k8s?


![img_5.png](assets/9_cni_kubelet_config.png)

![img_5.png](assets/9_cni_directories.png)


![img_6.png](assets/9_cni_config.png)

isGateway - Defines whether Bridge Network should have an IP assigned to it (so it can act as a gateway)

ipMasq - Defines whether NAT rules should be added for IP masquerading

subnet - Range of IP addresses that will be assigned to Pods && any necessary routes


## 4 | Weave CNI
What's wrong w/ the Routing Table we had? 
=> It may not work for hundreds of nodes in a cluster
==> Routing Table may not support that many entries

#### WeaveWorks General:
  - Deploys Agent to each Node in the Cluster
  - Each Agent knows about each other/can discover each other
  - Each Agent intercepts each call and delivers it to each Agent on the appropriate Node

#### WeaveWorks Specific:
- *Agent/Peer* - Stores a topology of the entire Cluster
- Weave Creates - Bridge called ***Weave*** on each Node
- Assigns IP Address - To Each Node

NOTE:
- Single Pod - Can be attached to multiple bridge networks
  - Ex. Pod can be attached to ***Weave Bridge*** as well as ***Docker Network*** Bridge 

WALKTHROUGH:
1) Packet is sent from PodA - To PodB (on a different node)
2) SENDING - AgentA Intercepts Packet && Encapsulates it with new {SRC,DST}
3) RECEIVING - AgentB Receives Packet && Decapsulates it 


#### Deploying Weave
Weave/Weave-Peers - Can be deployed as:
1) *services*, or ***daemons*** - On each node in the cluster
2) Or if K8s is setup already - As ***Pods*** in the cluster
==> W/ single kubectl apply -f ""
   
Weave-Peers - Deployed as a Daemonset on each Node in the Cluster

![img_7.png](assets/9_weave_daemonset.png)



## 5 | IP Address Management (IPAM) in CNI

NOTE - This does not concern IP addresses assigned *to the nodes*

What this section covers: 
  - How are virtual bridge networks in the nodes assigned an IP Subnet?
  - How are the Pods Assigned an IP?
  - Where is information stored
  - Who ensures there are no duplicates?


#### How can we assign non-duplicate IPs?
1) Use ***host-local*** IPAM Plugin - For assigning free IPs to Pods
2) Still our responsibility - To ***invoke*** that plugin
  - Manual - We have to invoke it
  - Dynamic - Specify in CNI config => ***/etc/cni/net.d/net-script.conf***

![img_8.png](assets/9_ipam_host-local.png)

#### Weave - Default IP Address Management
  - Allocates (10.32.0.0/12)
  - Gives (10.32.0.1 > 10.47.255.254) // ~1mil Pod IPs
  - Weave-Peers split IP's equally amongst the nodes

## 6 | Service Networking

Recall - A Service is accessible from all Pods on the Cluster, irrespective of what Node it is on.

ClusterIP Service - Accessible:
  - Intra-Cluster (Unlike Pods)
  - **NOT** Inter-Cluster

NodePort Service - Accessible:
- Intra-Cluster (Unlike Pods)
- Inter-Cluster

Services vs. Pods
1) Pods - Have Containers w/ Namespaces, Interfaces, & IPs
2) Pods - Have NO Namespaces, Interfaces, IP's, etc.
####==> So how do they get IP address?

### Kube-Proxy 
1) Creates Forwarding Rules per Node
2) These Rules - Forward Traffic intended for the SVC to the Pods 

#### Kube-Proxy | Rule-Creation Types
1) User-Space 
2) ipvs
3) iptables (DEFAULT)

![img_9.png](assets/9_kube_proxy_rule_creation_types.png)


#### Where is the ClusterIP svc's subnet defined?
==> *kube-api-server --service-cluster-ip-range ipNet
  - Default - 10.0.0.0.0/24

![img_10.png](assets/9_kube_proxy_defining_service_subnet.png)

MAKE SURE THESE IP RANGES DON'T OVERLAP
Service IPs: 10.96.0.0/12 => {10.96.0.0, 10.111.255.255}
POD IPs: 10.244.0.0/16 => {10.244.0.0, 10.244.255.255}


#### Kube-Proxy Commands
1) iptables -L -t nat | grep db-service
2) ps aux | grep kube-api-server 


![img_11.png](assets/9_kube-proxy_debugging.png)


## 7 | DNS in Kubernetes

By Default - Kubernetes creates

