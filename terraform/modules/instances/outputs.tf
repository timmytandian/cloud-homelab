output "k8s_instances_security_group_id" {
  value       = aws_security_group.kubernetes_instances.id
  description = "The security group ID of the Kubernetes instances"
}