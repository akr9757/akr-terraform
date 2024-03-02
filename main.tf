resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_route53_record" "www" {
  zone_id = "Z097978826RFVR2P0Q5DM"
  name    = "frontend-dev.akrdevopsb72.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.web.private_ip]
}