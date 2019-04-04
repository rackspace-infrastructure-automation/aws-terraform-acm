module "acm" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.1"

  domain                    = "example.com"
  subject_alternative_names = ["foo.example.com", "bar.example.com"]
  route53_zone_id           = "XXXXXXXXXXXXXX"
  environment               = "Production"

  custom_tags = {
    hello = "world"
  }
}
