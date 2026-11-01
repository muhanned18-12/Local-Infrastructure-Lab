
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.4.0"
    }
  }
}

provider "kubernetes" {
  config_path    = pathexpand("~/.kube/config")
  config_context = "kind-miniops"
}

locals {
  environments = {
    dev  = "miniops-dev"
    prod = "miniops-prod"
  }
}

resource "kubernetes_config_map_v1" "demo" {
  for_each = local.environments

  metadata {
    name      = "miniops-terraform-demo"
    namespace = each.value

    labels = {
      managed-by = "terraform"
    }
  }

  data = {
    APP_MODE   = each.key == "dev" ? "development" : "production"
    MANAGED_BY = "terraform"
  }
}
