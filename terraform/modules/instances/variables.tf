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

variable "ssh_key_name" {
  description = "Name of the SSH key for instance access."
  type        = string
  default     = "aws-ec2-keypair"
}

variable "admin_jumpbox_subnet_id" {
  description = "ID of the subnet to deploy the administrative jumpbox machine into."
  type        = string
}

variable "cluster_subnet_id" {
  description = "ID of the subnet to deploy the kubernetes cluster."
  type        = string
}

variable "is_admin_jumpbox_subnet_public" {
  description = "Whether the administrative jumpbox machine is placed in public subnet or not. Set to true to place in public subnet, false to place in private subnet."
  type        = bool
  default     = true
}

variable "nat_gateway_id" {
  description = "The ID of NAT Gateway to enable outboud internet access for hosts in private subnet."
  type        = string
}

variable "tailscale_auth_key" {
  description = "The authentication key to join Tailnet."
  type        = string
  sensitive   = true
}