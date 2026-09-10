module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = var.vpc_id
}
