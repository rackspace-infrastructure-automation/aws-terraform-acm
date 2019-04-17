provider "aws" {
  region = "us-west-2"
}

resource "random_string" "rstring" {
  length  = 6
  lower   = true
  upper   = false
  number  = false
  special = false
}

module "acm" {
  source = "../../module"

  domain      = "${random_string.rstring.result}.mupo181ve1jco37.net"
  environment = "Production"

  custom_tags = {
    hello = "world"
  }
}
