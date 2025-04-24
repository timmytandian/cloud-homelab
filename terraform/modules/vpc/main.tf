#################################################################
# Main VPC and subnets
#################################################################
resource "aws_vpc" "cloud_homelab" {
  cidr_block = var.vpc_cidr_block
  
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "cloud_homelab_private" {
  vpc_id     = aws_vpc.cloud_homelab.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "${var.project_name}-private-subnet"
  }
}

resource "aws_subnet" "cloud_homelab_public" {
  vpc_id     = aws_vpc.cloud_homelab.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}


#################################################################
# Routing tables
#################################################################

#################################################################
# ACL and associations
#################################################################

#################################################################
# Internet connectivity (NAT and Internet Gateway)
#################################################################

#################################################################
# Security group rules
#################################################################
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = var.k8s_instances_security_group_id
  description       = "Allow all inbound HTTP"
  cidr_ipv4         = aws_vpc.cloud_homelab.cidr_block
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = var.k8s_instances_security_group_id
  description       = "Allow all inbound HTTPS"
  cidr_ipv4         = aws_vpc.cloud_homelab.cidr_block
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = var.k8s_instances_security_group_id
  description       = "Allow all inbound SSH"
  cidr_ipv4         = aws_vpc.cloud_homelab.cidr_block
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_kubernetes_api" {
  security_group_id = var.k8s_instances_security_group_id
  description       = "Allow all inbound Kubernetes API"
  cidr_ipv4         = aws_vpc.cloud_homelab.cidr_block
  ip_protocol       = "tcp"
  from_port         = 6443
  to_port           = 6443
}

resource "aws_vpc_security_group_ingress_rule" "allow_icmp" {
  count             = var.allow_icmp ? 1 : 0
  security_group_id = var.k8s_instances_security_group_id
  description       = "Allow ICMP ping"
  cidr_ipv4         = aws_vpc.cloud_homelab.cidr_block
  ip_protocol       = "icmp"
  # from port 8 to port 0 correspond to Echo request (type 8, code 0)
  from_port = 8
  to_port   = 0
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = var.k8s_instances_security_group_id
  description       = "Allow all outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}