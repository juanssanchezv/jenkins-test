provider "aws" {
  default_tags {
    tags = {
      "Name"        = var.owner
      "ServiceName" = var.service_name
      "Provisioner" = "Terraform"
    }
  }

}