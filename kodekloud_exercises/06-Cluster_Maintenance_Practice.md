## Questions


### 3) How many nodes can host workloads in this cluster?
- Check the Taints on all Nodes

<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k describe nodes -A | grep Taints
    Taints:             <none>
    Taints:             <none>

    --> 2 Nodes
</details>


### 4) How many applications are hosted on the cluster?
- Count the number of deployments
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get deploy -A
    NAMESPACE     NAME      READY   UP-TO-DATE   AVAILABLE   AGE
    default       blue      5/5     5            5           17m
    kube-system   coredns   2/2     2            2           42m

    --> 1 (coredns doesn't count)
</details>

### 5) What nodes are the pods hosted on?
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k describe po -l app=blue | grep Node:
    Node:         controlplane/10.27.212.3
    Node:         node01/10.27.212.6
    Node:         controlplane/10.27.212.3
    Node:         node01/10.27.212.6
    Node:         node01/10.27.212.6

    root@controlplane:~# k get pods -o custom-columns=POD:.metadata.name,NODE:.spec.nodeName
    POD                     NODE
    blue-746c87566d-62s9b   controlplane
    blue-746c87566d-f2hml   node01
    blue-746c87566d-fpbsm   controlplane
    blue-746c87566d-m2wbl   node01
    blue-746c87566d-tjsrd   node01
    simple-webapp-1         node01

    --> node01, controlplane
</details>


### 6) You are tasked to upgrade the cluster. User's accessing the applications must not be impacted. And you cannot provision new VMs. What strategy would you use to upgrade the cluster?

#### Options:
1) Users will be impacted since there is only one worker node
2) Add new nodes with newer versions while taking down existing nodes
3) Upgrade all nodes at once
4) Upgrade one node at a time while moving the workloads to the other


<details>
  <summary markdown="span">Answer</summary>

    --> 4 
</details>

### 7) What is the latest stable version available for upgrade? Use the kubeadm tool

#### Options:
1) v1.13.0
2) v1.12.1
3) v1.19.12
4) v1.10.0

<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# kubeadm upgrade plan
    [upgrade/config] Making sure the configuration is correct:
    [upgrade/config] Reading configuration from the cluster...
    [upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
    [preflight] Running pre-flight checks.
    [upgrade] Running cluster health checks
    [upgrade] Fetching available versions to upgrade to
    [upgrade/versions] Cluster version: v1.19.0
    [upgrade/versions] kubeadm version: v1.19.0
    I0711 20:15:43.875618   35378 version.go:252] remote version is much newer: v1.21.2; falling back to: stable-1.19
    [upgrade/versions] Latest stable version: v1.19.12
    [upgrade/versions] Latest stable version: v1.19.12
    [upgrade/versions] Latest version in the v1.19 series: v1.19.12
    [upgrade/versions] Latest version in the v1.19 series: v1.19.12

    Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
    COMPONENT   CURRENT       AVAILABLE
    kubelet     2 x v1.19.0   v1.19.12
    
    Upgrade to the latest version in the v1.19 series:
    
    COMPONENT                 CURRENT   AVAILABLE
    kube-apiserver            v1.19.0   v1.19.12
    kube-controller-manager   v1.19.0   v1.19.12
    kube-scheduler            v1.19.0   v1.19.12
    kube-proxy                v1.19.0   v1.19.12
    CoreDNS                   1.7.0     1.7.0
    etcd                      3.4.9-1   3.4.9-1
    
    You can now apply the upgrade by executing the following command:
    
            kubeadm upgrade apply v1.19.12
    
    Note: Before you can perform this upgrade, you have to update kubeadm to v1.19.12.
    
    _____________________________________________________________________
    
    
    The table below shows the current state of component configs as understood by this version of kubeadm.
    Configs that have a "yes" mark in the "MANUAL UPGRADE REQUIRED" column require manual config upgrade or
    resetting to kubeadm defaults before a successful upgrade can be performed. The version to manually
    upgrade to is denoted in the "PREFERRED VERSION" column.
    
    API GROUP                 CURRENT VERSION   PREFERRED VERSION   MANUAL UPGRADE REQUIRED
    kubeproxy.config.k8s.io   v1alpha1          v1alpha1            no
    kubelet.config.k8s.io     v1beta1           v1beta1             no
    _____________________________________________________________________
    
    
    -->  3) v1.19.12
</details>



8) We will be upgrading the master node first. Drain the master node of workloads and mark it UnSchedulable


<details>
  <summary markdown="span">Answer</summary>
        
    ### 1) CHECK SCHEDULABILITY
    root@controlplane:~# k describe node/controlplane | grep -i Unschedulable:
    Unschedulable:      false

    ### 2) NOTE | EVEN SYSTEM DAEMONSETS AFFECT IT
    root@controlplane:~# k drain node/controlplane
    node/controlplane cordoned
    error: unable to drain node "controlplane", aborting command...
    
    There are pending nodes to be drained:
    controlplane
    error: cannot delete DaemonSet-managed Pods (use --ignore-daemonsets to ignore): kube-system/kube-flannel-ds-8rflm, kube-system/kube-proxy-tpcrr
        
    ### 3) DRAIN NODE
    root@controlplane:~# k drain node/controlplane --ignore-daemonsets
    node/controlplane cordoned
    WARNING: ignoring DaemonSet-managed Pods: kube-system/kube-flannel-ds-8rflm, kube-system/kube-proxy-tpcrr
    evicting pod default/blue-746c87566d-fpbsm
    evicting pod default/blue-746c87566d-62s9b
    evicting pod kube-system/coredns-f9fd979d6-tpp7d
    evicting pod kube-system/coredns-f9fd979d6-zc9fq
    pod/blue-746c87566d-62s9b evicted
    pod/blue-746c87566d-fpbsm evicted
    pod/coredns-f9fd979d6-tpp7d evicted
    pod/coredns-f9fd979d6-zc9fq evicted
    node/controlplane evicted

    ### 4) CHECK SCHEDULABILITY
    root@controlplane:~# k describe node/controlplane | grep -i Unschedulable:
    Taints:             node.kubernetes.io/unschedulable:NoSchedule
    Unschedulable:      true

    
</details>


### 9. Upgrade the controlplane components to exact version v1.20.0
Upgrade kubeadm tool (if not already), then the master components, and finally the kubelet. Practice referring to the kubernetes documentation page. Note: While upgrading kubelet, if you hit dependency issue while running the apt-get upgrade kubelet command, use the apt install kubelet=1.20.0-00 command instead

<details>
  <summary markdown="span">Answer</summary>
    
    ### NOTE: kubeadm CANNOT be << controlplane target versions
    root@controlplane:~# kubeadm upgrade apply v1.19.12
    [upgrade/config] Making sure the configuration is correct:
    [upgrade/config] Reading configuration from the cluster...
    [upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
    [preflight] Running pre-flight checks.
    [upgrade] Running cluster health checks
    [upgrade/version] You have chosen to change the cluster version to "v1.19.12"
    [upgrade/versions] Cluster version: v1.19.0
    [upgrade/versions] kubeadm version: v1.19.0
    [upgrade/version] FATAL: the --version argument is invalid due to these errors:

        - Specified version to upgrade to "v1.19.12" is higher than the kubeadm version "v1.19.0". Upgrade kubeadm first using the tool you used to install kubeadm

    ### 0) UPDATE | PACKAGE LIST
    root@controlplane:~# apt update    
    Get:2 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]                                                 
    Get:3 https://download.docker.com/linux/ubuntu bionic InRelease [64.4 kB]                                                   
    Get:4 http://archive.ubuntu.com/ubuntu bionic InRelease [242 kB]
    ... 

    ### 1) CHECK LATEST | KUBEADM
    root@controlplane:~# apt list -a kubeadm
    Listing... Done
    kubeadm/kubernetes-xenial 1.21.2-00 amd64 [upgradable from: 1.19.0-00]
    kubeadm/kubernetes-xenial 1.21.1-00 amd64
    kubeadm/kubernetes-xenial 1.21.0-00 amd64
    kubeadm/kubernetes-xenial 1.20.8-00 amd64
    kubeadm/kubernetes-xenial 1.20.7-00 amd64
    kubeadm/kubernetes-xenial 1.20.6-00 amd64
    ....

    ### 2) INSTALL LATEST | KUBEADM
    root@controlplane:~# apt-get install -y --allow-change-held-packages kubeadm=1.20.8-00
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    The following held packages will be changed:
    kubeadm
    The following packages will be upgraded:
    kubeadm
    1 upgraded, 0 newly installed, 0 to remove and 64 not upgraded.
    Need to get 7706 kB of archives.
    After this operation, 111 kB of additional disk space will be used.
    Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.20.8-00 [7706 kB]
    Fetched 7706 kB in 1s (5509 kB/s)  
    debconf: delaying package configuration, since apt-utils is not installed
    (Reading database ... 15143 files and directories currently installed.)
    Preparing to unpack .../kubeadm_1.20.8-00_amd64.deb ...
    Unpacking kubeadm (1.20.8-00) over (1.19.0-00) ...
    Setting up kubeadm (1.20.8-00) ...

    ### 3) DRAIN | MASTER
    controlplane:~# k drain controlplane --ignore-daemonsets
    node/controlplane already cordoned
    WARNING: ignoring DaemonSet-managed Pods: kube-system/kube-flannel-ds-l9cxq, kube-system/kube-proxy-2fz99
    evicting pod default/blue-746c87566d-nlc7m
    evicting pod kube-system/coredns-f9fd979d6-mffhn
    evicting pod default/blue-746c87566d-lk6h9
    evicting pod kube-system/coredns-f9fd979d6-rfr7x
    pod/blue-746c87566d-nlc7m evicted
    pod/blue-746c87566d-lk6h9 evicted
    pod/coredns-f9fd979d6-rfr7x evicted
    pod/coredns-f9fd979d6-mffhn evicted
    node/controlplane evicted

    ### 4) UPGRADE PLAN | KUBEADM
    kubeadm upgrade plan
    ...

    ### 5) UPGRADE APPLY | KUBEADM
    root@controlplane:~# kubeadm upgrade apply v1.20.8
    [upgrade/config] Making sure the configuration is correct:
    [upgrade/config] Reading configuration from the cluster...
    [upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
    [preflight] Running pre-flight checks.
    [upgrade] Running cluster health checks
    [upgrade/version] You have chosen to change the cluster version to "v1.20.8"
    [upgrade/versions] Cluster version: v1.19.12
    [upgrade/versions] kubeadm version: v1.20.8
    [upgrade/confirm] Are you sure you want to proceed with the upgrade? [y/N]: y
    [upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
    [upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
    [upgrade/prepull] You can also perform this action in beforehand using 'kubeadm config images pull'
    [upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.20.8"...
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-controller-manager-controlplane hash: a72e9b624088d0ef465fbe17425c27f5
    Static pod: kube-scheduler-controlplane hash: 85134a6c973cfd9426443269d0340d98
    [upgrade/etcd] Upgrading to TLS for etcd
    Static pod: etcd-controlplane hash: f8e828ac86a2c125ee97b3f1caefc38f
    [upgrade/staticpods] Preparing for "etcd" upgrade
    [upgrade/staticpods] Renewing etcd-server certificate
    [upgrade/staticpods] Renewing etcd-peer certificate
    [upgrade/staticpods] Renewing etcd-healthcheck-client certificate
    [upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/etcd.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-07-12-21-40-37/etcd.yaml"
    [upgrade/staticpods] Waiting for the kubelet to restart the component
    [upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
    Static pod: etcd-controlplane hash: f8e828ac86a2c125ee97b3f1caefc38f
    Static pod: etcd-controlplane hash: 73121b7256f3170e88ab01127e4c35bb
    [apiclient] Found 1 Pods for label selector component=etcd
    [upgrade/staticpods] Component "etcd" upgraded successfully!
    [upgrade/etcd] Waiting for etcd to become available
    [upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests412723165"
    [upgrade/staticpods] Preparing for "kube-apiserver" upgrade
    [upgrade/staticpods] Renewing apiserver certificate
    [upgrade/staticpods] Renewing apiserver-kubelet-client certificate
    [upgrade/staticpods] Renewing front-proxy-client certificate
    [upgrade/staticpods] Renewing apiserver-etcd-client certificate
    [upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-apiserver.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-07-12-21-40-37/kube-apiserver.yaml"
    [upgrade/staticpods] Waiting for the kubelet to restart the component
    [upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: 6bd8029271f160a3fd0b36f610a467b3
    Static pod: kube-apiserver-controlplane hash: f16ab47f172030b3b29152734d98ebcc
    [apiclient] Found 1 Pods for label selector component=kube-apiserver
    [upgrade/staticpods] Component "kube-apiserver" upgraded successfully!
    [upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
    [upgrade/staticpods] Renewing controller-manager.conf certificate
    [upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-controller-manager.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-07-12-21-40-37/kube-controller-manager.yaml"
    [upgrade/staticpods] Waiting for the kubelet to restart the component
    [upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
    Static pod: kube-controller-manager-controlplane hash: a72e9b624088d0ef465fbe17425c27f5
    Static pod: kube-controller-manager-controlplane hash: 1a53e9d61532fdd8379be949ec7e4b05
    [apiclient] Found 1 Pods for label selector component=kube-controller-manager
    [upgrade/staticpods] Component "kube-controller-manager" upgraded successfully!
    [upgrade/staticpods] Preparing for "kube-scheduler" upgrade
    [upgrade/staticpods] Renewing scheduler.conf certificate
    [upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-scheduler.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-07-12-21-40-37/kube-scheduler.yaml"
    [upgrade/staticpods] Waiting for the kubelet to restart the component
    [upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
    Static pod: kube-scheduler-controlplane hash: 85134a6c973cfd9426443269d0340d98
    Static pod: kube-scheduler-controlplane hash: f3a9fe44705c3a07d53a737c4ab8f16b
    [apiclient] Found 1 Pods for label selector component=kube-scheduler
    [upgrade/staticpods] Component "kube-scheduler" upgraded successfully!
    [upgrade/postupgrade] Applying label node-role.kubernetes.io/control-plane='' to Nodes with label node-role.kubernetes.io/master='' (deprecated)
    [upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
    [kubelet] Creating a ConfigMap "kubelet-config-1.20" in namespace kube-system with the configuration for the kubelets in the cluster
    [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
    [bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
    [bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
    [bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
    [bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
    [addons] Applied essential addon: CoreDNS
    [addons] Applied essential addon: kube-proxy
    
    [upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.20.8". Enjoy!
    
    [upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.
                        
    ### 5) APT-GET INSTALL | KUBELET
    root@controlplane:~# apt-get install -y --allow-change-held-packages kubelet=1.20.0-00
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done

    ### 6) RESTART | KUBELET
    systemctl restart kubelet


    ### 
</details>

https://v1-20.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/



11) We will be upgrading the master node first. Drain the master node of workloads and mark it UnSchedulable
    
12) Upgrade the worker node to the exact version v1.20.0

<details>
  <summary markdown="span">Answer</summary>

    ### 1) DRAIN | WORKERR 
    k drain node01 --force --ignore-daemonsets

    ### 2) SSH | WORKER
    ssh node01

    ### 3) UPDATE | PACKAGES
    apt update

    ### 4) UPGRADE | KUBEADM
    apt install kubeadm=1.20.0-00

    ### 5) UPGRADE | WORKER NODE
    kubeadm upgrade node

    ### 6) UPDATE | KUBELET
    apt install kubelet=1.20.0-00 

    ### 7) RESTART | KUBELET
    systemctl restart kubelet

</details>
