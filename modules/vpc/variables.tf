variable "cidr" {
  type        = string
  description = "The CIDR block for VPC"
}

variable "public_subnet_cidr" {
  type        = string
  description = "The CIDR block for public subnet in which bastion host will be deployed"
}

variable "private_subnet_cidr" {
  type        = string
  description = "The CIDR block for private subnet, to host apache web server"
}

variable "vpc_id" {
  type        = string
  description = "Resource ID of the VPC"
}

variable "igw_id" {
  type        = string
  description = "Resource ID of the Internet gateway"
}

variable "public_subnet_id" {
  type        = string
  description = "public subnet"
}

variable "private_subnet_id" {
  type        = string
  description = "private subnet"
}

variable "nat_gatway_id" {
  type        = string
  description = "The NAT gateway"
}
