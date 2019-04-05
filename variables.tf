variable "custom_tags" {
  description = "Optional tags to be applied on top of the base tags on all resources"
  type        = "map"
  default     = {}
}

variable "domain" {
  description = "A domain name for which the certificate should be issued"
  type        = "string"
}

variable "environment" {
  description = "Application environment for which this network is being created. e.g. Development/Production"
  type        = "string"
  default     = "Development"
}

variable "route53_zone_id" {
  description = <<HEREDOC
Zone ID of the Route 53 Hosted Zone that will be used to create records for DNS-based validation when the
`validation_method` is set to `DNS`. If `validation_method` is not set to `DNS`, or if a `route53_zone_id` is not
provided, then no automated validation will be attempted.
HEREDOC

  type    = "string"
  default = ""
}

variable "subject_alternative_names" {
  description = "A list of domains that should be SANs in the issued certificate"
  type        = "list"
  default     = []
}

variable "validation_method" {
  description = <<HEREDOC
Which method to use for validation. `DNS` or `EMAIL` are valid, `NONE` can be used for certificates that were imported
into ACM and then into Terraform.
HEREDOC

  type    = "string"
  default = "DNS"
}
