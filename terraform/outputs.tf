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

output "control_plane_private_ip" {
  value       = module.instances.control_plane_private_ip
  description = "Private IPv4 address of the network interface of the Kubernetes control plane node."
}

output "worker_node_private_ip" {
  value       = module.instances.worker_node_private_ip
  description = "Private IPv4 address of the network interface of the Kubernetes workers node."
}

output "subnet_az" {
  value       = module.vpc.subnet_az
  description = "The availability zone where our workload is placed (single AZ)."
}