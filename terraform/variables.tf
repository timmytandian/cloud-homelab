variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}

# VPC
variable "subnet_az" {
  description = "The availability zone ID of the VPC subnet (single AZ)"
  type        = string
  default     = "apne1-az2"
}

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

variable "ec2_ami" {
  description = "The AMI image ID. Default to Debian-12 64-bit (x86)."
  type        = string
  default     = "ami-00a7d6f3b78d70c5a"
}

variable "ssh_key_name" {
  description = "Name of the SSH key for instance access"
  type        = string
  default     = "aws-ec2-keypair"
}

variable "admin_jumpbox_instance_type" {
  description = "Instance type for the admin jumpbox host. Default to t3a.micro (AMD-based x86 CPU)."
  type        = string
  default     = "t3a.micro"
}

variable "control_plane_instance_type" {
  description = "Instance type for the control plane node. Default to t3a.micro (AMD-based x86 CPU)."
  type        = string
  default     = "t3a.micro"
}

variable "worker_node_instance_type" {
  description = "Instance type for the worker node. Default to t3a.micro (AMD-based x86 CPU)."
  type        = string
  default     = "t3a.micro"
}

variable "tailscale_auth_key" {
  description = "The authentication key to join Tailnet."
  type        = string
  sensitive   = true
}