module "rg" {
  source = "../child_module/Resource_Group"
  infy   = var.tpg-rg
}

module "vnetwork" {
  source     = "../child_module/Virtual_Network"
  depends_on = [module.rg]
  infy-vnet  = var.tpg-vnet

}

module "subnet" {
  source      = "../child_module/Subnet"
  depends_on  = [module.vnetwork]
  infy-subnet = var.tpg-subnet
}