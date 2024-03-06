resource "aws_instance" "instance" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.sg.id]
  iam_instance_profile = aws_iam_instance_profile.profile.name

  tags = {
    Name = local.name
  }
}

resource "null_resource" "provisioner" {
  depends_on = [aws_instance.instance, aws_route53_record.record]
  triggers = {
    private_ip = aws_instance.instance.private_ip
  }

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.instance.private_ip
    }

    inline = var.app_type == "db" ? local.db_commands : local.app_commands
  }
}

resource "aws_route53_record" "record" {
  zone_id = "Z097978826RFVR2P0Q5DM"
  name    = "${var.component_name}-dev.akrdevopsb72.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.component_name}-${var.env}-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "${var.component_name}-${var.env}-role"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.component_name}-${var.env}-role"
  }
}

resource "aws_iam_role_policy" "ssm-policy" {
  name = "${var.component_name}-${var.env}-ssm-policy"
  role = aws_iam_role.role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
          "kms:Decrypt",
          "ssm:GetParameterHistory",
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        "Resource": [
          "arn:aws:kms:us-east-1:533267186768:key/9db6e5b8-e64c-43c7-812d-1ac2773fe84e",
          "arn:aws:ssm:us-east-1:533267186768:parameter/${var.component_name}-${var.env}.*"
        ]
      },
      {
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": "ssm:DescribeParameters",
        "Resource": "*"
      }
    ]
  })
}


