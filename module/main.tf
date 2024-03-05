resource "aws_instance" "instance" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  tags = {
    Name = local.name
  }
}

resource "null_resource" "provisioner" {
  depends_on = [aws_instance.instance, aws_route53_record.record]

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.instance.private_ip
    }

    inline = [
      "rm -rf akr-shell",
      "git clone https://github.com/akr9757/akr-shell.git",
      "cd akr-shell",
      "sudo bash ${var.component_name}.sh ${var.password}"
    ]
  }
}

resource "aws_route53_record" "record" {
  zone_id = "Z097978826RFVR2P0Q5DM"
  name    = "{var.component_name}-dev.akrdevopsb72.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}

