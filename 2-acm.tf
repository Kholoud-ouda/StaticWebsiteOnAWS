########################################################################################
###### Certificate creation on us-east-1 region to be used in cloudfront ssl cert ######
#### Varifcation method Email. Varifcation can be DNS as well.                      ####
########################################################################################
resource "aws_acm_certificate" "this" {
  count                     = "${var.environmentNumber}"
  provider                  = "aws.us-east-1"
  domain_name               = "${var.domainName}"
  subject_alternative_names = ["*.${var.domainName}"]
  validation_method         = "EMAIL"
}
