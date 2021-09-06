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
alias ipgNode="ipg | grep eth0"
alias ipgPod="ipg | grep weave"
# Miscellaneous
alias e="ETCDCTL_API=3 etcdctl"
alias km=kubeadm
