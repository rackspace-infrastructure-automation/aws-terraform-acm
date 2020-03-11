resource "aws_route53_zone" "primary" {
  name = "domain1.com"
}

resource "aws_route53_zone" "secondary" {
  name = "domain1.net"
}

locals {
  fqdn_to_r53zone_map = "${map(
    "domain1.com", aws_route53_zone.primary.zone_id,
    "foo.domain1.com", aws_route53_zone.primary.zone_id,
    "moo.domain1.com", aws_route53_zone.primary.zone_id,
    "www.domain1.net", aws_route53_zone.secondary.zone_id,
    )}"
}

module "acm" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.2"

  environment               = "Production"
  fqdn_list                 = "${keys(local.fqdn_to_r53zone_map)}"
  fqdn_to_r53zone_map       = "${local.fqdn_to_r53zone_map}"
  fqdn_to_r53zone_map_count = 4

  custom_tags = {
    hello = "world"
  }
}
