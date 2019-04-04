output "id" {
  value = "${module.acm.id}"
}

output "arn" {
  value = "${module.acm.arn}"
}

output "domain_name" {
  value = "${module.acm.domain_name}"
}

output "domain_validation_options" {
  value = "${module.acm.domain_validation_options}"
}

output "validation_emails" {
  value = "${module.acm.validation_emails}"
}
