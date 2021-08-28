# Planning

## 7 | Practice Tests
1) View Certificates
2) Certificates API
3) KubeConfig
4) RBAC
5) Cluster Roles/Role Bindings
6) Service Accounts
7) Image Security
8) Security Contexts
9) Network Policies


## 8 | Practice Tests
1) PV/PVCs
2) Storage-Class


## 9) | Networking
1) Explore K8s Environment
2) Explore CNI Weave
3) Deploy Network Solution
4) Networking Weave
5) Service Networking
6) Explore DNS
7) Ingress
8) Ingress-2
9)
10) 


# CKA Aliases

## Miscellaneous
alias OBJ_COUNT="grep -vc NAME"
alias CC="-ocustom-columns=NAME:.metadata.name"


## OpenSSL
alias CRT_TR="openssl x509 -noout -text -in"
alias CSR_TR="openssl req -noout -text -in"
alias CRT_GREP="grep --regexp='--'"

## Context Specific
alias k=kubectl
alias kubens="k config set-context --current --namespace"
alias kubectx='k config use-context'
k_explain() { k explain $1 --recursive=true | grep "<" }
==> Just Type in as-is into a command line

## Other Stuff
alias k_delete="k delete --force --grace-period=0 po"
alias k_tmp='kubectl run --restart=Never --rm -it --image=busybox temp -- /bin/sh -c

O="--dry-run=client -oyaml"
I="--image"
R="--restart=Never"
alias k_get="k get --show-labels"
