
# MiniOps - Local Infrastructure Lab

## About This Project

I built this project to practice Linux, Docker, Kubernetes,
and Terraform on my local machine.

My goal was to understand how these tools work together,
test different scenarios, and learn how to troubleshoot
common infrastructure problems.

Everything runs locally using Ubuntu WSL2, Docker,
and a Kubernetes cluster created with kind.

## My Lab Environment

- Windows 10
- Ubuntu WSL2
- VS Code
- Docker Engine and Docker Compose
- kind and kubectl
- Kubernetes v1.37.0
- Terraform v1.17.1
- Nginx Alpine

## What I Practiced

### Linux
- Linux filesystem basics
- Shell commands
- Bash health-check script

### Docker
- Building and running container images
- Docker Compose
- Container networking
- Persistent volumes
- Backup and restore
- Healthchecks and troubleshooting

### Kubernetes
- Pods, Deployments, ReplicaSets and Services
- Scaling and self-healing
- Readiness and Liveness probes
- Rolling updates and rollback
- ConfigMaps and Secrets
- Secret rotation
- RBAC permissions
- Namespaces
- Separate Dev and Prod lab environments
- Kubernetes DNS and service discovery
- Logs and Events

### Terraform
- Infrastructure as Code basics
- Kubernetes Provider
- Using for_each
- terraform init, plan, apply and destroy
- Managing ConfigMaps in two namespaces
- Terraform State

## Kubernetes Lab Setup

Cluster: miniops

I tested the application in three environments:

| Namespace | Application | Replicas |
|-----------|-------------|----------|
| default | miniops-web v1.0 | 3 |
| miniops-dev | miniops-web v2.0 | 1 |
| miniops-prod | miniops-web v1.0 | 2 |

The production namespace is only a local training
environment, not a real production deployment.

## Useful Commands

Check the local cluster:

```bash
kind get clusters
kubectl get nodes
```

Check the two application environments:

```bash
kubectl get deployments,pods,svc -n miniops-dev
kubectl get deployments,pods,svc -n miniops-prod
```

Access the Dev application:

```bash
kubectl port-forward -n miniops-dev svc/miniops-web 8084:80
```

Access the Prod application in another terminal:

```bash
kubectl port-forward -n miniops-prod svc/miniops-web 8085:80
```

## Notes

- This is a single-node learning environment.
- The cluster runs locally, without cloud hosting.
- The two namespaces do not provide full network isolation.
- NetworkPolicy enforcement was not tested.
- CPU and memory metrics were unavailable because the
  Metrics API was not configured.
- The current app source contains v2.0. The original
  v1.0 image was built earlier and exists locally.
- Recreating the exact lab from scratch requires
  preserving the original v1.0 source or image.
- No real passwords or API credentials are used.

## Documentation

- [Docker Labs](docker/README.md)
- [Kubernetes Labs](kubernetes/README.md)
- [Terraform Labs](terraform/README.md)

## Project Goal

This project is my practical reference for infrastructure
and DevOps fundamentals. It documents the experiments
I completed, the commands I used, and the behavior
I observed during testing.
