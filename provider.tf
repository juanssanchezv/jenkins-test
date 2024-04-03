provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "Name"        = var.owner
      "ServiceName" = var.service_name
      "Provisioner" = "Terraform"
      "bootcamp"    = "devops"
    }
  }

}