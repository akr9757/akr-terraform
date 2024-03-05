module "servers" {
  for_each = var.components

  source = "./module"
  componet_name = each.value["name"]
  password = lookup(each.value, "password" "null")
  env = var.env

}