#This module creates the EC2 resources
locals {
  server_instance_profile = var.role == "dev" ? var.server_rw_instance_profile : var.server_read_instance_profile
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_ami" "amazon-linux-2" {

  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "bastian" {
  instance_type               = "t2.micro"
  ami                         = data.aws_ami.amazon-linux-2.id
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  security_groups             = [var.bastian_sg_id]
  key_name                    = var.aws_keypair
  iam_instance_profile        = var.bastion_instance_profile
  user_data                   = <<-EOF
                  #!/bin/bash
                  sudo yum update -y
                  useradd ${var.role}-user
                  usermod -aG wheel ${var.role}-user
                  echo "${var.role}-user ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
                  mkdir /home/${var.role}-user/.ssh/
                  aws s3 cp s3://${var.keystore_bucket}/${var.role}-user.pub /home/${var.role}-user/.ssh/authorized_keys
                  EOF
}

resource "aws_instance" "server" {
  instance_type        = "t2.micro"
  ami                  = data.aws_ami.amazon-linux-2.id
  subnet_id            = var.private_subnet_id
  security_groups      = [var.server_sg_id]
  key_name             = var.aws_keypair
  iam_instance_profile = local.server_instance_profile
  user_data            = <<-EOF
                  #!/bin/bash
                  sudo su
                  sudo yum update -y
                  sudo yum -y install httpd
                  echo "<p> Custom test goes here </p>" >> /var/www/html/index.html
                  sudo systemctl enable httpd
                  sudo systemctl start httpd
                  useradd ${var.role}-user
                  usermod -aG wheel ${var.role}-user
                  echo "${var.role}-user ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
                  mkdir /home/${var.role}-user/.ssh/
                  aws s3 cp s3://${var.keystore_bucket}/${var.role}-user.pub /home/${var.role}-user/.ssh/authorized_keys
                  EOF
}

resource "aws_iam_role" "bastionRole" {
  name               = "S3KeyAccess"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_role" "server_rw_Role" {
  name               = "S3EC2FullAccess"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_role" "server_read_Role" {
  name               = "S3ReadAccess"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "S3KeyAccess"
  role = aws_iam_role.bastionRole.name
}

resource "aws_iam_instance_profile" "server_rw_instance_profile" {
  name = "S3EC2FullAccess"
  role = aws_iam_role.server_rw_Role.name
}

resource "aws_iam_instance_profile" "server_read_instance_profile" {
  name = "S3ReadAccess"
  role = aws_iam_role.server_read_Role.name
}

resource "aws_iam_role_policy" "bastion_policy" {
  name   = "s3_key_policy"
  role   = aws_iam_role.bastionRole.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.keystore_bucket}",
        "arn:aws:s3:::${var.keystore_bucket}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "server_rw_policy" {
  name   = "s3_ec2_full_policy"
  role   = aws_iam_role.server_rw_Role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["s3:*"],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.keystore_bucket}",
        "arn:aws:s3:::${var.keystore_bucket}/*",
        "arn:aws:s3:::${var.team_project_bucket}",
        "arn:aws:s3:::${var.team_project_bucket}/*"
      ]
    },
    {
      "Action": ["ec2:*"],
      "Effect": "Allow",
      "Resource": ["*"]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "server_read_policy" {
  name   = "s3_read_policy"
  role   = aws_iam_role.server_read_Role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:List*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.keystore_bucket}",
        "arn:aws:s3:::${var.keystore_bucket}/*",
        "arn:aws:s3:::${var.team_project_bucket}",
        "arn:aws:s3:::${var.team_project_bucket}/*"
      ]
    }
  ]
}
EOF
}
