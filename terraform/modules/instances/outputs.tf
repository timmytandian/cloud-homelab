output "k8s_instances_security_group_id" {
  value       = aws_security_group.kubernetes_instances.id
  description = "The security group ID of the Kubernetes instances"
}

output "admin_jumpbox_private_ip" {
  value       = aws_network_interface.admin_jumpbox.private_ip
  description = "Private IPv4 address of the network interface of the admin jumpbox host."
}

output "admin_jumpbox_public_ip" {
  value       = aws_instance.admin_jumpbox.public_ip
  description = "Public IPv4 address of the admin jumpbox host."
}