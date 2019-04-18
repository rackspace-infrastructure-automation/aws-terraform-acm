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
```

Full working references are available at [examples](examples)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alt\_names\_zones | A map of alternate names and route53 zone ids. The key for each pair is the alternate name in which a certficate must be generated. The value in the pair must be the Route53 zone id in which DNS verification will executed for the given alternate name. IF DNS/R53 validation will not be executed, the value can be left as empty quotes. | map | `<map>` | no |
| alt\_names\_zones\_count | Provide the count of key/value pairs provided in variable alt_names_zones | string | `"0"` | no |
| custom\_tags | Optional tags to be applied on top of the base tags on all resources | map | `<map>` | no |
| domain | A domain name for which the certificate should be issued | string | n/a | yes |
| domain\_r53\_zone\_id | A domain name for which the certificate should be issued | string | `""` | no |
| environment | Application environment for which this network is being created. e.g. Development/Production | string | `"Development"` | no |
| validation\_creation\_timeout | aws_acm_certificate_validation resource creation timeout. | string | `"30m"` | no |
| validation\_method | Which method to use for validation. `DNS` or `EMAIL` are valid, `NONE` can be used for certificates that were imported into ACM and then into Terraform. | string | `"DNS"` | no |
| zone\_ids\_provided | Route53 Zone IDs were provided. A R53 Zone ID must be specified for each domain/alternate name if route53 validation is desired. | string | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the certificate |
| domain\_name | The domain name for which the certificate is issued |
| domain\_validation\_options | A list of attributes to feed into other resources to complete certificate validation. Can have more than one element, e.g. if SANs are defined. Only set if `DNS`-validation was used. |
| id | The ARN of the certificate |
| validation\_emails | A list of addresses that received a validation E-Mail. Only set if `EMAIL`-validation was used. |

