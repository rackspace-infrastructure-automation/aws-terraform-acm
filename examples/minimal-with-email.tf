module "acm" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.1"

  fqdn_list         = ["example.com"]
  environment       = "Test"
  validation_method = "Email"

  custom_tags = {
    hello = "world"
  }
}
