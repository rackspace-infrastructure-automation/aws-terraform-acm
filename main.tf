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
 *locals {
 *    alt_names_zones = "${map(
 *      "foo.example.com", "XXXXXXXXXXXXXX",
 *      "moo.example.com", "XXXXXXXXXXXXXX",
 *      "www.example.net", "YYYYYYYYYYYYYY",
 *      )}"
 *}
 *
 *
 *module "acm" {
 *   source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.2"
 *
 *    domain                = "example.com"
 *    environment           = "Production"
 *    domain_r53_zone_id    = "XXXXXXXXXXXXXX"
 *    alt_names_zones       = "${local.alt_names_zones}"
 *    alt_names_zones_count = 3
 *    zone_ids_provided     = true
 *
 *    custom_tags = {
 *      hello = "world"
 *    }
 *}
 * ```
 *
 * Full working references are available at [examples](examples)
 */
locals {
  acm_validation_options = "${aws_acm_certificate.cert.domain_validation_options}"

  use_route53_validation = "${var.validation_method == "DNS" && var.zone_ids_provided}"

  cert_count = "${local.use_route53_validation ? 1 : 0}"

  route_53_record_count = "${local.use_route53_validation ? var.alt_names_zones_count + 1 : 0}"

  subject_alternative_names = "${keys(var.alt_names_zones)}"

  r53_zone_ids = "${flatten(list(list(var.domain_r53_zone_id), values(var.alt_names_zones)))}"

  base_tags = {
    Environment     = "${var.environment}"
    ServiceProvider = "Rackspace"
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name               = "${var.domain}"
  subject_alternative_names = ["${local.subject_alternative_names}"]
  tags                      = "${merge(local.base_tags, map("Name", var.domain), var.custom_tags)}"
  validation_method         = "${var.validation_method}"

  tags = "${merge(local.base_tags, map("Name", var.domain), var.custom_tags)}"

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
