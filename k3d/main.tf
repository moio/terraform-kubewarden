terraform {
  required_providers {
    k3d = {
      source = "pvotal-tech/k3d"
      version = "0.0.6"
    }
  }
}

resource "k3d_cluster" "test" {
  name    = "test"
  servers = 1
  agents  = 0

  image   = "docker.io/rancher/k3s:v1.23.6-k3s1"

  k3d {
    disable_load_balancer     = true
  }

  kubeconfig {
    update_default_kubeconfig = true
    switch_current_context    = true
  }

  // https://github.com/kubernetes/kubernetes/issues/104459
  k3s {
    extra_args {
      arg          = "--disable=metrics-server"
    }
  }
}

output "test_credentials" {
  value = {
    internal_host = "k3d-test-server-0"
    internal_port = 6443
    external_host = "rancher.local.gd"
    external_port = 6443
    kubeconfig_host = k3d_cluster.test.credentials.0.host
    client_certificate = k3d_cluster.test.credentials.0.client_certificate
    client_key = k3d_cluster.test.credentials.0.client_key
    cluster_ca_certificate = k3d_cluster.test.credentials.0.cluster_ca_certificate
  }
}
