# aws-terraform-acm | tests

Please note that there are no automated tests for the following scenarios:

* **minimal-with-email**
    * Creating this certificate request sends real e-mails. We do not want to spam anybody every time the test runs.

* **complete-with-route53**
    * We've chosen to not automate this right now so as to not expose any permanent hosted zone IDs or internal testing domain names.
    * Any modifications to this module that may affect this scenario should be tested against a real domain prior to submitting a Pull Request.
