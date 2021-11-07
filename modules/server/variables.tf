variable "public_subnet_id" {
  type        = string
  description = "The Resource ID for the public subnet"
}

variable "bastian_sg_id" {
  type        = string
  description = "The Resource ID for the public security group"
}

variable "private_subnet_id" {
  type        = string
  description = "The Resource ID for the private subnet"
}

variable "server_sg_id" {
  type        = string
  description = "The Resource ID for the private security group"
}

variable "role" {
  type        = string
  description = "The role of the user"
}

variable "keystore_bucket" {
  type = string
}

variable "server_rw_instance_profile" {
  type = string
}

variable "server_read_instance_profile" {
  type = string
}

variable "bastion_instance_profile" {
  type = string
}

variable "aws_keypair" {
  type = string
}

variable "project" {
  type = string
}

variable "team_project_bucket" {
  type = string
}
