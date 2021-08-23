## Questions

### 1) Identify the DNS solution implemented in this cluster.
<details> 
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get pods -A | grep -v NAME | grep dns
    kube-system   coredns-74ff55c5b-ksdfb                1/1     Running   0          9m1s
    kube-system   coredns-74ff55c5b-p97jx                1/1     Running   0          9m1s
</details>

### 2) How many pods of the DNS server are deployed?
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get pods -A | grep -v NAME | grep -c dns
    2
</details>

### 3) What is the name of the service created for accessing CoreDNS?
<details>
  <summary markdown="span">Answer</summary>

    kube-dns
    
    @controlplane:~# k get -n=kube-system pod/coredns-74ff55c5b-ksdfb --show-labels
    NAME                      READY   STATUS    RESTARTS   AGE   LABELS
    coredns-74ff55c5b-ksdfb   1/1     Running   0          23m   k8s-app=kube-dns,pod-template-hash=74ff55c5b
    
    root@controlplane:~# k get svc -Al k8s-app=kube-dns
    NAMESPACE     NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
    kube-system   kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   24m
</details>

### 4) What is the IP of the CoreDNS server that should be configured on PODs to resolve services?
<details>
  <summary markdown="span">Answer</summary>

    10.96.0.10

    root@controlplane:~# k exec hr -it -- cat /etc/resolv.conf
    nameserver 10.96.0.10
    search default.svc.cluster.local svc.cluster.local cluster.local
    options ndots:5

</details>

### 5) Where is the configuration file located for configuring the CoreDNS service?
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get -n=kube-system pod/coredns-74ff55c5b-ksdfb -ocustom-columns=:.spec.containers[].args | xargs
    [-conf /etc/coredns/Corefile]

</details>

### 6) How is the Corefile passed in to the CoreDNS POD?
<details>
  <summary markdown="span">Answer</summary>

    ==> CONFIGMAP

    root@controlplane:~# k get -n=kube-system pod/coredns-74ff55c5b-ksdfb -ocustom-columns=:.spec.volumes[] | xargs
    map[configMap:map[defaultMode:420 items:[map[key:Corefile path:Corefile]] name:coredns] name:config-volume]
    
    root@controlplane:~# k get -n=kube-system cm/coredns -ocustom-columns=:.data
    map[Corefile:.:53 {
        errors
        health {
           lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           fallthrough in-addr.arpa ip6.arpa
           ttl 30
        }
        prometheus :9153
        forward . /etc/resolv.conf {
           max_concurrent 1000
        }
        cache 30
        loop
        reload
        loadbalance
    }
    ]
</details>

### 7) What is the name of the ConfigMap object created for Corefile?
<details>
  <summary markdown="span">Answer</summary>
    
    coredns

    root@controlplane:~# k get -n=kube-system pod/coredns-74ff55c5b-ksdfb -ocustom-columns=:.spec.volumes[] | xargs
    map[configMap:map[defaultMode:420 items:[map[key:Corefile path:Corefile]] name:coredns] name:config-volume]
</details>

### 8) What is the root domain/zone configured for this kubernetes cluster?
<details>
  <summary markdown="span">Answer</summary>

    cluster.local

</details>

We have deployed a set of PODs and Services in the default and payroll namespaces. Inspect them and go to the next question.
### 9)
<details>
  <summary markdown="span">Answer</summary>

</details>

### 10) What name can be used to access the hr web server from the test Application?
You can execute a curl command on the test pod to test. Alternatively, the test Application also has a UI. Access it using the tab at the top of your terminal named test-app.
<details>
  <summary markdown="span">Answer</summary>

    web-service.default.svc.cluster.local:80    

    root@controlplane:~# k get pods/hr --show-labels -owide
    NAME   READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES   LABELS
    hr     1/1     Running   0          43m   10.244.0.6   controlplane   <none>           <none>            name=hr
    root@controlplane:~# k get ep
    NAME           ENDPOINTS          AGE
    kubernetes     10.31.101.9:6443   46m
    test-service   10.244.0.5:8080    43m
    web-service    10.244.0.6:80      43m
    root@controlplane:~# k get svc/web-service
    NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
    web-service   ClusterIP   10.105.127.251   <none>        80/TCP    43m
</details>

### 11) Which of the names CANNOT be used to access the HR service from the test pod?
1) web-service.default.pod <==
2) web-service.default.svc
3) web-service.default
4) web-service
<details>
  <summary markdown="span">Answer</summary>

    web-service.default.pod

</details>

### 12) Which of the below name can be used to access the payroll service from the test application?
1) web-service.payroll
2) web-service
3) web
4) web-service.default
<details>
  <summary markdown="span">Answer</summary>

    ==> web-service.payroll

    root@controlplane:~# k get svc -A
    NAMESPACE     NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                  AGE
    default       kubernetes     ClusterIP   10.96.0.1        <none>        443/TCP                  49m
    default       test-service   NodePort    10.109.87.17     <none>        80:30080/TCP             46m
    default       web-service    ClusterIP   10.105.127.251   <none>        80/TCP                   46m
    kube-system   kube-dns       ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP,9153/TCP   49m
    payroll       web-service    ClusterIP   10.99.139.221    <none>        80/TCP                   46m
</details>


### 13) Which of the below name CANNOT be used to access the payroll service from the test application?
1) web-service.payroll.svc
2) web-service.payroll
3) web-service.payroll.svc.cluster
4) web-service.payroll.svc.cluster.local
<details>
  <summary markdown="span">Answer</summary>

    ==> web-service.payroll.svc.cluster
</details>


### 14) We just deployed a web server - webapp - that accesses a database mysql - server. However the web server is failing to connect to the database server. Troubleshoot and fix the issue.
<details>
  <summary markdown="span">Answer</summary>

    Environment Variables: DB_Host=mysql; DB_Database=Not Set; DB_User=root; DB_Password=paswrd; 2003: Can't connect to MySQL server on 'mysql:3306' (-2 Name does not resolve)
    From webapp-84ffb6ddff-tv5mh!

    root@controlplane@controlplane:~# k get pod/webapp-c995bfc7b-rt6zd --show-labels
    NAME                     READY   STATUS    RESTARTS   AGE     LABELS
    webapp-c995bfc7b-rt6zd   1/1     Running   0          2m31s   name=webapp,pod-template-hash=c995bfc7b

    root@controlplane:~# k get deploy -A -l=name=webapp
    NAMESPACE   NAME     READY   UP-TO-DATE   AVAILABLE   AGE
    default     webapp   1/1     1            1           9m41s

    k set env deploy/webapp DB_Host=mysql.payroll
</details>

### 15) From the hr pod nslookup the mysql service and redirect the output to a file /root/CKA/nslookup.out
<details>
  <summary markdown="span">Answ er</summary>

    kubectl exec -it hr -- nslookup mysql.payroll > /root/CKA/nslookup.out
</details>

They could be in different namespaces. First locate the applications. The web server interface can be seen by clicking the tab Web Server at the top of your terminal.

## TABLE TEMPLATES

### 2-Col | w/ Steps
| STEP  |               |               |       
| ----- | ------------- | ------------- |
| 1     |               |               |               
| 2     |               |               |               
| 3     |               |               |               
| 4     |               |               |               
| 5     |               |               |               
| 6     |               |               |               
| 7     |               |               |               
| 8     |               |               |               
| 9     |               |               |               
| 10    |               |               |               


### 2-Col | w/ Steps
|       |               |               |       
| ----- | ------------- | ------------- |
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |               
|       |               |               |
