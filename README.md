# aws-terraform-acm

This module creates an ACM certificate and automatically validates it via DNS validation if a Route 53 zone id for a
public hosted zone managing the domain(s) DNS is provided.

If a Route 53 zone id is not provided, or if `EMAIL` is the chosen validation method, this module provides no added
functionality beyond creating the ACM certificate as the `aws_acm_certificate` Terraform resource normally would. If
that is the case, we recommend using the `aws_acm_certificate` resource directly. Nevertheless, this module supports
either use case in order to facilitate a future migration to Route 53 if desired.

## Basic Usage

```hcl
module "acm" {
    source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.1"

    domain = "example.com"
    subject_alternative_names = ["foo.example.com", "bar.example.com"]
    route53_zone_id = "XXXXXXXXXXXXXX"
}
```

Full working references are available at [examples](examples)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| custom\_tags | Optional tags to be applied on top of the base tags on all resources | map | `<map>` | no |
| domain | A domain name for which the certificate should be issued | string | n/a | yes |
| environment | Application environment for which this network is being created. e.g. Development/Production | string | `"Development"` | no |
| route53\_zone\_id | Zone ID of the Route 53 Hosted Zone that will be used to create records for DNS-based validation when the `validation_method` is set to `DNS`. If `validation_method` is not set to `DNS`, or if a `route53_zone_id` is not provided, then no automated validation will be attempted. | string | `""` | no |
| subject\_alternative\_names | A list of domains that should be SANs in the issued certificate | list | `<list>` | no |
| validation\_method | Which method to use for validation. `DNS` or `EMAIL` are valid, `NONE` can be used for certificates that were imported into ACM and then into Terraform. | string | `"DNS"` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the certificate |
| domain\_name | The domain name for which the certificate is issued |
| domain\_validation\_options | A list of attributes to feed into other resources to complete certificate validation. Can have more than one element, e.g. if SANs are defined. Only set if `DNS`-validation was used. |
| id | The ARN of the certificate |
| validation\_emails | A list of addresses that received a validation E-Mail. Only set if `EMAIL`-validation was used. |

