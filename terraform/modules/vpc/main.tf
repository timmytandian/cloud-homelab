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
  vpc_id               = aws_vpc.cloud_homelab.id
  cidr_block           = var.private_subnet_cidr
  availability_zone_id = var.subnet_az

  tags = {
    Name = "${var.project_name}-private-subnet"
  }
}

resource "aws_subnet" "cloud_homelab_public" {
  vpc_id               = aws_vpc.cloud_homelab.id
  cidr_block           = var.public_subnet_cidr
  availability_zone_id = var.subnet_az

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}


#################################################################
# Routing tables
#################################################################
resource "aws_route_table" "cloud_homelab_public" {
  vpc_id = aws_vpc.cloud_homelab.id

  # route traffic to the VPC CIDR block (e.g. 192.168.8.0/24) locally
  route {
    cidr_block = aws_vpc.cloud_homelab.cidr_block
    gateway_id = "local"
  }

  # route traffic to the Internet via Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloud_homelab.id
  }

  tags = {
    Name = "${var.project_name}-public-rtb"
  }
}

resource "aws_route_table" "cloud_homelab_private" {
  vpc_id = aws_vpc.cloud_homelab.id

  # route traffic to the VPC CIDR block (e.g. 192.168.8.0/24) locally
  route {
    cidr_block = aws_vpc.cloud_homelab.cidr_block
    gateway_id = "local"
  }

  # route traffic to the Internet to NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cloud_homelab.id
  }

  tags = {
    Name = "${var.project_name}-private-rtb"
  }
}

resource "aws_route_table_association" "cloud_homelab_public" {
  subnet_id      = aws_subnet.cloud_homelab_public.id
  route_table_id = aws_route_table.cloud_homelab_public.id
}

resource "aws_route_table_association" "cloud_homelab_private" {
  subnet_id      = aws_subnet.cloud_homelab_private.id
  route_table_id = aws_route_table.cloud_homelab_private.id
}

#################################################################
# ACL and associations
#################################################################

#################################################################
# Internet connectivity (NAT and Internet Gateway)
#################################################################
# Elastic IP address
resource "aws_eip" "cloud_homelab" {
  domain = "vpc"
}

resource "aws_internet_gateway" "cloud_homelab" {
  vpc_id = aws_vpc.cloud_homelab.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# A public NAT gateway to enable instances in private subnet to have internet access
resource "aws_nat_gateway" "cloud_homelab" {
  allocation_id = aws_eip.cloud_homelab.id
  subnet_id     = aws_subnet.cloud_homelab_private.id

  tags = {
    Name = "${var.project_name}-natgw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.cloud_homelab]
}

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

resource "aws_vpc_security_group_ingress_rule" "jumpbox_allow_ssh" {
  security_group_id = var.jumpbox_instances_security_group_id
  description       = "Allow all inbound SSH"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "jumpbox_allow_all_outbound" {
  security_group_id = var.jumpbox_instances_security_group_id
  description       = "Allow all outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
