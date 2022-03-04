terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.48.0"
    }
  }
  backend "azurerm" {
        resource_group_name  = "tfstate"
        storage_account_name = "tfstate29347"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
        access_key           = "MkfLt4z3AioiaotywWGlJBOU9Rx0nTeun0fMwFo0ur1tDS5kC2IkzYHRPo/FO4GyeqyoirOxTdWg+AStsFqo4Q=="
    }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "learnk8sResourceGroup-${var.env_name}"
  location = "northeurope"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name       = "${var.cluster_name}-${var.env_name}"
  location   = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix = "${var.cluster_name}-${var.env_name}"

  default_node_pool {
    name       = "default"
    node_count = "2"
    vm_size    = var.instance_type
  }
  identity {
    type = "SystemAssigned"
  }
  addon_profile {
    http_application_routing {
      enabled = true
    }
  }
}

data "azurerm_kubernetes_cluster" "credentials" {
  name                = azurerm_kubernetes_cluster.cluster.name
  resource_group_name = azurerm_resource_group.rg.name
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)

  }
}

resource "helm_release" "deployment" {

  name = "test-deployment"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  namespace  = "default"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "protocolHttp"
    value = "true"
  }

  set {
    name  = "service.externalPort"
    value = 80
  }

  set {
    name  = "replicaCount"
    value = 2
  }

  set {
    name  = "rbac.clusterReadOnlyRole"
    value = "true"
  }
}
