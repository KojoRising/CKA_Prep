## Questions

Once done, click on the Next Question button in the top right corner of this panel.
You may navigate back and forth freely between all questions. Once done with all questions, click on End Exam.
Your work will be validated at the end and score shown.
Good Luck!

### 1) Deploy a pod named nginx-pod using the nginx:alpine image.
Name: nginx-pod
Image: nginx:alpine
<details> 
  <summary markdown="span">Answer</summary>

    k run nginx-pod --image=nginx:alpine
</details>

### 2) Deploy a messaging pod using the redis:alpine image with the labels set to tier=msg.
Pod Name: messaging
Image: redis:alpine
Labels: tier=msg
<details>
  <summary markdown="span">Answer</summary>

     k run messaging --image=redis:alpine -l tier=msg
</details>

### 3) Create a namespace named apx-x9984574.
<details>
  <summary markdown="span">Answer</summary>

    k create ns apx-x9984574
</details>

### 4) Get the list of nodes in JSON format and store it in a file at /opt/outputs/nodes-z3444kd9.json.
<details>
  <summary markdown="span">Answer</summary>

    k get nodes -ojson > /opt/outputs/nodes-z3444kd9.json
</details>

### 5) Create a service messaging-service to expose the messaging application within the cluster on port 6379.Use imperative commands.
Service: messaging-service
Port: 6379
Type: ClusterIp
Use the right labels
<details>
  <summary markdown="span">Answer</summary>

     k expose pod/messaging --type=ClusterIP --port=6379 --name=messaging-service
</details>

### 6) Create a deployment named hr-web-app using the image kodekloud/webapp-color with 2 replicas.
<details>
  <summary markdown="span">Answer</summary>

    k create deploy hr-web-app --image=kodekloud/webapp-color $d | sed "s/.*replicas: 1/  replicas: 2/"
    k create deploy hr-web-app --image=kodekloud/webapp-color && k scale deploy/hr-web-app --replicas=2    
</details>

### 7) Create a static pod named static-busybox on the master node that uses the busybox image and the command sleep 1000.
<details>
  <summary markdown="span">Answer</summary>

     k run static-busybox --image=busybox $d --command -- /bin/sh -c "sleep 100" > /etc/kubernetes/manifests/static-busybox.yaml
</details>

### 8) Create a POD in the finance namespace named temp-bus with the image redis:alpine.
<details>
  <summary markdown="span">Answer</summary>

    k run temp-bus --image=redis:alpine -n=finance
</details>

### 9) A new application orange is deployed. There is something wrong with it. Identify and fix the issue.
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get all | grep orange
    pod/orange                        0/1     Init:CrashLoopBackOff   1          7s

    ==> Init container had "sleeeeeep" in it
    
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: "2021-08-22T20:46:34Z"
      name: orange
      namespace: default
      resourceVersion: "6675"
      uid: d1276d39-9072-420a-82c1-5b4898e1e3dc
    spec:
      containers:
      - command:
        - sh
        - -c
        - echo The app is running! && sleep 3600
        image: busybox:1.28
        imagePullPolicy: IfNotPresent
        name: orange-container
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
          name: default-token-kzhnd
          readOnly: true
      dnsPolicy: ClusterFirst
      enableServiceLinks: true
      initContainers:
      - command:
        - sh
        - -c
        - sleeeeeep 2;
        image: busybox
        imagePullPolicy: Always
        name: init-myservice
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
          name: default-token-kzhnd
          readOnly: true
      nodeName: controlplane
      preemptionPolicy: PreemptLowerPriority
      priority: 0
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      serviceAccount: default
      serviceAccountName: default
      terminationGracePeriodSeconds: 30
      tolerations:
      - effect: NoExecute
        key: node.kubernetes.io/not-ready
        operator: Exists
        tolerationSeconds: 300
      - effect: NoExecute
        key: node.kubernetes.io/unreachable
        operator: Exists
        tolerationSeconds: 300
      volumes:
      - name: default-token-kzhnd
        secret:
          defaultMode: 420
          secretName: default-token-kzhnd
    status:
      conditions:
      - lastProbeTime: null
        lastTransitionTime: "2021-08-22T20:46:34Z"
        message: 'containers with incomplete status: [init-myservice]'
        reason: ContainersNotInitialized
        status: "False"
        type: Initialized
      - lastProbeTime: null
        lastTransitionTime: "2021-08-22T20:46:34Z"
        message: 'containers with unready status: [orange-container]'
        reason: ContainersNotReady
        status: "False"
        type: Ready
      - lastProbeTime: null
        lastTransitionTime: "2021-08-22T20:46:34Z"
        message: 'containers with unready status: [orange-container]'
        reason: ContainersNotReady
        status: "False"
        type: ContainersReady
      - lastProbeTime: null
        lastTransitionTime: "2021-08-22T20:46:34Z"
        status: "True"
        type: PodScheduled
      containerStatuses:
      - image: busybox:1.28
        imageID: ""
        lastState: {}
        name: orange-container
        ready: false
        restartCount: 0
        started: false
        state:
          waiting:
            reason: PodInitializing
      hostIP: 10.32.105.9
      initContainerStatuses:
      - containerID: docker://a5f808048a7e29ab945ca326e8e66611f124822608c480c43a2cb97ce6c110e6
        image: busybox:latest
        imageID: docker-pullable://busybox@sha256:b37dd066f59a4961024cf4bed74cae5e68ac26b48807292bd12198afa3ecb778
        lastState:
          terminated:
            containerID: docker://a5f808048a7e29ab945ca326e8e66611f124822608c480c43a2cb97ce6c110e6
            exitCode: 127
            finishedAt: "2021-08-22T20:49:57Z"
            reason: Error
            startedAt: "2021-08-22T20:49:57Z"
        name: init-myservice
        ready: false
        restartCount: 5
        state:
          waiting:
            message: back-off 2m40s restarting failed container=init-myservice pod=orange_default(d1276d39-9072-420a-82c1-5b4898e1e3dc)
            reason: CrashLoopBackOff
      phase: Pending
      podIP: 10.244.0.12
      podIPs:
      - ip: 10.244.0.12
</details>

### 10) Expose the hr-web-app as service hr-web-app-service application on port 30082 on the nodes on the cluster.
Name: hr-web-app-service
Type: NodePort
Endpoints: 2
Port: 8080
NodePort: 30082
The web application listens on port 8080.
<details>
  <summary markdown="span">Answer</summary>

    NOTE - Manually added in NodePort 30082 here

    root@controlplane:~# k expose deploy/hr-web-app --type=NodePort --name=hr-web-app-service --port=8080 $d 
    apiVersion: v1
    kind: Service
    metadata:
      creationTimestamp: null
      labels:
        app: hr-web-app
      name: hr-web-app-service
    spec:
      ports:
      - port: 8080
        protocol: TCP
        nodePort: 30082
        targetPort: 8080
      selector:
        app: hr-web-app
      type: NodePort
    status:
      loadBalancer: {}

    
service/hr-web-app-service created
root@controlplane:~# k get ep
NAME                 ENDPOINTS                         AGE
hr-web-app-service   10.244.0.6:8080,10.244.0.7:8080   7s
kubernetes           10.32.105.9:6443                  91m
messaging            10.244.0.5:6379                   20m
root@controlplane:~# k get pod
NAME                          READY   STATUS             RESTARTS   AGE
hr-web-app-99dfd4c9d-2pvst    1/1     Running            0          17m
hr-web-app-99dfd4c9d-vkmdb    1/1     Running            0          17m
messaging                     1/1     Running            0          25m
nginx-pod                     1/1     Running            0          26m
orange                        1/1     Running            0          5m19s
static-busybox-controlplane   0/1     CrashLoopBackOff   5          13m
root@controlplane:~# k get pod -owide | grep hr-web-app
hr-web-app-99dfd4c9d-2pvst    1/1     Running            0          17m     10.244.0.6    controlplane   <none>           <none>
hr-web-app-99dfd4c9d-vkmdb    1/1     Running            0          17m     10.244.0.7    controlplane   <none>           <none>
</details>

### 11) Use JSON PATH query to retrieve the osImages of all the nodes and store it in a file /opt/outputs/nodes_os_x43kj56.txt.
The osImages are under the nodeInfo section under status of each node. 
<details>
  <summary markdown="span">Answer</summary>

    root@controlplane:~# k get nodes -ocustom-columns=:.status.nodeInfo.osImage | xargs | tee /opt/outputs/nodes_os_x43kj56.txt
    Ubuntu 18.04.5 LTS
</details>

### 12) Create a Persistent Volume with the given specification.
Volume Name: pv-analytics
Storage: 100Mi
Access modes: ReadWriteMany
Host Path: /pv/data-analytics
<details>
  <summary markdown="span">Answer</summary>


kind: PersistentVolume
apiVersion:  v1
metadata: 
    name: pv-analytics
spec:
    accessModes: [ReadWriteMany]
    hostPath:
        path: "/pv/data-analytics"
    capacity: 
        storage: 100Mi

</details>

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
