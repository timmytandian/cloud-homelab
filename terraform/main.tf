provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project   = "cloud-homelab"
      managedBy = "terraform"
    }
  }
}

module "instances" {
  # general
  source       = "./modules/instances"
  ec2_ami      = var.ec2_ami
  project_name = var.project_name

  # networking
  vpc_id            = module.vpc.vpc_id
  cluster_subnet_id = module.vpc.private_subnet_id
  nat_gateway_id    = module.vpc.nat_gateway_id
  ssh_key_name      = var.ssh_key_name

  # admin jumpbox
  is_admin_jumpbox_subnet_public = false
  admin_jumpbox_subnet_id        = module.vpc.private_subnet_id
  admin_jumpbox_instance_type    = var.admin_jumpbox_instance_type
  tailscale_auth_key             = var.tailscale_auth_key

  # Kubernetes control plane
  control_plane_instance_type = var.control_plane_instance_type

  # Kubernetes workers node
  worker_node_instance_type = var.worker_node_instance_type
}

module "vpc" {
  # general
  source       = "./modules/vpc"
  project_name = var.project_name

  # vpc and networking
  vpc_cidr_block      = "192.168.8.0/24"
  private_subnet_cidr = "192.168.8.0/27"
  public_subnet_cidr  = "192.168.8.128/27"
  subnet_az           = var.subnet_az
  allow_icmp          = true

  # instances
  k8s_instances_security_group_id     = module.instances.k8s_instances_security_group_id
  jumpbox_instances_security_group_id = module.instances.jumpbox_instances_security_group_id
}

/*
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/hosts.ini.tpl", {
    admin_ip    = module.aws_instances.admin_instance_ip
    control_ip  = module.aws_instances.control_instance_ip
    worker_ips  = module.aws_instances.worker_instance_ips
  })
  filename = "${path.root}/../ansible/inventory/hosts.ini"
}
*/