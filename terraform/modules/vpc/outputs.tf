output "vpc_id" {
  value       = aws_vpc.cloud_homelab.id
  description = "ID of the cloud-homelab VPC."
}

output "vpc_cidr_block" {
  value       = aws_vpc.cloud_homelab.cidr_block
  description = "ID of the cloud-homelab VPC."
}