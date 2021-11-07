variable "aws_region" {
  type = string
}
variable "role" {
  type        = string
  description = "dev or test"
  validation {
    condition     = contains(["dev", "test"], var.role)
    error_message = "Argument \"role\" must be either \"dev\", or \"test\"."
  }
}
variable "project" {
  type = string
}

variable "owner_email" {
  type = string
}
variable "public_key_location" {
  type        = string
  description = "location for public key"
  sensitive   = true
}
variable "aws_keypair" {
  type = string
}
