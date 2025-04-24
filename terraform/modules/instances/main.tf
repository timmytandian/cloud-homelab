
# Security group for all instances
resource "aws_security_group" "kubernetes_instances" {
  name        = "${var.project_name}-k8s-sg"
  description = "Security group for the Kubernetes nodes in my cloud-homelab."
  vpc_id      = var.vpc_id

}

/*
# Admin/Control instance
resource "aws_instance" "admin" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.admin_instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.homelab_sg.id]
  subnet_id              = var.subnet_id

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "${var.project_name}-admin"
    Role = "admin"
  }
}

# Kubernetes control plane
resource "aws_instance" "control" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.control_instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.homelab_sg.id]
  subnet_id              = var.subnet_id

  root_block_device {
    volume_size = 50
  }

  tags = {
    Name = "${var.project_name}-control"
    Role = "k8s-control"
  }
}

# Kubernetes worker nodes
resource "aws_instance" "workers" {
  count                  = var.worker_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.worker_instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.homelab_sg.id]
  subnet_id              = var.subnet_id

  root_block_device {
    volume_size = 100
  }

  tags = {
    Name = "${var.project_name}-worker-${count.index + 1}"
    Role = "k8s-worker"
  }
}

# Get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
*/