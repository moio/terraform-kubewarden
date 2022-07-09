terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = var.credentials.kubeconfig_host
    client_certificate     = var.credentials.client_certificate
    client_key             = var.credentials.client_key
    cluster_ca_certificate = var.credentials.cluster_ca_certificate
  }
}

resource "helm_release" "kubewarden-palindrome-policy" {
  name             = "kubewarden-palindrome-policy"
  chart            = "./charts/kubewarden-palindrome-policy"
}
