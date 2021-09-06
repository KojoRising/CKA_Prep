COUNT="grep -vc NAME"
FIND="grep --color=always -e "^" -e"
D="--dry-run=client -oyaml"
d="--dry-run=client -oyaml"
N="-n=kube-system"
alias e="ETCDCTL_API=3 etcdctl"
alias km=kubeadm
alias k=kubectl
alias kg="k get"
alias kd="k describe"
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
