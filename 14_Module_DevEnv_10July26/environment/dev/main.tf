module "rg" {
  source = "../../child_module/Resource_Group"
  infy   = var.infy
}

module "vnetwork" {
  source     = "../../child_module/Virtual_Network"
  depends_on = [module.rg]
  infy-vnet  = var.infy-vnet

}

module "subnet" {
  source      = "../../child_module/Subnet"
  depends_on  = [module.vnetwork]
  infy-subnet = var.infy-subnet
}
