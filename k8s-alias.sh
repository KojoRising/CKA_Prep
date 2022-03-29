d="--dry-run=client -oyaml"
alias k=kubectl
complete -F __start_kubectl k
alias kc='k create'
alias kcf="k create -f"
alias kd="k describe"
alias kg="k get"
alias kdel="k delete"
alias ke="k explain"
alias kx='k exec -it'
alias kr="k run"
alias kcurr="k config get-contexts | grep -e 'NAME\|\*'"
kubens() { if [ -n "$1" ]; then k config set-context --current --namespace=$1 && kubens; else k config get-contexts | grep -e 'NAME\|\*'; }
