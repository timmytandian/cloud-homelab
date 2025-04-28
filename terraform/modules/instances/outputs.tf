output "k8s_instances_security_group_id" {
  value       = aws_security_group.kubernetes_instances.id
  description = "The security group ID of the Kubernetes instances."
}

output "jumpbox_instances_security_group_id" {
  value       = aws_security_group.admin_jumpbox.id
  description = "The security group ID of the administrative jumpbox instance."
}

output "admin_jumpbox_private_ip" {
  value       = data.aws_network_interface.admin_jumpbox.private_ip
  description = "Private IPv4 address of the network interface of the admin jumpbox host."
}

output "admin_jumpbox_public_ip" {
  value       = length(aws_eip.admin_jumpbox) > 0 ? aws_eip.admin_jumpbox[0].public_ip : "null"
  description = "Public IPv4 address of the admin jumpbox host."
}

output "control_plane_private_ip" {
  value       = data.aws_network_interface.control.private_ip
  description = "Private IPv4 address of the network interface of the Kubernetes control plane node."
}

output "worker_node_private_ip" {
  value       = data.aws_network_interface.worker.private_ip
  description = "Private IPv4 address of the network interface of the Kubernetes workers node."
}

output "tailscale_auth_key_ssm_name" {
  value       = aws_ssm_parameter.tailscale_auth_key.name
  description = "The name of SSM parameter store holding the Tailscale authentication key (secure string)"
}