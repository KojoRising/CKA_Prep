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
alias kr="k replace -f"
alias kc='k create'
alias kcf="k create -f"
alias kcd='k create $D'
alias ke="k explain"
alias ktmp="k run $RANDOM --image=busybox:1.28 --rm -it --restart=Never -- /bin/sh"
alias kdns="k apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml"
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
alias SWAPOFF="sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab"
