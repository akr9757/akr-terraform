locals {
  name = var.env != "" ? "${var.component_name}-${var.env}" : var.component_name
  db_commands = [
    "rm -rf akr-shell",
    "git clone https://github.com/akr9757/akr-shell.git",
    "cd akr-shell",
    "sudo bash ${var.component_name}.sh ${var.password}"
  ]
  app_commands = [
    "sudo labauto ansible",
    "ansible-pull -i localhost, -U https://github.com/akr9757/akr-ansible.git roboshop.yml -e ansible_user-centos -e ansible_password=DevOps321 -e env=${var.env} -e role_name=${var.component_name}"
  ]
}