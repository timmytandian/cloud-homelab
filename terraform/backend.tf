terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-awsbackend"
    key            = "cloud-homelab/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-state-locking-awsbackend"
    encrypt        = true
  }
}