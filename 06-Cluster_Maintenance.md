# Cluster Maintenance
##Overview | Sections

### A) Cluster Upgrade Process
### B) Operating System Upgrades
### C) Backup & Restore Methodologies


## A) Cluster Upgrade Process

***Setup*** - Imagine you have a cluster with 1 Master Node, 3 Worker Nodes.
1) Worker Node A - Blue/Green Pods
2) Worker Node B - Blue/Purple Pods
3) Worker Node C - Red/Grey Pods

***Scenario*** - Worker Node A is taken down for maintenance. Blue Pod was part of a RS, so it will get rescheduled \
    - **But Green Pod was not part of a ReplicaSet, so it's just gone** \
    - Recall - Default Pod Eviction Timeout === 5 min

We want to be able to reschedule the Pods onto other nodes prior to taking down the Node for maintenance.



### kubectl drain [NODE]
1) Removes all Pods from a Node && Marks Node as "Unschedulable"
    - If API-Server supported - Evicts the Pods
    - If no API-Server support - Normal DELETE
    - Pods should be managed by "ReplicationController, ReplicaSet, Job, DaemonSet, or StatefulSet"
    - If trying to delete unmanaged Pods, use ***--force*** flag
2) Will not delete
    - ***Mirror Pods*** (Static Pod copies that live on API Server)
    - DaemonSet-managed Pods
        - Daemonset controller ignores "Unschedulable" Node markings, so it would reschedule immediately regardless
3) ***DaemonSet NOTE*** - If you have ds-managed pods on a node, use ***kubectl drain NODE --ignore-daemonsets***
    - Else ***kubectl drain*** will fail.


### kubectl cordon [NODE] // Marks a Node as "Unschedulable"
### kubectl uncordon [NODE] // Marks a Node as "Schedulable"

