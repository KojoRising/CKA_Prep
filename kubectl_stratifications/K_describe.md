# Kubectl Describe

## Overview
alias k=kubectl
alias kd='k describe'

## 1) Node

### Tells you the following: *"kd node"*
1) Schedulability
> grep Unschedulable
2) Taints:
> grep Taints
3) Internal IP
> grep InternalIP
4) Hostname
> grep Hostname
5) Kubelet Version
> grep Kubelet
6) Kube-Proxy Version
> grep Kube-Proxy
7) Pod Range
> grep PodCIDR
8) ALL PODS ON NODE
> grep Non-terminated Pods
9) ALLOCATED RESOURCES
> grep "Allocated resources"

### Miscellaneous Related Commands

1) What nodes a deployment is on?
> kd pods -l [DEP_LABEL] | grep Node:


## 2) Pods




## 3) Deployment


## 4) Service





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
