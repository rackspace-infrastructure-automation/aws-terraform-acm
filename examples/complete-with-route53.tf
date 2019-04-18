locals {
  alt_names_zones = "${map(
    "foo.example.com", "XXXXXXXXXXXXXX",
    "moo.example.com", "XXXXXXXXXXXXXX",
    "www.example.net", "YYYYYYYYYYYYYY",
    )}"
}

module "acm" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.2"

  domain                = "example.com"
  environment           = "Production"
  domain_r53_zone_id    = "XXXXXXXXXXXXXX"
  alt_names_zones       = "${local.alt_names_zones}"
  alt_names_zones_count = 3
  zone_ids_provided     = true

  custom_tags = {
    hello = "world"
  }
}
