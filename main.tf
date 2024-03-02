resource "aws_instance" "instance" {
  for_each = var.components
  ami           = data.aws_ami.ami.id
  instance_type = each.value["instance_type"]
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  tags = {
    Name = each.value["name"]
  }
}


resource "aws_route53_record" "www" {
  for_each = var.components
  zone_id = "Z097978826RFVR2P0Q5DM"
  name    = "${each.value["name"]}-dev.akrdevopsb72.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance[each.value["name"]].private_ip]
}

variable "components" {
  default = {
    frontend = {
      name          = "frontend"
      instance_type = "t3.micro"
    }
    catalogue = {
      name          = "catalogue"
      instance_type = "t3.micro"
    }
    cart = {
      name          = "cart"
      instance_type = "t3.micro"
    }
    user = {
      name          = "user"
      instance_type = "t3.micro"
    }
    shipping = {
      name          = "shipping"
      instance_type = "t3.micro"
    }
    payment = {
      name          = "payment"
      instance_type = "t3.micro"
    }
    dispatch = {
      name          = "dispatch"
      instance_type = "t3.micro"
    }
    mongodb = {
      name          = "mongodb"
      instance_type = "t3.micro"
    }
    redis = {
      name          = "redis"
      instance_type = "t3.micro"
    }
    mysql = {
      name          = "mysql"
      instance_type = "t3.micro"
    }
    rabbitmq = {
      name          = "rabbitmq"
      instance_type = "t3.micro"
    }
  }
}