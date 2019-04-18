module "acm" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.1"

  domain                = "example.com"
  environment           = "Test"
  validation_method     = "Email"
  zone_ids_provided     = false
  alt_names_zones_count = 0

  custom_tags = {
    hello = "world"
  }
}
