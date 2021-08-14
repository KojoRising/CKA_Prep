## Questions

### 1) Create Network Namespaces
<details> 
  <summary markdown="span">Answer</summary>

    root@controlplane:~# ip netns add J-1
    root@controlplane:~# ip netns add J-2
    root@controlplane:~# ip netns
    N-2
    N-1
</details>

### 2) Create Bridge
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# ip link add BR type bridge
    root@controlplane:~# ip link | grep BR:
    19: BR: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
</details>

### 3) Create Interfaces (DO NOT CREATE PEER INTERFACE AHEAD OF TIME!!!)
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# ip link add ETH-1 type veth peer name ETH-0
    root@controlplane:~# ip link | grep ETH
    16: ETH-1@ETH-0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    17: ETH-0@ETH-1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000

    // If you Create peer ahead of time, this might happen: 
    root@controlplane:~# ip link add ETH-0 type veth
    root@controlplane:~# ip link | grep ETH
    14: veth0@ETH-0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    15: ETH-0@veth0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
</details>

### 4) Set Interfaces on Namespace+Bridge
<details>
  <summary markdown="span">Answer</summary>

    //////////////////// UP-TO-NOW ////////////////////
    root@controlplane:~# ip link | grep ETH
    20: ETH-0@ETH-1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    21: ETH-1@ETH-0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000

    //////////////////// NAMESPACE ////////////////////

    root@controlplane:~# ip link set ETH-1 netns N-1
    // NOTE: "ETH-1" is gone because it is no longer in the "default" namespace
    root@controlplane:~# ip link | grep ETH
    20: ETH-0@if21: <BROADCAST,MULTICAST> mtu 1500 qd
    
    //////////////////// BRIDGE ////////////////////

    // NOTE: see "master BR" in the listing now
    root@controlplane:~# ip link set ETH-0 master BR
    root@controlplane:~# ip link | grep ETH
    20: ETH-0@if21: <BROADCAST,MULTICAST> mtu 1500 qdisc noop master BR state DOWN mode DEFAULT group default qlen 1000
</details>

### 5) Assign IP Addresses on Interfaces
<details>
  <summary markdown="span">Answer</summary>

    ip -n N-1 addr add 192.168.15.1 dev ETH-1

</details>

### 6)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 7)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 8)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 9)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 10)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 11)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 12)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 13)
<details>
  <summary markdown="span">Answer</summary>

</details>




