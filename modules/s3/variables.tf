variable "public_key_location" {
  type        = string
  description = "location for public key"
  sensitive   = true

}
variable "role" {
  type = string
}

variable "project" {
  type = string
}
