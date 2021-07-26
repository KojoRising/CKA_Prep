1) with kubelet-client.[crt/key], apiserver-kubelet-client.[crt/key], what are the main interactions?

(Meaning for API Server to talk to Kubelet, seems like 
- API Server uses its... 
    1) ***apiserver-kubelet-client.[crt/key]*** to authenticate to....
    2) kubelet's ***kubelet.[crt/key]
    
- But for kubelet
