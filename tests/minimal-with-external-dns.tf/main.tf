provider "aws" {
  region = "us-west-2"
}

module "acm" {
  source = "../../module"

  domain      = "example.com"
  environment = "Production"

  custom_tags = {
    hello = "world"
  }
}
