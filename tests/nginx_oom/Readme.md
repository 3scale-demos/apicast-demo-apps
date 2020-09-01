# Nginx OOM killer behaviour.

### Install

```
oc apply -f apicast.yaml
oc apply -f client.yaml
oc apply -f endpoint.yaml
```


### Test:

```
oc exec -ti heyclient -- /hey -z 1000s -c 500 "http://nginx-service:8080/?user_key=123"
```


### OOMKilled Debug:

```
Name:               nginx-11-8xl7n
Namespace:          eloy-mem-limits
Priority:           0
PriorityClassName:  <none>
Node:               ip-10-96-3-244.ec2.internal/10.96.3.244
Start Time:         Mon, 31 Aug 2020 15:36:25 +0200
Labels:             app=nginx
                    deployment=nginx-11
                    deploymentconfig=nginx
                    name=nginx
Annotations:        k8s.v1.cni.cncf.io/networks-status=[{
    "name": "openshift-sdn",
    "interface": "eth0",
    "ips": [
        "10.128.5.223"
    ],
    "dns": {},
    "default-route": [
        "10.128.4.1"
    ]
...
                openshift.io/deployment-config.latest-version=11
                openshift.io/deployment-config.name=nginx
                openshift.io/deployment.name=nginx-11
                openshift.io/scc=restricted
Status:         Running
IP:             10.128.5.223
Controlled By:  ReplicationController/nginx-11
Containers:
  gateway:
    Container ID:  cri-o://ca911d7014e5c174ffaff64c1819a4f0cece3fae6bdd9c77598abd38259add42
    Image:         eloycoto/nginx:latest
    Image ID:      docker.io/eloycoto/nginx@sha256:9fd7c5e02935dd60787ac99514d50051b3afe3b5bec61d514b07dcdb404f3c8b
    Port:          8080/TCP
    Host Port:     0/TCP
    Command:
      /nginx/objs/nginx
    Args:
      -c
      /gateway/nginx.conf
      -p
      /var/run/nginx/
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       OOMKilled
      Exit Code:    137
      Started:      Tue, 01 Sep 2020 11:34:55 +0200
      Finished:     Tue, 01 Sep 2020 11:35:33 +0200
    Ready:          False
    Restart Count:  5
    Limits:
      memory:  30Mi
    Requests:
      memory:     20Mi
    Environment:  <none>
    Mounts:
      /gateway from config-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-cknbl (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  config-volume:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      nginx-config
    Optional:  false
  default-token-cknbl:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-cknbl
    Optional:    false
QoS Class:       Burstable
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/memory-pressure:NoSchedule
                 node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason   Age                From                                  Message
  ----     ------   ----               ----                                  -------
  Normal   Pulling  5m (x6 over 20h)   kubelet, ip-10-96-3-244.ec2.internal  Pulling image "eloycoto/nginx:latest"
  Normal   Pulled   5m (x6 over 20h)   kubelet, ip-10-96-3-244.ec2.internal  Successfully pulled image "eloycoto/nginx:latest"
  Normal   Created  5m (x5 over 20h)   kubelet, ip-10-96-3-244.ec2.internal  Created container gateway
  Normal   Started  5m (x5 over 20h)   kubelet, ip-10-96-3-244.ec2.internal  Started container gateway
  Warning  BackOff  3m (x11 over 12m)  kubelet, ip-10-96-3-244.ec2.internal  Back-off restarting failed container
```
