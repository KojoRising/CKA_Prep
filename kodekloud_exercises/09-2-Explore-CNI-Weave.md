## Questions

### 1) Inspect the kubelet service and identify the network plugin configured for Kubernetes.
<details> 
  <summary markdown="span">Answer</summary> 

        cni

        controlplane:~# ps -aux | grep kubelet | grep network-plugin
        root      4812  0.0  0.0 3854604 103552 ?      Ssl  18:20   0:20 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf 
        --config=/var/lib/kubelet/config.yaml --network-plugin=cni --pod-infra-container-image=k8s.gcr.io/pause:3.2
</details>

### 2) What is the path configured with all binaries of CNI supported plugins?
<details>
  <summary markdown="span">Answer</summary>

    RECALL:
    --cni-bin-dir=/opt/cin/bin

</details>

### 3) Identify which of the below plugins is not available in the list of available CNI plugins on this host?
a) cisco
b) dhcp
c) vlan
d) bridge
<details>
  <summary markdown="span">Answer</summary>
    
    ==> cisco 

    root@controlplane:~# ls /opt/cni/bin
    bandwidth  dhcp      flannel      host-local  loopback  portmap  sbr     tuning
    bridge     firewall  host-device  ipvlan      macvlan   ptp      static  vlan
</details>

### 4) What is the CNI plugin configured to be used on this kubernetes cluster?
<details>
  <summary markdown="span">Answer</summary>

    ==> Flannel

    root@controlplane:~# ls /etc/cni/net.d
    10-flannel.conflist
    root@controlplane:~# cat /etc/cni/net.d/10-flannel.conflist
    {
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

</details>

### 5) What binary executable file will be run by kubelet after a container and its associated namespace are created. 
<details>
  <summary markdown="span">Answer</summary>

    From Above:
    => Flannel
</details>
