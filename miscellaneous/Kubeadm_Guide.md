# KubeAdm Guide

## Main Commands
    alpha       Kubeadm experimental sub-commands
    completion  Output shell completion code for the specified shell (bash or zsh)
    config      Manage configuration for a kubeadm cluster persisted in a ConfigMap in the cluster
    help        Help about any command
    init        Run this command in order to set up the Kubernetes control plane
    join        Run this on any machine you wish to join an existing cluster
    reset       Performs a best effort revert of changes made to this host by 'kubeadm init' or 'kubeadm join'
    token       Manage bootstrap tokens
    upgrade     Upgrade your cluster smoothly to a newer version with this command
    version     Print the version of kubeadm


## Global Flags
      --add-dir-header           If true, adds the file directory to the header of the log messages
      --log-file string          If non-empty, use this log file
      --log-file-max-size uint   Defines the maximum size a log file can grow to. Unit is megabytes. If the value is 0, the maximum file size is unlimited. (default 1800)
      --rootfs string            [EXPERIMENTAL] The path to the 'real' host root filesystem.
      --skip-headers             If true, avoid header prefixes in the log messages
      --skip-log-headers         If true, avoid headers when opening log files
      -v, --v Level                  number for the log level verbosity



## 
kubeadm config print init-defaults
