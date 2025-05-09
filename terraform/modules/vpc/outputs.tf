output "vpc_id" {
  value       = aws_vpc.cloud_homelab.id
  description = "ID of the cloud-homelab VPC."
}

output "vpc_cidr_block" {
  value       = aws_vpc.cloud_homelab.cidr_block
  description = "ID of the cloud-homelab VPC."
}

output "private_subnet_id" {
  value       = aws_subnet.cloud_homelab_private.id
  description = "ID of the private subnet."
}

output "public_subnet_id" {
  value       = aws_subnet.cloud_homelab_public.id
  description = "ID of the public subnet."
}

output "subnet_az" {
  value       = aws_subnet.cloud_homelab_private.availability_zone
  description = "The availability zone of this subnet."
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.cloud_homelab.id
  description = "The ID of NAT Gateway to enable outbound internet connection for hosts in private subnet."
}