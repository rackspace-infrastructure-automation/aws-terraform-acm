provider "aws" {
  region  = "us-west-2"
  version = "~> 2.7"
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
