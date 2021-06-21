# Core Concepts

## Cluster | High-Level Components

1) Master Node - Manages, Plans, Schedules, & Monitors Nodes

2) Worker Nodes - Host Applications as Containers

### Master Node | High-Level Components

1) API Server (kube-apiserver) -  

2) Cluster Store (etcd) - DB that stores info/configuration in Key-Value Store

3) Kube-Scheduler - 

4) Controller-Manager
    - Node-Controller
    - Replication-Controller


3) Kube-Proxy 


### Worker Node | High-Level Components

1) Kubelet - Communicates w/ API Server
    - Registers Worker Node w/ API Server
    - Listens for Instructions - From Kube-API Server 
        - Deploys/Destroys containers as per API Server's instructions
        - API-Server will periodically fetch status reports from Kubelet 
          for node status's

2) Kube-Proxy - Allows communication between worker nodes
    - Has rules that ensure worker nodes' containers can communicate with each other
    

## Etcd | In-Depth

### Definitions

Etcd - Is a distributed reliable key-value store that is simple, fast, & secure. 

K-V Store - As opposed to Tabular/Relational Databases,
- No Duplicates
- Only 2 Columns (K/V)


### Getting Started
- Runs on - Port 2379 (By default)
- You can then attach any clients to etcd service to store/retrieve info
- Default Client - "etcdctl" (Etcd Control Client)
    - Can use it - to store/retrieve k/v pairs
    - 


