terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 3.0"
  region  = "us-west-2"
}

resource "random_string" "rstring" {
  length  = 6
  lower   = true
  number  = false
  special = false
  upper   = false
}

module "acm" {
  source = "../../module"

  environment = "Production"
  fqdn_list   = ["${random_string.rstring.result}.mupo181ve1jco37.net"]

  tags = {
    hello = "world"
  }
}

module "self_signed" {
   source = "../../module"

  environment = "Production"
  self_signed = true
  fqdn_list   = ["self-signed-${random_string.rstring.result}.mupo181ve1jco37.net"]

  tags = {
    hello = "world"
  }
}
