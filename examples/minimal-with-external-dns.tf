terraform {
  required_version = ">= 0.12"
}

module "acm" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.12.0"

  environment = "Production"
  fqdn_list   = ["domain1.com"]

  tags = {
    hello = "world"
  }
}
