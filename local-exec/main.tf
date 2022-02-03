terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws        = ">= 3.22.0"
    local      = ">= 1.4"
    random     = ">= 2.1"
    null       = ">= 3.0.0"
  }
}

provider "aws" {
  region     = var.region 
}



data "aws_vpc" "aws_vpc_dns" {
  id = var.vpc_id
}

resource "null_resource" "aws_vpc_dns_local" {
  provisioner "local-exec" {
    command = <<EOT
    if  [ $dnssupport != "true" ]; then aws ec2 modify-vpc-attribute --vpc-id ${data.aws_vpc.aws_vpc_dns.id} --enable-dns-support; fi
    if  [ $dnshostnames != "true" ]; then aws ec2 modify-vpc-attribute --vpc-id ${data.aws_vpc.aws_vpc_dns.id} --enable-dns-hostnames; fi
       EOT
    environment = {
  dnssupport= data.aws_vpc.aws_vpc_dns.enable_dns_support
  dnshostnames = data.aws_vpc.aws_vpc_dns.enable_dns_hostnames
    }
  }
}
