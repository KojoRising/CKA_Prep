# Troubleshooting | Kubernetes

### Overview
1) Application Failure
2) Control Plane Failure
3) Worker Node Failure


## 11.1 | Application Failure

### A) Check Services
    1) Curl Service
    2) Check Endpoints
    3) Check Service Selectors

### B) Check Pods
    1) k Describe
    2) k logs
    ==> PREVIOUS POd
    kubectl logs [POD] -f --previous

## 11.2 | Control Plane Failure
### A) Check Nodes
### B) Check Controlplane Pods
    ==> kd/klogs
### C) Check Controlplane Services
    ==> service [COMP] status
    COMP:
        1) kube-apiserver
        2) kube-controller-manager
        3) kube-scheduler
        4) kubelet
        5) kube-proxy
### D) Other Commands
    1) journalctl -xeu kube-apiserver
    2) journalctl -xeu kubelet



    
## 11.3 | Worker Node Failure

1) 
