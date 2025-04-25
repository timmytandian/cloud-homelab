output "vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
  description = "the CIDR block of the cloud-homelab VPC."
}

output "admin_jumpbox_private_ip" {
  value       = module.instances.admin_jumpbox_private_ip
  description = "Private IPv4 address of the network interface of the admin jumpbox host."
}

output "admin_jumpbox_public_ip" {
  value       = module.instances.admin_jumpbox_public_ip
  description = "Public IPv4 address of the admin jumpbox host."
}