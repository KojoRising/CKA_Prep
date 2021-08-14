# CKA Aliases


## Miscellaneous
alias OBJ_COUNT="grep -vc NAME"

## OpenSSL
alias CRT_TR="openssl x509 -noout -text -in"
alias CSR_TR="openssl req -noout -text -in"
alias CRT_GREP="grep --regexp='--'"



## Context Specific
alias kubens="k config set-context --current --namespace"
alias kubectx='k config use-context'
alias k_get_ns="k config view --minify | grep namespace"



## Other Stuff
alias k_delete="k delete --force --grace-period=0 po"
alias k_tmp='kubectl run --restart=Never --rm -it --image=busybox temp -- /bin/sh -c

O="--dry-run=client -oyaml"
I="--image"
R="--restart=Never"
alias k_get="k get --show-labels"
