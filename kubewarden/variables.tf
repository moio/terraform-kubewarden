variable "credentials" {
  type = object({
    kubeconfig_host : string, client_certificate : string, client_key : string, cluster_ca_certificate : string
  })
}
