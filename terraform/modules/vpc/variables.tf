variable "vpc_cidr_block" {
  description = "CIDR block of the cloud-homelab VPC."
  type        = string
  default     = "192.168.8.0/24"
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "cloud-homelab"
}

variable "private_subnet_cidr" {
  description = "CIDR block of the private subnet (not accessible from the Internet)."
  type        = string
  default     = "192.168.8.0/27"
}

variable "public_subnet_cidr" {
  description = "CIDR block of the public subnet (accessible from the Internet)."
  type        = string
  default     = "192.168.8.128/27"
}

variable "allow_icmp" {
  description = "Set to true to allow ICMP ping."
  type        = bool
  default     = false
}

variable "k8s_instances_security_group_id" {
  description = "The security group ID of the Kubernetes instances"
  type        = string
}

variable "jumpbox_instances_security_group_id" {
  description = "The security group ID of the administrative jumpbox instance"
  type        = string
}