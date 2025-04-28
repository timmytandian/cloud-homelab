#################################################################
# Security groups and SSH
#################################################################
# Security group for all instances
resource "aws_security_group" "kubernetes_instances" {
  name        = "${var.project_name}-k8s-sg"
  description = "Security group for the Kubernetes nodes in my cloud-homelab."
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "admin_jumpbox" {
  name        = "${var.project_name}-jumpbox-sg"
  description = "Security group for the administrative jumpbox in my cloud-homelab."
  vpc_id      = var.vpc_id
}

# SSH keypair
data "aws_key_pair" "cloud_homelab" {
  key_name = var.ssh_key_name
}

#################################################################
# SSM Parameter store (to store Tailscale auth key) and related IAM permissions
#################################################################
resource "aws_ssm_parameter" "tailscale_auth_key" {
  name        = "/ec2/tailscale-auth-key"
  description = "The authentication key to join Tailnet"
  type        = "SecureString"
  value       = var.tailscale_auth_key
}

# IAM role for EC2 instance
resource "aws_iam_role" "tailscale_auth_key" {
  name = "ec2-access-ssm-parameter-store"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy document to allow access to the specific SSM parameter
data "aws_iam_policy_document" "tailscale_auth_key" {
  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = [
      aws_ssm_parameter.tailscale_auth_key.arn
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "kms:Decrypt"
    ]
    resources = ["*"] # More restrictive KMS key ARN should be used in production
    effect    = "Allow"
  }
}

# IAM policy for SSM parameter access
resource "aws_iam_policy" "tailscale_auth_key" {
  name        = "access-ssm-parameter-store-tailscale-auth-key"
  description = "Policy to allow EC2 access to SSM parameters storing Tailscale auth key"
  policy      = data.aws_iam_policy_document.tailscale_auth_key.json
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "tailscale_auth_key" {
  role       = aws_iam_role.tailscale_auth_key.name
  policy_arn = aws_iam_policy.tailscale_auth_key.arn
}

# Create EC2 instance profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-access-ssm-parameter-store"
  role = aws_iam_role.tailscale_auth_key.name
}

#################################################################
# Administrative jumpbox instance
#################################################################
resource "aws_instance" "admin_jumpbox" {
  ami                         = var.ec2_ami
  instance_type               = var.admin_jumpbox_instance_type
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.admin_jumpbox.id]
  subnet_id                   = var.admin_jumpbox_subnet_id
  associate_public_ip_address = var.is_admin_jumpbox_subnet_public ? true : false
  root_block_device {
    volume_size = 8
  }
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = templatefile("${path.root}/scripts/install-tailscale.sh", {
    nat_gateway_id = var.nat_gateway_id # the NAT Gateway ID is required to make sure it is created before this instance
  })

  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }

  tags = {
    Name = "${var.project_name}-admin-jumpbox"
  }
}

resource "aws_eip" "admin_jumpbox" {
  # create elastic IP only if the jumpbox machine is placed in public subnet
  count = var.is_admin_jumpbox_subnet_public ? 1 : 0

  instance = aws_instance.admin_jumpbox.id
  domain   = "vpc"
}

data "aws_network_interface" "admin_jumpbox" {
  id = aws_instance.admin_jumpbox.primary_network_interface_id
}

#################################################################
# Kubernetes control plane instance
#################################################################
resource "aws_instance" "control" {
  ami                         = var.ec2_ami
  instance_type               = var.control_plane_instance_type
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.kubernetes_instances.id]
  subnet_id                   = var.cluster_subnet_id
  associate_public_ip_address = false
  root_block_device {
    volume_size = 8
  }

  /*
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = templatefile("${path.root}/scripts/install-tailscale.sh", {
    nat_gateway_id = var.nat_gateway_id # the NAT Gateway ID is required to make sure it is created before this instance
  })
  */

  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }

  tags = {
    Name = "${var.project_name}-control-plane"
  }
}

data "aws_network_interface" "control" {
  id = aws_instance.control.primary_network_interface_id
}

#################################################################
# Kubernetes worker node instance
#################################################################
resource "aws_instance" "worker" {
  ami                         = var.ec2_ami
  instance_type               = var.worker_node_instance_type
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.kubernetes_instances.id]
  subnet_id                   = var.cluster_subnet_id
  associate_public_ip_address = false
  root_block_device {
    volume_size = 8
  }

  /*
  user_data = templatefile("${path.root}/scripts/install-tailscale.sh", {
    nat_gateway_id = var.nat_gateway_id # the NAT Gateway ID is required to make sure it is created before this instance
  })
  */

  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }

  tags = {
    Name = "${var.project_name}-worker"
  }
}

data "aws_network_interface" "worker" {
  id = aws_instance.control.primary_network_interface_id
}