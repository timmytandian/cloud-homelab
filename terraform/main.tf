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
  source                      = "./modules/instances"
  ec2_ami                     = var.ec2_ami
  vpc_id                      = module.vpc.vpc_id
  project_name                = var.project_name
  subnet_id                   = module.vpc.public_subnet_id
  ssh_key_name                = var.ssh_key_name
  admin_jumpbox_instance_type = var.admin_jumpbox_instance_type
  /*
  control_instance_type = var.control_instance_type
  worker_instance_type  = var.worker_instance_type
  worker_count          = var.worker_count
  */
}

module "vpc" {
  source                              = "./modules/vpc"
  project_name                        = var.project_name
  vpc_cidr_block                      = "192.168.8.0/24"
  private_subnet_cidr                 = "192.168.8.0/27"
  public_subnet_cidr                  = "192.168.8.128/27"
  allow_icmp                          = true
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