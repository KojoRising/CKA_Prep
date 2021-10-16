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


## curl https://raw.githubusercontent.com/Kojorising/CKA_Prep/main/alias.sh > alias.sh && source alias.sh
## Copy & Paste
<details> 
  <summary markdown="span">Answer</summary>
# General
COUNT="grep -vc NAME"
FIND="grep --color=always -e "^" -e"
N="-n=kube-system"
D="--dry-run=client -oyaml"
d="--dry-run=client -oyaml"
# Kubectl
alias k=kubectl
alias kg="k get"
alias kd="k describe"
alias kdel="k del"
alias kdelf="k delete --force pod" 
alias kl="k logs"
alias kla="k label"
alias kx='k exec -it'
alias kc='k create'
alias kcf="k create -f"
alias kcd='k create $D'
alias ke="k explain"
alias ktmp="k run $RANDOM --image=busybox --rm -it --restart=Never -- /bin/sh"
alias kdrain="k drain --ignore-daemonsets --force"
ker() { k explain $1 --recursive=true | grep '<' | sed 's/<.*//'; }
complete -F __start_kubectl k
# IP Specific
alias ipg="ip -f inet addr | grep inet"
alias ipgN="ipg | grep eth0"
alias ipgP="ipg | grep weave"
alias ipgS="cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep ip-range"
# Kube-Proxy
alias kube-proxy-mode="kl ds/$(kg ds $N -l k8s-app=kube-proxy -ocustom-columns=:.metadata.name | xargs) $N | grep Using"
# Miscellaneous
alias e="ETCDCTL_API=3 etcdctl"
alias km=kubeadm

</details>

## Miscellaneous
COUNT="grep -vc NAME"
FIND="grep --color=always -e "^" -e"
> kg pods | FIND blue

alias CC="-ocustom-columns=NAME:.metadata.name"

## OpenSSL
alias CRT_TR="openssl x509 -noout -text -in"
alias CSR_TR="openssl req -noout -text -in"
alias CRT_GREP="grep --regexp='--'"

## Context Specific
alias k=kubectl
alias kubens="k config set-context --current --namespace"
alias kubectx='k config use-context'


## Other Stuff
alias k_delete="k delete --force --grace-period=0 po"
alias k_tmp='kubectl run --restart=Never --rm -it --image=busybox temp -- /bin/sh -c

O="--dry-run=client -oyaml"
I="--image"
R="--restart=Never"
alias k_get="k get --show-labels"

#### 1) Custom-Columns | Get All
>  k get clusterrolebinding -ocustom-columns=:.subjects[*].name











