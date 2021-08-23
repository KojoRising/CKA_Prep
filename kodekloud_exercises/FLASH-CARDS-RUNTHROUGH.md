# COMMONLY MISSED

1) CNI Plugin Responsibilities 
2) Subnets for Pod/Node/Service - WHere to find them
3) DEFAULT IPs
    - Docker Bridge Network - 172.17.0.0
    - Weave Default
    - 


### 9.3 | Service Networking,k8s DNS,CoreDNS,Ingress


Where are subnets for the following configured: 
1) Pods - CNI-Plugin (Weave-Net)
    ==> RECALL: CNI is responsible for Pod IPAM
2) Services - API-Server // --service-cluster-ip-range
3) Nodes - NOT SURE


## Questions to Make
1) What is Kubelet responsible for? (CNI,CoreDNS, Kube-Proxy, etc. etc.)
2) Default Subnets =? 


GENERAL
1) Where can you find the CNI Plugin configured for a cluster? ==> In Kubelet

root@controlplane:~# ps -aux | grep network-plugin
root      4769  0.0  0.0 4002836 102804 ?      Ssl  19:48   0:21 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --network-plugin=cni --pod-infra-container-image=k8s.gcr.io/pause:3.2
root     11328  0.0  0.0  11468  1088 pts/0    R+   19:56   0:00 grep --color=auto network-plugin


2) Where can you find the Pod Subnet configured for a cluster? ==> CNI-Plugin (Weave Here)

#### WEAVE
root@controlplane:~# k get pod/weave-net-2hsxz -n=kube-system -ocustom-columns=:spec.containers[] | grep IPALLOC_RANGE

#### FLANNEL
root@controlplane:~# k get cm/kube-flannel-cfg -n=kube-system -ocustom-columns=:.data

<details>
  <summary markdown="span">Answer</summary>

    map[cni-conf.json:{
      "name": "cbr0",
      "cniVersion": "0.3.1",
      "plugins": [
        {
          "type": "flannel",
          "delegate": {
            "hairpinMode": true,
            "isDefaultGateway": true
          }
        },
        {
          "type": "portmap",
          "capabilities": {
            "portMappings": true
          }
        }
      ]
    }
     net-conf.json:{
      "Network": "10.244.0.0/16",
      "Backend": {
        "Type": "vxlan"
      }
    }
    ]
</details>


## Certificates

### Etcd
--cert-file=/etc/kubernetes/pki/etcd/server.crt
--trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt




