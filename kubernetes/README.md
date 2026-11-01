# MiniOps Kubernetes Infrastructure Lab

## Overview

A local Kubernetes lab built using kind, Docker,
kubectl, and Ubuntu WSL 2.

The lab demonstrates container orchestration,
service discovery, self-healing, health monitoring,
scaling, rolling updates, and rollback.

## Environment

- Windows 10
- Ubuntu WSL 2
- Docker Engine
- kind
- kubectl
- Kubernetes v1.37.0
- Nginx Alpine

## Architecture

- Cluster: miniops
- Node: miniops-control-plane
- Deployment: miniops-web
- Replicas: 3
- Service: miniops-web
- Service Type: ClusterIP
- Container Port: 80
- Current Image: miniops-web:1.0


### Additional Environments

I also created two separate namespaces:

| Namespace | Image | Replicas |
|-----------|-------|----------|
| miniops-dev | miniops-web:2.0 | 1 |
| miniops-prod | miniops-web:1.0 | 2 |

Each environment has its own Deployment,
ClusterIP Service and ConfigMap settings.


## Kubernetes Manifests

- deployment.yaml
- service.yaml
- readiness-test.yaml
- liveness-test.yaml
- configmap.yaml
- rbac-viewer.yaml
- environments.yaml
- environment-services.yaml

## Deployment Commands

```bash
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml

kubectl get deployments
kubectl get replicasets
kubectl get pods -o wide
kubectl get svc
```

## Service Access

```bash
kubectl port-forward svc/miniops-web 8083:80
```

Open: http://127.0.0.1:8083

## Self-Healing

Deleting a Deployment-managed Pod causes the
ReplicaSet to create a replacement.

## Readiness Probe

A deliberately failing readiness check returned
HTTP 404.

Observed:
- Container remained Running
- Pod became NotReady
- No container restart
- EndpointSlice reported ready=false

## Liveness Probe

A deliberately failing liveness check returned
HTTP 404.

Observed:
- Container restarted repeatedly
- Restart counter increased
- CrashLoopBackOff was observed

Both experiments used isolated test Pods,
which were deleted after testing.

## Scaling

Successfully scaled the Deployment:

3 replicas -> 5 replicas -> 3 replicas

## Rolling Update

Built and loaded miniops-web:2.0 into kind.

Updated the Deployment from v1.0 to v2.0.

Observed:
- A new ReplicaSet
- Gradual replacement of old Pods
- Successful rollout
- Three available replicas

## Rollback

Executed:

```bash
kubectl rollout undo deployment/miniops-web
```

Successfully restored miniops-web:1.0.

Verified:
- Deployment image: miniops-web:1.0
- All 3 Pods Ready
- Original application page restored


## ConfigMaps

I created a ConfigMap named miniops-config
to provide environment variables to the application.

I tested changing LOG_LEVEL from info to debug.

The ConfigMap was updated, but the existing
container kept the old environment variable.

After restarting the Deployment, the new Pods
loaded the updated value.

```bash
kubectl rollout restart deployment/miniops-web
kubectl rollout status deployment/miniops-web
```

## Secrets

I created a Kubernetes Secret using a dummy token.

The application loaded it through secretKeyRef.

I also tested Secret rotation:

- Updated the Secret value
- Verified the running container still had the old value
- Restarted the Deployment
- Confirmed the new Pods received the updated value

Only test credentials were used.

## RBAC

I created a ServiceAccount called miniops-viewer.

Using a Role and RoleBinding, I allowed it to
read Pods in the default namespace.

Test results:

- List Pods: Allowed
- Read Secrets: Forbidden
- Delete Pods: Denied
- List Pods in miniops-dev: Denied

This helped me understand the principle of
least privilege in Kubernetes.

## Namespaces

I created two namespaces:

- miniops-dev
- miniops-prod

Both environments use a ConfigMap called
miniops-settings, with different APP_MODE values.

Development uses development.
Production uses production.

The original application in the default
namespace was left unchanged.

## Service Discovery

I created a ClusterIP Service in each namespace.

I tested access to the Dev application using:

```bash
http://miniops-web
```

I also accessed the Prod Service from a Dev Pod:

```bash
http://miniops-web.miniops-prod.svc.cluster.local
```

Both requests succeeded.

This demonstrated Kubernetes DNS and
cross-namespace service communication.

Namespaces alone do not block network traffic.

## Monitoring and Troubleshooting

I checked application and cluster health using:

```bash
kubectl get pods
kubectl logs
kubectl get events
kubectl describe pod
kubectl get daemonsets -n kube-system
```

The Nginx logs showed successful HTTP 200
responses from Kubernetes health probes.

I also observed temporary readiness failures
and Pod sandbox recreation events.

All application Pods returned to Ready status.

I tested kubectl top, but the Metrics API
was not available in this local cluster.

NetworkPolicy enforcement was not tested.

## Lab Limitations

- Single-node kind cluster
- No node-level high availability
- No centralized monitoring system
- No production security hardening
- No verified NetworkPolicy isolation
- Local Docker images are not included in Git
- The current app source contains v2.0
- The original v1.0 image was built earlier

This is a hands-on learning environment,
not a production Kubernetes platform.


## Important Notes

- This is a single-node local learning cluster.
- Pod replicas do not provide node-level HA.
- Images are loaded locally into kind.
- Test Pods should not remain running.
- After rollback, keep local YAML synchronized
  with the intended Deployment state.
- The current application source contains v2.0
  changes, while the Deployment uses the
  previously built v1.0 image.
