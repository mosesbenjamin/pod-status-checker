### [Ask](assets/task.md)

### Implementation
NB: Tested and guaranteed to work on MacOSX
Pre-requisite:
- Ensure make is installed so as to be able to run `make <target>`, for example
- Ensure docker is up and running

### Commands
- Run `make run_end_to_end` to bootstrap and deploy the application
- Run `make clean` to clean up

### Example output:
```
$ kubectl get jobs
NAME               COMPLETIONS   DURATION   AGE
check-pod-status   1/1           15s        29s

$ kubectl get pods             
NAME                     READY   STATUS      RESTARTS   AGE
check-pod-status-qww86   0/1     Completed   0          59s

$ kubectl logs check-pod-status-qww86 

                ########################################################
                Invalid POD_STATUS: None. Using default: Running.
                ########################################################
        
  No.  Namespace           Name                                                    Status
-----  ------------------  ------------------------------------------------------  --------
    1  kube-system         coredns-565d847f94-m27qk                                Running
    2  kube-system         coredns-565d847f94-wl2xp                                Running
    3  kube-system         etcd-check-pod-status-control-plane                     Running
    4  kube-system         kindnet-t7dvr                                           Running
    5  kube-system         kube-apiserver-check-pod-status-control-plane           Running
    6  kube-system         kube-controller-manager-check-pod-status-control-plane  Running
    7  kube-system         kube-proxy-2mbhd                                        Running
    8  kube-system         kube-scheduler-check-pod-status-control-plane           Running
    9  local-path-storage  local-path-provisioner-684f458cdd-gzz57                 Running
```