## Questions

### 1) Identify the certificate file used for the kube-api server


<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep "tls-cert-file"
    - --tls-cert-file=/etc/kubernetes/pki/apiserver.crt
</details>



### 2) Identify the certificate file used by the kube-apiserver to communicate to etcd 

<details>
  <summary markdown="span">Answer</summary>

        root@controlplane:~# cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep "etcd-certfile"     
            - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt

    OR: 
        root@controlplane:/etc/kubernetes/manifests# cat kube-apiserver.yaml | grep --regexp="--" | grep cert 
            - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
            - --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt
            - --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt
            - --tls-cert-file=/etc/kubernetes/pki/apiserver.crt
</details>


### 3) Identify the key used by the kube-apiserver to communicate to the kubelet server

<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep kubelet | grep key
    - --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key

</details>


### 4) Identify the ETCD Server Certificate used to host ETCD server

<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# cat /etc/kubernetes/manifests/etcd.yaml | grep server | grep .crt
    - --cert-file=/etc/kubernetes/pki/etcd/server.crt

</details>

### 5) Identify the ETCD Server CA Root Certificate used to serve ETCD Server

ETCD can have its own CA. So this may be a different CA certificate than the one used by kube-api server.


<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:/etc/kubernetes/manifests# cat etcd.yaml | grep ca | grep .crt
    - --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
    - --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt

</details>


### 6) What is the Common Name (CN) configured on the Kube API Server Certificate?

OpenSSL Syntax: ***openssl x509 -in file-path.crt -text -noout***

<details>
  <summary markdown="span">Answer</summary>

    ANSWER: kube-apiserver

    root@controlplane:/etc/kubernetes/manifests# openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout | grep Subject
        Subject: CN = kube-apiserver
        Subject Public Key Info:
            X509v3 Subject Alternative Name: 

    root@controlplane:/etc/kubernetes/manifests# openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout
    Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 3123024519753970768 (0x2b57364114c53450)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = kubernetes
        Validity
            Not Before: Jul 22 20:25:26 2021 GMT
            Not After : Jul 22 20:25:26 2022 GMT
        Subject: CN = kube-apiserver
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:d1:0c:37:8d:f4:63:19:da:a1:c2:16:2f:ec:37:
                    88:f2:3d:6a:2b:5b:68:30:3e:3c:f0:6a:fc:cf:e7:
                    8d:07:a1:28:03:7c:5c:b5:19:e5:89:48:4c:fa:6c:
                    f4:86:5f:88:04:e1:94:64:58:28:8b:34:b9:f9:21:
                    ab:92:81:d5:5e:96:6e:c9:9c:df:a6:2f:51:ac:7d:
                    ba:0b:77:ee:69:79:c7:e6:04:cd:c3:c2:87:20:3b:
                    ab:81:0a:90:33:27:d0:bf:92:33:fb:f3:df:3c:12:
                    8a:a8:b5:35:6c:05:f2:ab:74:fa:6d:fa:88:d7:2b:
                    14:9f:ac:84:bb:8d:63:3b:54:c8:1e:80:9a:83:03:
                    f7:44:1c:71:2f:fa:98:2d:0c:11:58:33:94:6a:a8:
                    e3:b3:0b:79:d0:03:63:59:1c:fc:54:7b:4a:f4:03:
                    8a:74:7e:55:19:94:6f:0b:f4:9c:cc:f1:74:49:63:
                    07:4c:28:2e:e7:55:b0:21:d5:0c:5a:9b:6b:69:34:
                    6e:6c:99:16:28:8a:ae:04:19:a2:49:80:38:89:1e:
                    bf:2d:01:06:5a:71:14:7e:f5:7f:b1:fb:93:64:0e:
                    8a:10:4e:b3:8d:71:28:dd:a7:c0:99:0c:51:84:91:
                    9a:d6:b9:ba:b9:a7:ea:e1:cd:4d:ad:5e:df:b5:66:
                    f8:c3
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage: 
                TLS Web Server Authentication
            X509v3 Authority Key Identifier: 
                keyid:E0:1D:8C:2F:10:15:8A:46:B9:54:35:F3:2F:D4:AC:CA:31:D9:46:41

            X509v3 Subject Alternative Name: 
                DNS:controlplane, DNS:kubernetes, DNS:kubernetes.default, DNS:kubernetes.default.svc, DNS:kubernetes.default.svc.cluster.local, IP Address:10.96.0.1, IP Address:10.36.167.3
    Signature Algorithm: sha256WithRSAEncryption
         7a:b6:16:d7:12:0c:39:12:86:54:5f:1d:6b:3e:c4:ba:91:4f:
         ce:00:72:f1:a8:10:be:04:95:62:21:d6:ce:19:e6:1f:01:26:
         5b:84:d7:f1:49:fd:30:fa:c8:fa:db:1b:da:7d:c8:f8:bd:78:
         d4:dd:16:39:7a:3c:6c:47:1b:cf:cc:8a:85:31:7f:a8:07:42:
         fb:80:51:e1:f4:7e:cd:ad:38:9f:1c:d6:0f:ee:15:5f:b3:c9:
         84:2a:4f:fb:7c:31:d7:8d:7a:85:cf:16:9e:2f:04:1b:8f:6d:
         b6:cb:d6:ed:5c:b1:81:2a:c5:14:09:23:25:9f:67:cb:6f:c7:
         ca:d1:2d:b7:b0:1c:e7:94:dd:dd:7b:69:45:48:3d:2b:c8:a7:
         a7:b5:b8:85:dd:5e:b3:48:90:2d:b1:f6:3e:20:f6:0b:7d:8b:
         39:53:01:75:8b:90:29:1d:89:c0:9b:0b:96:e8:00:94:17:1f:
         be:9f:e7:17:29:a1:10:3a:f5:95:c3:b1:7b:78:96:24:30:1b:
         64:a3:3f:f2:bb:69:4f:1e:27:c9:e2:9d:ba:79:d8:69:b4:23:
         8f:e2:f7:8c:78:53:1f:69:3d:f8:17:c9:2c:a7:e1:88:10:28:
         eb:1b:df:3a:05:48:3a:8c:d6:a0:ee:a6:8a:43:8a:24:b9:f6:
         4d:83:08:de
</details>



### 6) What is the name of the CA who issued the Kube API Server Certificate?

OpenSSL Syntax: ***openssl x509 -in file-path.crt -text -noout***

<details>
  <summary markdown="span">Answer</summary>

    ANSWER: kubernetes

    root@controlplane:/etc/kubernetes/manifests# openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout | grep Issuer 
        Issuer: CN = kubernetes
</details>


### 7) Which of the below alternate names is not configured on the Kube API Server Certificate?

<details>
  <summary markdown="span">Answer</summary>

    ANSWER: kube-master

    X509v3 Subject Alternative Name:
        DNS:controlplane, DNS:kubernetes, DNS:kubernetes.default, DNS:kubernetes.default.svc, 
        DNS:kubernetes.default.svc.cluster.local, IP Address:10.96.0.1, IP Address:10.36.167.3

</details>


### 8) NA

<details>
  <summary markdown="span">Answer</summary>
    
</details>


### 9) What is the Common Name (CN) configured on the ETCD Server certificate?

<details>
  <summary markdown="span">Answer</summary>
    
    root@controlplane:/etc/kubernetes/manifests# openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text -noout | grep Subject
    Subject: CN = controlplane
    Subject Public Key Info:
        X509v3 Subject Alternative Name: 
</details>

### 10) How long, from the issued date, is the Kube-API Server Certificate valid for?
File: /etc/kubernetes/pki/apiserver.crt

<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:/etc/kubernetes/manifests# openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout | grep Not
    Not Before: Jul 22 20:25:26 2021 GMT
    Not After : Jul 22 20:25:26 2022 GMT
</details>



### 11) How long, from the issued date, is the Root CA Certificate valid for?
File: /etc/kubernetes/pki/ca.crt

<details>
  <summary markdown="span">Answer</summary>

        root@controlplane:/etc/kubernetes/manifests# openssl x509 -in /etc/kubernetes/pki/ca.crt -text -noout | grep Not
            Not Before: Jul 22 20:25:26 2021 GMT
            Not After : Jul 20 20:25:26 2031 GMT

</details>


### 12) Kubectl suddenly stops responding to your commands. Check it out! Someone recently modified the /etc/kubernetes/manifests/etcd.yaml file

You are asked to investigate and fix the issue. Once you fix the issue wait for sometime for kubectl to respond. Check the logs of the ETCD container.

The certificate file used here is incorrect. 
It is set to /etc/kubernetes/pki/etcd/server-certificate.crt which does not exist. As we saw in the previous questions the correct path should be /etc/kubernetes/pki/etcd/server.crt.


<details>
  <summary markdown="span">Answer</summary>

        root@controlplane:/etc/kubernetes/manifests# cat etcd.yaml | sed "s/*server-certificate.crt/server.crt/" > etcd.yaml
        
        root@controlplane:/etc/kubernetes/manifests# k logs etcd-controlplane
        [WARNING] Deprecated '--logger=capnslog' flag is set; use '--logger=zap' flag instead
        2021-07-24 21:42:41.709702 I | etcdmain: etcd Version: 3.4.13
        2021-07-24 21:42:41.709750 I | etcdmain: Git SHA: ae9734ed2
        2021-07-24 21:42:41.709754 I | etcdmain: Go Version: go1.12.17
        2021-07-24 21:42:41.709758 I | etcdmain: Go OS/Arch: linux/amd64
        2021-07-24 21:42:41.709762 I | etcdmain: setting maximum number of CPUs to 48, total number of available CPUs is 48
        2021-07-24 21:42:41.709834 N | etcdmain: the server is already initialized as member before, starting as etcd member...
        [WARNING] Deprecated '--logger=capnslog' flag is set; use '--logger=zap' flag instead
        2021-07-24 21:42:41.709884 I | embed: peerTLS: cert = /etc/kubernetes/pki/etcd/peer.crt, key = /etc/kubernetes/pki/etcd/peer.key, trusted-ca = /etc/kubernetes/pki/etcd/ca.crt, client-cert-auth = true, crl-file = 
        2021-07-24 21:42:41.713600 I | embed: name = controlplane
        2021-07-24 21:42:41.713633 I | embed: data dir = /var/lib/etcd
        2021-07-24 21:42:41.713638 I | embed: member dir = /var/lib/etcd/member
        2021-07-24 21:42:41.713642 I | embed: heartbeat = 100ms
        2021-07-24 21:42:41.713645 I | embed: election = 1000ms
        2021-07-24 21:42:41.713649 I | embed: snapshot count = 10000
        2021-07-24 21:42:41.713661 I | embed: advertise client URLs = https://10.31.11.9:2379
        2021-07-24 21:42:41.713671 I | embed: initial advertise peer URLs = https://10.31.11.9:2380
        2021-07-24 21:42:41.713677 I | embed: initial cluster = 
        2021-07-24 21:42:41.746216 I | etcdserver: restarting member 19c8262e9c6c6bc3 in cluster 8d684b063c5088d9 at commit index 2784
        raft2021/07/24 21:42:41 INFO: 19c8262e9c6c6bc3 switched to configuration voters=()
        raft2021/07/24 21:42:41 INFO: 19c8262e9c6c6bc3 became follower at term 7
        raft2021/07/24 21:42:41 INFO: newRaft 19c8262e9c6c6bc3 [peers: [], term: 7, commit: 2784, applied: 0, lastindex: 2784, lastterm: 7]
        2021-07-24 21:42:41.750299 W | auth: simple token is not cryptographically signed
        2021-07-24 21:42:41.802994 I | mvcc: restore compact to 1900
        2021-07-24 21:42:41.808153 I | etcdserver: starting server... [version: 3.4.13, cluster version: to_be_decided]
        raft2021/07/24 21:42:41 INFO: 19c8262e9c6c6bc3 switched to configuration voters=(1857776827925031875)
        2021-07-24 21:42:41.810631 I | etcdserver/membership: added member 19c8262e9c6c6bc3 [https://10.31.11.9:2380] to cluster 8d684b063c5088d9
        2021-07-24 21:42:41.810810 N | etcdserver/membership: set the initial cluster version to 3.4
        2021-07-24 21:42:41.810865 I | etcdserver/api: enabled capabilities for version 3.4
        2021-07-24 21:42:41.812249 I | embed: ClientTLS: cert = /etc/kubernetes/pki/etcd/server.crt, key = /etc/kubernetes/pki/etcd/server.key, trusted-ca = /etc/kubernetes/pki/etcd/ca.crt, client-cert-auth = true, crl-file = 
        2021-07-24 21:42:41.812373 I | embed: listening for peers on 10.31.11.9:2380
        2021-07-24 21:42:41.812475 I | embed: listening for metrics on http://127.0.0.1:2381
        raft2021/07/24 21:42:43 INFO: 19c8262e9c6c6bc3 is starting a new election at term 7
        raft2021/07/24 21:42:43 INFO: 19c8262e9c6c6bc3 became candidate at term 8
        raft2021/07/24 21:42:43 INFO: 19c8262e9c6c6bc3 received MsgVoteResp from 19c8262e9c6c6bc3 at term 8
        raft2021/07/24 21:42:43 INFO: 19c8262e9c6c6bc3 became leader at term 8
        raft2021/07/24 21:42:43 INFO: raft.node: 19c8262e9c6c6bc3 elected leader 19c8262e9c6c6bc3 at term 8
        2021-07-24 21:42:43.550368 I | etcdserver: published {Name:controlplane ClientURLs:[https://10.31.11.9:2379]} to cluster 8d684b063c5088d9
        2021-07-24 21:42:43.550413 I | embed: ready to serve client requests
        2021-07-24 21:42:43.600847 I | embed: ready to serve client requests
        2021-07-24 21:42:43.603830 I | embed: serving client requests on 10.31.11.9:2379
        2021-07-24 21:42:43.604047 I | embed: serving client requests on 127.0.0.1:2379
        2021-07-24 21:42:51.705165 I | etcdserver/api/etcdhttp: /health OK (status code 200)
        2021-07-24 21:42:53.203999 W | etcdserver: read-only range request "key:\"/registry/priorityclasses/system-cluster-critical\" " with result "range_response_count:1 size:476" took too long (198.430453ms) to execute
        2021-07-24 21:42:53.204750 W | etcdserver: read-only range request "key:\"/registry/health\" " with result "range_response_count:0 size:5" took too long (103.396408ms) to execute
        2021-07-24 21:43:38.108369 I | etcdserver/api/etcdhttp: /health OK (status code 200)
        2021-07-24 21:43:48.108267 I | etcdserver/api/etcdhttp: /health OK (status code 200)
        2021-07-24 21:43:58.108211 I | etcdserver/api/etcdhttp: /health OK (status code 200)

</details>


### 13) The kube-api server stopped again! Check it out. Inspect the kube-api server logs and identify the root cause and fix the issue.

Run docker ps -a command to identify the kube-api server container. Run docker logs container-id command to view the logs.

TODO: Fix cat cmd (#3) below
<details>
  <summary markdown="span">Answer</summary>

        1) docker ps -a | grep kube-apiserver
        2) docker logs ca9843d3b545  --tail=2
        3) cat kube-apiserver.yaml 
            - --client-ca-file=/etc/kubernetes/pki/ca.crt
            - --enable-admission-plugins=NodeRestriction
            - --enable-bootstrap-token-auth=true
            - --etcd-cafile=/etc/kubernetes/pki/ca.crt

            ETCD CA is WRONG!! Change to: \
            - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt

        If we inspect the kube-apiserver container on the controlplane, we can see that it is frequently exiting.
        
        root@controlplane:~# docker ps -a | grep kube-apiserver
        8af74bd23540        ca9843d3b545           "kube-apiserver --ad…"   39 seconds ago      Exited (1) 17 seconds ago                          k8s_kube-apiserver_kube-apiserver-controlplane_kube-system_f320fbaff7813586592d245912262076_4
        c9dc4df82f9d        k8s.gcr.io/pause:3.2   "/pause"                 3 minutes ago       Up 3 minutes                                       k8s_POD_kube-apiserve-controlplane_kube-system_f320fbaff7813586592d245912262076_1
        root@controlplane:~#
        If we now inspect the logs of this exited container, we would see the following errors:
        
        root@controlplane:~# docker logs ca9843d3b545  --tail=2
        W0520 01:57:23.333002       1 clientconn.go:1223] grpc: addrConn.createTransport failed to connect to {https://127.0.0.1:2379  <nil> 0 <nil>}. \ 
        Err :connection error: desc = "transport: authentication handshake failed: x509: certificate signed by unknown authority". Reconnecting...
        Error: context deadline exceeded
        root@controlplane:~#
        This indicates an issue with the ETCD CA certificate used by the kube-apiserver. Correct it to use the file /etc/kubernetes/pki/etcd/ca.crt.
        
        Once the YAML file has been saved, wait for the kube-apiserver pod to be Ready. This can take a couple of minutes.

</details>


### FULL CERT DETAILS

<details>
  <summary markdown="span">Original Cert</summary>

    root@controlplane:/etc/kubernetes/manifests# cat /etc/kubernetes/pki/apiserver.crt 
    -----BEGIN CERTIFICATE-----
    MIIDfjCCAmagAwIBAgIIK1c2QRTFNFAwDQYJKoZIhvcNAQELBQAwFTETMBEGA1UE
    AxMKa3ViZXJuZXRlczAeFw0yMTA3MjIyMDI1MjZaFw0yMjA3MjIyMDI1MjZaMBkx
    FzAVBgNVBAMTDmt1YmUtYXBpc2VydmVyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
    MIIBCgKCAQEA0Qw3jfRjGdqhwhYv7DeI8j1qK1toMD488Gr8z+eNB6EoA3xctRnl
    iUhM+mz0hl+IBOGUZFgoizS5+SGrkoHVXpZuyZzfpi9RrH26C3fuaXnH5gTNw8KH
    IDurgQqQMyfQv5Iz+/PfPBKKqLU1bAXyq3T6bfqI1ysUn6yEu41jO1TIHoCagwP3
    RBxxL/qYLQwRWDOUaqjjswt50ANjWRz8VHtK9AOKdH5VGZRvC/SczPF0SWMHTCgu
    51WwIdUMWptraTRubJkWKIquBBmiSYA4iR6/LQEGWnEUfvV/sfuTZA6KEE6zjXEo
    3afAmQxRhJGa1rm6uafq4c1NrV7ftWb4wwIDAQABo4HNMIHKMA4GA1UdDwEB/wQE
    AwIFoDATBgNVHSUEDDAKBggrBgEFBQcDATAfBgNVHSMEGDAWgBTgHYwvEBWKRrlU
    NfMv1KzKMdlGQTCBgQYDVR0RBHoweIIMY29udHJvbHBsYW5lggprdWJlcm5ldGVz
    ghJrdWJlcm5ldGVzLmRlZmF1bHSCFmt1YmVybmV0ZXMuZGVmYXVsdC5zdmOCJGt1
    YmVybmV0ZXMuZGVmYXVsdC5zdmMuY2x1c3Rlci5sb2NhbIcECmAAAYcECiSnAzAN
    BgkqhkiG9w0BAQsFAAOCAQEAerYW1xIMORKGVF8daz7EupFPzgBy8agQvgSVYiHW
    zhnmHwEmW4TX8Un9MPrI+tsb2n3I+L141N0WOXo8bEcbz8yKhTF/qAdC+4BR4fR+
    za04nxzWD+4VX7PJhCpP+3wx1416hc8Wni8EG49ttsvW7VyxgSrFFAkjJZ9ny2/H
    ytEtt7Ac55Td3XtpRUg9K8inp7W4hd1es0iQLbH2PiD2C32LOVMBdYuQKR2JwJsL
    lugAlBcfvp/nFymhEDr1lcOxe3iWJDAbZKM/8rtpTx4nyeKdunnYabQjj+L3jHhT
    H2k9+BfJLKfhiBAo6xvfOgVIOozWoO6mikOKJLn2TYMI3g==
    -----END CERTIFICATE-----
</details>

<details>
  <summary markdown="span">Translated Cert</summary>

    root@controlplane:/etc/kubernetes/manifests# openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout
    Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 3123024519753970768 (0x2b57364114c53450)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = kubernetes
        Validity
            Not Before: Jul 22 20:25:26 2021 GMT
            Not After : Jul 22 20:25:26 2022 GMT
        Subject: CN = kube-apiserver
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:d1:0c:37:8d:f4:63:19:da:a1:c2:16:2f:ec:37:
                    88:f2:3d:6a:2b:5b:68:30:3e:3c:f0:6a:fc:cf:e7:
                    8d:07:a1:28:03:7c:5c:b5:19:e5:89:48:4c:fa:6c:
                    f4:86:5f:88:04:e1:94:64:58:28:8b:34:b9:f9:21:
                    ab:92:81:d5:5e:96:6e:c9:9c:df:a6:2f:51:ac:7d:
                    ba:0b:77:ee:69:79:c7:e6:04:cd:c3:c2:87:20:3b:
                    ab:81:0a:90:33:27:d0:bf:92:33:fb:f3:df:3c:12:
                    8a:a8:b5:35:6c:05:f2:ab:74:fa:6d:fa:88:d7:2b:
                    14:9f:ac:84:bb:8d:63:3b:54:c8:1e:80:9a:83:03:
                    f7:44:1c:71:2f:fa:98:2d:0c:11:58:33:94:6a:a8:
                    e3:b3:0b:79:d0:03:63:59:1c:fc:54:7b:4a:f4:03:
                    8a:74:7e:55:19:94:6f:0b:f4:9c:cc:f1:74:49:63:
                    07:4c:28:2e:e7:55:b0:21:d5:0c:5a:9b:6b:69:34:
                    6e:6c:99:16:28:8a:ae:04:19:a2:49:80:38:89:1e:
                    bf:2d:01:06:5a:71:14:7e:f5:7f:b1:fb:93:64:0e:
                    8a:10:4e:b3:8d:71:28:dd:a7:c0:99:0c:51:84:91:
                    9a:d6:b9:ba:b9:a7:ea:e1:cd:4d:ad:5e:df:b5:66:
                    f8:c3
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage: 
                TLS Web Server Authentication
            X509v3 Authority Key Identifier: 
                keyid:E0:1D:8C:2F:10:15:8A:46:B9:54:35:F3:2F:D4:AC:CA:31:D9:46:41

            X509v3 Subject Alternative Name: 
                DNS:controlplane, DNS:kubernetes, DNS:kubernetes.default, DNS:kubernetes.default.svc, DNS:kubernetes.default.svc.cluster.local, IP Address:10.96.0.1, IP Address:10.36.167.3
    Signature Algorithm: sha256WithRSAEncryption
         7a:b6:16:d7:12:0c:39:12:86:54:5f:1d:6b:3e:c4:ba:91:4f:
         ce:00:72:f1:a8:10:be:04:95:62:21:d6:ce:19:e6:1f:01:26:
         5b:84:d7:f1:49:fd:30:fa:c8:fa:db:1b:da:7d:c8:f8:bd:78:
         d4:dd:16:39:7a:3c:6c:47:1b:cf:cc:8a:85:31:7f:a8:07:42:
         fb:80:51:e1:f4:7e:cd:ad:38:9f:1c:d6:0f:ee:15:5f:b3:c9:
         84:2a:4f:fb:7c:31:d7:8d:7a:85:cf:16:9e:2f:04:1b:8f:6d:
         b6:cb:d6:ed:5c:b1:81:2a:c5:14:09:23:25:9f:67:cb:6f:c7:
         ca:d1:2d:b7:b0:1c:e7:94:dd:dd:7b:69:45:48:3d:2b:c8:a7:
         a7:b5:b8:85:dd:5e:b3:48:90:2d:b1:f6:3e:20:f6:0b:7d:8b:
         39:53:01:75:8b:90:29:1d:89:c0:9b:0b:96:e8:00:94:17:1f:
         be:9f:e7:17:29:a1:10:3a:f5:95:c3:b1:7b:78:96:24:30:1b:
         64:a3:3f:f2:bb:69:4f:1e:27:c9:e2:9d:ba:79:d8:69:b4:23:
         8f:e2:f7:8c:78:53:1f:69:3d:f8:17:c9:2c:a7:e1:88:10:28:
         eb:1b:df:3a:05:48:3a:8c:d6:a0:ee:a6:8a:43:8a:24:b9:f6:
         4d:83:08:de
</details>
