module "rg" {
  source = "../../module/azure_resource_group"
  infy   = var.infy-lab
}

module "vnet" {
  depends_on = [module.rg]
  source     = "../../module/azure_virtual_network"
  infy-vnet  = var.infy-lab-vnet

}

module "subnet" {
  depends_on  = [module.vnet]
  source      = "../../module/azure_subnet"
  infy-subnet = var.infy-lab-subnet
}

module "pubic_ip" {
  depends_on = [module.rg]
  source     = "../../module/azure_public_ip"
  public_ips = var.infy-lab-public_ips
}

module "vm" {
  depends_on = [module.subnet, module.pubic_ip]
  source     = "../../module/azure_virtual_machine"
  vms        = var.infy-lab-vms
}