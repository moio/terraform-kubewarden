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

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  chart            = "https://charts.jetstack.io/charts/cert-manager-v1.8.0.tgz"
  namespace        = "cert-manager"
  create_namespace = true
  set {
    name  = "installCRDs"
    value = true
  }
  wait_for_jobs    = true
}

resource "helm_release" "kubewarden-crds" {
  depends_on = [
    helm_release.cert-manager
  ]
  name             = "kubewarden-crds"
  chart            = "https://github.com/kubewarden/helm-charts/releases/download/kubewarden-crds-1.0.0/kubewarden-crds-1.0.0.tgz"
  namespace        = "kubewarden"
  create_namespace = true
}

resource "helm_release" "kubewarden-controller" {
  depends_on = [
    helm_release.kubewarden-crds
  ]
  name             = "kubewarden-controller"
  chart            = "https://github.com/kubewarden/helm-charts/releases/download/kubewarden-controller-1.0.0/kubewarden-controller-1.0.0.tgz"
  namespace        = "kubewarden"
  wait_for_jobs    = true
}

resource "helm_release" "kubewarden-defaults" {
  depends_on = [
    helm_release.kubewarden-controller
  ]
  name             = "kubewarden-defaults"
  chart            = "https://github.com/kubewarden/helm-charts/releases/download/kubewarden-defaults-1.0.1/kubewarden-defaults-1.0.1.tgz"
  namespace        = "kubewarden"
  wait_for_jobs    = true
}
