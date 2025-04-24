variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "cloud-homelab"
}

variable "vpc_id" {
  description = "ID of the VPC to deploy into"
  type        = string
}