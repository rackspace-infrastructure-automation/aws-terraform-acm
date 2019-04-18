variable "custom_tags" {
  description = "Optional tags to be applied on top of the base tags on all resources"
  type        = "map"
  default     = {}
}

variable "domain" {
  description = "A domain name for which the certificate should be issued"
  type        = "string"
}

variable "domain_r53_zone_id" {
  description = "A domain name for which the certificate should be issued"
  type        = "string"
  default     = ""
}

variable "environment" {
  description = "Application environment for which this network is being created. e.g. Development/Production"
  type        = "string"
  default     = "Development"
}

variable "alt_names_zones" {
  description = <<HEREDOC
A map of alternate names and route53 zone ids. The key for each pair is the alternate name in which a certficate must be generated.
The value in the pair must be the Route53 zone id in which DNS verification will executed for the given alternate name.
IF DNS/R53 validation will not be executed, the value can be left as empty quotes.
HEREDOC

  type    = "map"
  default = {}
}

variable "alt_names_zones_count" {
  description = "Provide the count of key/value pairs provided in variable alt_names_zones"
  type        = "string"
  default     = 0
}

variable "zone_ids_provided" {
  description = "Route53 Zone IDs were provided. A R53 Zone ID must be specified for each domain/alternate name if route53 validation is desired."
  type        = "string"
  default     = false
}

variable "validation_creation_timeout" {
  description = "aws_acm_certificate_validation resource creation timeout."
  type        = "string"
  default     = "30m"
}

variable "validation_method" {
  description = <<HEREDOC
Which method to use for validation. `DNS` or `EMAIL` are valid, `NONE` can be used for certificates that were imported
into ACM and then into Terraform.
HEREDOC

  type    = "string"
  default = "DNS"
}
