module "k3d" {
  source = "./k3d"
}
module "kubewarden" {
  source      = "./kubewarden"
  credentials = module.k3d.credentials
}

module "kubewarden-palindrome-policy" {
  source      = "./kubewarden-palindrome-policy"
  credentials = module.k3d.credentials
}
