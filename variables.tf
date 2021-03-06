variable "custom_tags" {
  description = "Optional tags to be applied on top of the base tags on all resources. [**Deprecated** in favor of `tags`]. It will be removed in future releases."
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Application environment for which this network is being created. e.g. Development/Production"
  type        = string
  default     = "Development"
}

variable "fqdn_list" {
  description = "A list FQDNs for which the certificate should be issued."
  type        = list(string)
  default     = []
}

variable "fqdn_to_r53zone_map" {
  description = "A map of alternate Route 53 zone ids and corresponding FQDNs to validate. The key for each pair is the FQDN in which a certficate must be generated. This map will typically contain all of the FQDNS provided in fqdn_list."
  type        = map(string)
  default     = {}
}

variable "fqdn_to_r53zone_map_count" {
  description = "Provide the count of key/value pairs provided in variable fqdn_to_r53zone_map"
  type        = string
  default     = 0
}

variable "self_signed" {
  description = "Boolean value indicating if a certificate should be self-signed."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Optional tags to be applied on top of the base tags on all resources"
  type        = map(string)
  default     = {}
}

variable "validation_creation_timeout" {
  description = "aws_acm_certificate_validation resource creation timeout."
  type        = string
  default     = "45m"
}

variable "validation_method" {
  description = "Which method to use for validation. `DNS` or `EMAIL` are valid, `NONE` can be used for certificates that were imported into ACM and then into Terraform."
  type        = string
  default     = "DNS"
}
