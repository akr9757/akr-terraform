module "database_servers" {
  for_each = var.database_servers

  source = "./module"
  component_name = each.value["name"]
  instance_type = each.value["instance_type"]
  password = lookup(each.value, "password", "null")
  env = var.env
  provisioner = true
}

module "app_servers" {
  for_each = var.app_servers

  source = "./module"
  component_name = each.value["name"]
  instance_type = each.value["instance_type"]
  password = lookup(each.value, "password", "null")
  env = var.env
}