# General
COUNT="grep -vc NAME"
FIND="grep --color=always -e "^" -e"
N="-n=kube-system"
D="--dry-run=client -oyaml"
d="--dry-run=client -oyaml"
# Kubectl Basics
alias k=kubectl
complete -F __start_kubectl k
alias kg="k get"
alias kgp="kg pods"
alias kgd="kg deploy"
alias kgs="kg svc"
alias kgcm="kg cm"
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

# Kubectl Advanced
alias ktmp="k run $RANDOM --image=busybox:1.28 --rm -it --restart=Never -- /bin/sh"
alias kdns="k apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml"
ker() { k explain $1 --recursive=true | grep '<' | sed 's/<.*//'; }

# Kubeadm Related
alias km=kubeadm
complete -F __start_kubeadm km
alias kdrain="k drain --ignore-daemonsets --force"
kubens() { if [ -n "$1" ]; then k config set-context --current --namespace=$1 && kubens; else k config view --minify | grep namespace | sed "s/namespace://" | xargs; fi; }
alias kgCp="kg pods -n=kube-system | grep -v NAME"
alias kgCpF="kg pods -n=kube-system | grep -v 'Running\|NAME'"
alias kgCpG="kg pods -n=kube-system | grep 'Running'"
alias kmKubeProxy="kubeadm config print init-defaults --component-configs KubeProxyConfiguration"
alias kmKubelet="kubeadm config print init-defaults --component-configs KubeletConfiguration"
alias checkCP="echo $(kg pods -n=kube-system | grep -c Running)/$(kg pods -n=kube-system | grep -vc NAME) && kgCpF"

# IP Specific
alias ipg="ip -f inet addr | grep inet"
alias ipgN="ipg | grep eth0"
alias ipgP="ipg | grep -e 'weave\|cni'"
alias ipgS="cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep ip-range"
# Kube-Proxy
alias kube-proxy-mode="kl ds/$(kg ds $N -l k8s-app=kube-proxy -ocustom-columns=:.metadata.name | xargs) $N | grep Using"
# Miscellaneous
alias e="ETCDCTL_API=3 etcdctl"
alias SWAPOFF="sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab"
sedGrep() { grep $1 | sed "s;$1;;" | xargs; }

