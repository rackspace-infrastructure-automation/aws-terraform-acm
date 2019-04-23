# aws-terraform-acm

This module creates an ACM certificate and automatically validates it via DNS validation if a Route 53 zone id for a
public hosted zone managing the domain(s) DNS is provided.

If a Route 53 zone id is not provided, or if `EMAIL` is the chosen validation method, this module provides no added
functionality beyond creating the ACM certificate as the `aws_acm_certificate` Terraform resource normally would. If
that is the case, we recommend using the `aws_acm_certificate` resource directly. Nevertheless, this module supports
either use case in order to facilitate a future migration to Route 53 if desired.

## Basic Usage

```hcl
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

```

Full working references are available at [examples](examples)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| custom\_tags | Optional tags to be applied on top of the base tags on all resources | map | `<map>` | no |
| environment | Application environment for which this network is being created. e.g. Development/Production | string | `"Development"` | no |
| fqdn\_list | A list FQDNs for which the certificate should be issued. | list | `<list>` | no |
| fqdn\_to\_r53zone\_map | A map of alternate Route 53 zone ids and corresponding FQDNs to validate. The key for each pair is the FQDN in which a certficate must be generated. This map will typically contain all of the FQDNS provided in fqdn_list. | map | `<map>` | no |
| fqdn\_to\_r53zone\_map\_count | Provide the count of key/value pairs provided in variable fqdn_to_r53zone_map | string | `"0"` | no |
| validation\_creation\_timeout | aws_acm_certificate_validation resource creation timeout. | string | `"45m"` | no |
| validation\_method | Which method to use for validation. `DNS` or `EMAIL` are valid, `NONE` can be used for certificates that were imported into ACM and then into Terraform. | string | `"DNS"` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the certificate |
| domain\_name | The domain name for which the certificate is issued |
| domain\_validation\_options | A list of attributes to feed into other resources to complete certificate validation. Can have more than one element, e.g. if SANs are defined. Only set if `DNS`-validation was used. |
| id | The ARN of the certificate |
| validation\_emails | A list of addresses that received a validation E-Mail. Only set if `EMAIL`-validation was used. |

