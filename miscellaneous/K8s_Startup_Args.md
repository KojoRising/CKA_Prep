




### Accessing API Server
CURL
            
    --key admin.key --cert admin.crt --cacert ca.crt

Kubectl

    --client-key admin.key --client-certificate admin.crt --certificate-authority ca.crt


### Kube-Controller Manager | CSR-Approver/CSR-Signer
--cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt \
--cluster-signing-key-file=/etc/kubernetes/pki/ca.key


