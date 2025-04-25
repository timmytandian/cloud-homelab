variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "cloud-homelab"
}

variable "vpc_id" {
  description = "ID of the VPC to deploy into"
  type        = string
}

variable "ec2_ami" {
  description = "The AMI image ID. Default to Debian-12 64-bit (x86)."
  type        = string
  default     = "ami-00a7d6f3b78d70c5a"
}

variable "admin_jumpbox_instance_type" {
  description = "Instance type for the admin jumpbox host. Default to t3a.micro (AMD-based x86 CPU)."
  type        = string
  default     = "t3a.micro"
}

variable "ssh_key_name" {
  description = "Name of the SSH key for instance access"
  type        = string
  default     = "aws-ec2-keypair"
}

variable "subnet_id" {
  description = "ID of the subnet to deploy into"
  type        = string
}