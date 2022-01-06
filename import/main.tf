provider "aws" {
  region     = var.region
}


resource "aws_vpc" "imported_vpc" {

  enable_dns_hostnames = true
  enable_dns_support   = true

lifecycle {
    ignore_changes = [tags]
  }

}
