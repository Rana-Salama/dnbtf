output "bastion_public_dns" {
  value = aws_instance.bastian.public_dns
}

output "server_address" {
  value = aws_instance.server.private_ip
}

output "bastion_instance_profile" {
  value = aws_iam_instance_profile.bastion_instance_profile.name
}

output "server_rw_instance_profile" {
  value = aws_iam_instance_profile.server_rw_instance_profile.name
}

output "server_read_instance_profile" {
  value = aws_iam_instance_profile.server_read_instance_profile.name
}
