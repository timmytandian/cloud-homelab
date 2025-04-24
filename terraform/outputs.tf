output "vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
  description = "the CIDR block of the cloud-homelab VPC."
}