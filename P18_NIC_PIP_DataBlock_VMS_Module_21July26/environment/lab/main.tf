module "rg" {
  source = "../../module/azure_resource_group"
  infy   = var.infy
}

module "vnet" {
  depends_on = [module.rg]
  source     = "../../module/azure_virtual_network"
  infy-vnet  = var.infy-vnet

}

module "subnet" {
  depends_on  = [module.vnet]
  source      = "../../module/azure_subnet"
  infy-subnet = var.infy-subnet
}

module "pubic_ip" {
  depends_on = [module.rg]
  source     = "../../module/azure_public_ip"
  public_ips = var.public_ips
}

module "vm" {
  depends_on = [module.subnet, module.pubic_ip]
  source     = "../../module/azure_virtual_machine"
  vms        = var.vms
}