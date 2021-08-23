# Install Kubernetes the "kubeadm" way

## Pre-requisites


### Steps
1) Create your Nodes - 1M, 2W
2) Install **ContainerRuntime** - *docker* for us
3) Install **Kubeadm**
4) Pod Network - Networking Between Worker/Master Nodes
5) Join Nodes



### 1) Vagrant Commands
0) Check vagrant status
   
        jkulkarn@SFOLA5JMMD6T certified-kubernetes-administrator-course % vagrant status        
        Current machine states:
        
        kubemaster                running (virtualbox)
        kubenode01                running (virtualbox)
        kubenode02                running (virtualbox)

1) Start the VM's (if not running) 
> vagrant up
2) Vagrant SSH
> vagrant ssh [NODE]

### 2) Preliminary Node Setup
1) Run this check: 
> lsmod | grep br_netfilter

2) If line is empty, run this: 
>  sudo modprobe br_netfilter

Should look like this:

        vagrant@kubemaster:~$ lsmod | grep br_netfilter
        br_netfilter           24576  0
        bridge                155648  1 br_netfilter

3) Let IPTables see bridged traffic (paste this into all nodes):

        cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
        br_netfilter
        EOF
        
        cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
        net.bridge.bridge-nf-call-ip6tables = 1
        net.bridge.bridge-nf-call-iptables = 1
        EOF
        sudo sysctl --system

### 3) Installing Docker | https://docs.docker.com/engine/install/ubuntu/

        sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        echo \
            "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io

        sudo docker run hello-world

        sudo groupadd docker
        sudo usermod -aG docker $USER

        ### MIGHT NOT BE NECESSARY
        sudo systemctl daemon-reload && sudo systemctl restart docker

       vagrant@kubenode01:~$ systemctl status docker.service
       ● docker.service - Docker Application Container Engine
       Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
       Active: active (running) since Wed 2021-08-18 18:24:35 UTC; 1h 16min ago
       Docs: https://docs.docker.com
       Main PID: 4954 (dockerd)
       Tasks: 10
       CGroup: /system.slice/docker.service
       └─4954 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock


### 4) Installing Kubernetes | Kubelet, Kubeadm, Kubectl 

1) Update the apt package index and install packages needed to use the Kubernetes apt repository:
> sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl
2) Download the Google Cloud public signing key:
> sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
3) Add the Kubernetes apt repository:
> echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
4) Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:
> sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl
> sudo apt-mark hold kubelet kubeadm kubectl

### 5) Initialize Control Plane Node
1) ONLY FOR HA (Skipped)
2) Install Pod-Network Add-On // https://www.weave.works/docs/net/latest/kubernetes/kube-addon/
> kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
3) *--cri-socket* for kubeadm init (SKIPPED) - Only for different container runtimes
4) Init Master Node // NOTE - Run as as ROOT 1st (See below)
> kubeadm init --pod-network-cidr [DESIRED_POD_RANGE] --apiserver-advertise-address[MASTER-NODE-IP]
> kubeadm init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address=192.168.56.2
// Determining Master Node IP ==> ifconfig 


NOTE: Determining Master IP Address - ***ifconfig*** ==> 192.168.56.2 (1st inet address)
> vagrant@kubemaster:~$ ifconfig enp0s8 | grep inet
inet 192.168.56.2  netmask 255.255.255.0  broadcast 192.168.56.255
inet6 fe80::a00:27ff:fe3d:22fe  prefixlen 64  scopeid 0x20<link>



RUNNING AS ROOT: https://stackoverflow.com/questions/25758737/vagrant-login-as-root-by-default
> sudo su
> > pwd: helloworld12

KUBELET ERROR: https://stackoverflow.com/questions/52119985/kubeadm-init-shows-kubelet-isnt-running-or-healthy
> sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

