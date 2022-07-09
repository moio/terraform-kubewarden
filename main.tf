module "k3d" {
  source = "./k3d"
}
module "kubewarden" {
  source      = "./kubewarden"
  credentials = module.k3d.credentials
}

