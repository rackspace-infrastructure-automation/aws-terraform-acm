locals {
  fqdn_to_r53zone_map = "${map(
    "example.com", "XXXXXXXXXXXXXX",
    "foo.example.com", "XXXXXXXXXXXXXX",
    "moo.example.com", "XXXXXXXXXXXXXX",
    "www.example.net", "YYYYYYYYYYYYYY",
    )}"
}

module "acm" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.2"

  fqdn_list                 = ["example.com"]
  environment               = "Production"
  fqdn_to_r53zone_map       = "${local.fqdn_to_r53zone_map}"
  fqdn_to_r53zone_map_count = 3

  custom_tags = {
    hello = "world"
  }
}
