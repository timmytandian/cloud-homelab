variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}

# VPC
variable "vpc_cidr_block" {
  description = "CIDR block of the cloud-homelab VPC."
  type        = string
  default     = "192.168.8.0/24"
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


# Instance
variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
  default     = "cloud-homelab"
}

/*

variable "subnet_id" {
  description = "ID of the subnet to deploy into"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the SSH key for instance access"
  type        = string
}

variable "admin_instance_type" {
  description = "Instance type for the admin node"
  type        = string
  default     = "t3.medium"
}

variable "control_instance_type" {
  description = "Instance type for the Kubernetes control plane"
  type        = string
  default     = "t3.medium"
}

variable "worker_instance_type" {
  description = "Instance type for the Kubernetes worker nodes"
  type        = string
  default     = "t3.large"
}

variable "worker_count" {
  description = "Number of worker nodes to deploy"
  type        = number
  default     = 2
}
*/