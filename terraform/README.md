
# Terraform — MiniOps Local Lab

## Overview

This lab demonstrates Infrastructure as Code (IaC)
using Terraform and a local Kubernetes cluster
created with kind.

No paid cloud services are required.

## Environment

- Ubuntu on WSL2
- Terraform 1.17.1
- Kubernetes v1.37.0
- kind cluster: miniops
- Kubernetes provider: hashicorp/kubernetes

## What Was Implemented

Terraform was used to create two ConfigMaps:

- miniops-dev: APP_MODE=development
- miniops-prod: APP_MODE=production

Both resources were managed using the same
Terraform resource definition with for_each.

The existing application Deployments and Services
were not managed or modified by Terraform.

## Terraform Workflow

Run these commands from the repository root.

### Initialize

terraform -chdir=terraform init

### Format

terraform -chdir=terraform fmt

### Validate

terraform -chdir=terraform validate

### Preview Changes

terraform -chdir=terraform plan

### Create Resources

terraform -chdir=terraform apply

### Inspect State

terraform -chdir=terraform state list

### Preview Cleanup

terraform -chdir=terraform plan -destroy

### Remove Demo Resources

terraform -chdir=terraform destroy

## Verification Results

- Apply: 2 resources added
- Dev ConfigMap: development
- Prod ConfigMap: production
- State tracked both resources
- Destroy: 2 resources destroyed
- Final Terraform state: empty
- Application Deployments remained healthy

## Security Notes

- Terraform state files are excluded from Git.
- The .terraform directory is excluded from Git.
- The provider lock file is retained in Git.
- Local kubeconfig credentials must not be committed.
- No production credentials are used.

## Requirements

The Kubernetes cluster must exist and the
kind-miniops context must be available before
running Terraform.

## Status

Completed — local hands-on lab.
