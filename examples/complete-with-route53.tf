module "acm" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.1"

  domain                    = "example.com"
  environment               = "Production"
  route53_zone_id           = "XXXXXXXXXXXXXX"
  subject_alternative_names = ["foo.example.com", "bar.example.com"]

  custom_tags = {
    hello = "world"
  }
}
