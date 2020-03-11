module "acm" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.2"

  environment = "Production"
  fqdn_list   = ["domain1.com"]

  custom_tags = {
    hello = "world"
  }
}
