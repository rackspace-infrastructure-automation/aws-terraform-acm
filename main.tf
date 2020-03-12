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
 * locals {
 *   fqdn_to_r53zone_map = "${map(
 *     "example.com", "XXXXXXXXXXXXXX",
 *     "foo.example.com", "XXXXXXXXXXXXXX",
 *     "moo.example.com", "XXXXXXXXXXXXXX",
 *     "www.example.net", "YYYYYYYYYYYYYY",
 *     )}"
 * }
 *
 * module "acm" {
 *   source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.2"
 *
 *   fqdn_list                 = ["example.com"]
 *   environment               = "Production"
 *   fqdn_to_r53zone_map       = "${local.fqdn_to_r53zone_map}"
 *   fqdn_to_r53zone_map_count = 4
 *
 *   custom_tags = {
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
locals {
  acm_validation_options = "${aws_acm_certificate.cert.domain_validation_options}"

  use_route53_validation = "${var.validation_method == "DNS" && var.fqdn_to_r53zone_map_count > 0}"

  cert_count = "${local.use_route53_validation ? 1 : 0}"

  route_53_record_count = "${local.use_route53_validation ? var.fqdn_to_r53zone_map_count  : 0}"

  certificate_domain = "${element(var.fqdn_list, 0)}"

  subject_alternative_names = "${slice(var.fqdn_list, 1, length(var.fqdn_list))}"

  r53_zone_ids = "${values(var.fqdn_to_r53zone_map)}"

  base_tags = {
    Environment     = "${var.environment}"
    ServiceProvider = "Rackspace"
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name               = "${local.certificate_domain}"
  subject_alternative_names = ["${local.subject_alternative_names}"]
  tags                      = "${merge(var.custom_tags, var.tags, local.base_tags, map("Name", local.certificate_domain))}"
  validation_method         = "${var.validation_method}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  count = "${local.route_53_record_count}"

  name    = "${lookup(local.acm_validation_options[count.index], "resource_record_name")}"
  records = ["${lookup(local.acm_validation_options[count.index], "resource_record_value")}"]
  ttl     = 60
  type    = "${lookup(local.acm_validation_options[count.index], "resource_record_type")}"
  zone_id = "${element(local.r53_zone_ids, count.index)}"
}

resource "aws_acm_certificate_validation" "cert" {
  count = "${local.cert_count}"

  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.*.fqdn}"]

  timeouts {
    create = "${var.validation_creation_timeout}"
  }
}
