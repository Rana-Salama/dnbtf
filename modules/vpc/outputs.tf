output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "igw_id" {
  value = aws_internet_gateway.main.id
}

output "nat_gatway_id" {
  value = aws_nat_gateway.main.id
}

output "bastian_sg_id" {
  value = aws_security_group.public.id
}

output "server_sg_id" {
  value = aws_security_group.private.id
}
