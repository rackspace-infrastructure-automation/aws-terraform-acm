/**
 * # aws-terraform-acm
 *
 * This module creates an ACM certificate and automatically validates it via DNS validation if a Route 53 zone id for a
 * public hosted zone managing the domain(s) DNS is provided.
 *
 * If a Route 53 zone id is not provided, or if `EMAIL` is the chosen validation method, this module provides no added
 * functionality beyond creating the ACM certificate as the `aws_acm_certificate` Terraform resource normally would. If
 * that is the case, we recommend using the `aws_acm_certificate` resource directly. Nevertheless, this module supports
 * either use case in order to facilitate a future migration to Route 53 if desired.
 *
 * ## Basic Usage
 *
 * ```hcl
 * module "acm" {
 *   source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.12.3"
 *
 *   environment               = "Production"
 *   fqdn_list                 = ["example.com"]
 *
 *   tags = {
 *     hello = "world"
 *   }
 * }
 *
 * ```
 *
 * Full working references are available at [examples](examples)
 *
 * ## Module variables
 *
 * The following module variables changes have occurred:
 *
 * #### Deprecations
 * - `custom_tags` - marked for deprecation as it no longer meets our standards.
 *
 * #### Additions
 * - `tags` - introduced as a replacement for `custom_tags` to better align with our standards.
 */

terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.7.0"
    tls = ">= 2.0"
  }
}

locals {
  acm_validation_options = aws_acm_certificate.cert.domain_validation_options

  use_route53_validation = var.validation_method == "DNS" && var.fqdn_to_r53zone_map_count > 0 && ! var.self_signed

  cert_count = local.use_route53_validation ? 1 : 0

  route_53_record_count = local.use_route53_validation ? var.fqdn_to_r53zone_map_count : 0

  certificate_domain = element(var.fqdn_list, 0)

  subject_alternative_names = slice(var.fqdn_list, 1, length(var.fqdn_list))

  r53_zone_ids = values(var.fqdn_to_r53zone_map)

  base_tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
    Name            = local.certificate_domain
  }
}

resource "tls_private_key" "self" {
  count = var.self_signed ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "self" {
  count = var.self_signed ? 1 : 0

  key_algorithm         = "RSA"
  private_key_pem       = tls_private_key.self[0].private_key_pem
  validity_period_hours = 2160

  subject {
    common_name = local.certificate_domain
  }

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "cert" {
  certificate_body          = var.self_signed ? tls_self_signed_cert.self[0].cert_pem : null
  domain_name               = var.self_signed ? null : local.certificate_domain
  private_key               = var.self_signed ? tls_private_key.self[0].private_key_pem : null
  subject_alternative_names = var.self_signed ? null : local.subject_alternative_names
  tags                      = merge(var.custom_tags, var.tags, local.base_tags)
  validation_method         = var.self_signed ? null : var.validation_method

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  count = local.route_53_record_count

  name    = local.acm_validation_options[count.index]["resource_record_name"]
  records = [local.acm_validation_options[count.index]["resource_record_value"]]
  ttl     = 60
  type    = local.acm_validation_options[count.index]["resource_record_type"]
  zone_id = element(local.r53_zone_ids, count.index)
}

resource "aws_acm_certificate_validation" "cert" {
  count = local.cert_count

  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = aws_route53_record.cert_validation.*.fqdn

  timeouts {
    create = var.validation_creation_timeout
  }
}
