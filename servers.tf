module "servers" {
  for_each = var.components

  source = "./module"
  component_name = each.value["name"]
  password = lookup(each.value, "password", "null")
  env = var.env

}