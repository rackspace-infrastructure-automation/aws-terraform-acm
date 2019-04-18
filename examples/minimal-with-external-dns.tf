module "acm" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.2"

  domain      = "example.com"
  environment = "Production"

  custom_tags = {
    hello = "world"
  }
}
