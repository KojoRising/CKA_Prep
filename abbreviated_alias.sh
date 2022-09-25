# curl https://raw.githubusercontent.com/KojoRising/CKA_Prep/main/abbreviated_alias.sh > alias.sh && source alias.sh
COUNT="grep -vc NAME"
N="-n=kube-system"
d="--dry-run=client -oyaml"
D="--dry-run=client -oyaml"
DRY="--dry-run=client -oyaml"
CC="-ocustom-columns"
JP="-ojsonpath"
alias kst=kustomize
alias k=kubectl
alias d=docker
alias g=git
alias p=podman
complete -F __start_kubectl k
alias kg="k get"
alias ka="k apply -f"
alias kd="k describe"
alias kdl="k delete"
alias kdel="k delete"
alias kdelf="k delete --force pod" 
alias kx='k exec -it'
alias kr="k run"
alias krf="k replace -f"
alias kc='k create'
alias kcf="k create -f"
alias kcd='k create $d'
alias kdNodes="kd nodes | grep 'Name:\|Taints:\|Unschedulable:\|InternalIP:'"
alias ke="k explain"
alias km=kubeadm
complete -F __start_kubeadm km
alias kdrain="k drain --ignore-daemonsets --force"
alias kcurr="k config get-contexts | grep -e 'NAME\|\*'"
kubens() { if [ -n "$1" ]; then k config set-context --current --namespace=$1 && kubens; else k config view --minify | grep namespace | sed "s/namespace://" | xargs; fi; }
kcds() { k create deploy $@ $d | sed "s;Deployment;DaemonSet;" | grep -v "strategy\|status\|replicas"; }
ker() { k explain $1 --recursive=true | grep '<' | sed 's/<.*//'; }
# Miscellaneous
alias e="ETCDCTL_API=3 etcdctl"
alias es="ETCDCTL_API=3 etcdctl --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key --cacert=/etc/kubernetes/pki/etcd/ca.crt"
alias SWAPOFF="sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fst"
