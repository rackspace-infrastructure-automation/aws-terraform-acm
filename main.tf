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
 * ```
 * module "acm" {
 *     source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-acm//?ref=v0.0.1"
 *
 *     domain = "example.com"
 *     subject_alternative_names = ["foo.example.com", "bar.example.com"]
 *     route53_zone_id = "XXXXXXXXXXXXXX"
 * }
 * ```
 *
 * Full working references are available at [examples](examples)
 */
locals {
  base_tags = {
    ServiceProvider = "Rackspace"
    Environment     = "${var.environment}"
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name               = "${var.domain}"
  validation_method         = "${var.validation_method}"
  subject_alternative_names = "${var.subject_alternative_names}"

  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(local.base_tags, map("Name", var.domain), var.custom_tags)}"
}

locals {
  acm_validation_options = "${aws_acm_certificate.cert.domain_validation_options}"
  use_route53_validation = "${var.validation_method == "DNS" && var.route53_zone_id != ""}"
}

resource "aws_route53_record" "cert_validation" {
  count = "${local.use_route53_validation ? (length(var.subject_alternative_names)+ 1) : 0}"

  zone_id = "${var.route53_zone_id}"
  name    = "${lookup(local.acm_validation_options[count.index], "resource_record_name")}"
  type    = "${lookup(local.acm_validation_options[count.index], "resource_record_type")}"
  records = ["${lookup(local.acm_validation_options[count.index], "resource_record_value")}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  count           = "${local.use_route53_validation ? 1 : 0}"
  certificate_arn = "${aws_acm_certificate.cert.arn}"

  validation_record_fqdns = ["${aws_route53_record.cert_validation.*.fqdn}"]
}