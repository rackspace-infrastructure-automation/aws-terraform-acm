output "id" {
  description = "The ARN of the certificate"
  value       = "${aws_acm_certificate.cert.id}"
}

output "arn" {
  description = "The ARN of the certificate"
  value       = "${aws_acm_certificate.cert.arn}"
}

output "domain_name" {
  description = "The domain name for which the certificate is issued"
  value       = "${aws_acm_certificate.cert.domain_name}"
}

output "domain_validation_options" {
  description = <<HEREDOC
A list of attributes to feed into other resources to complete certificate validation. Can have more than one element,
e.g. if SANs are defined. Only set if `DNS`-validation was used.
HEREDOC

  value = "${aws_acm_certificate.cert.domain_validation_options}"
}

output "validation_emails" {
  description = <<HEREDOC
A list of addresses that received a validation E-Mail. Only set if `EMAIL`-validation was used.
HEREDOC

  value = "${aws_acm_certificate.cert.validation_emails}"
}
