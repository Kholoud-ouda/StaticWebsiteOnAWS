provider "aws" {
  version = "~> 2.0"
  region  = "${var.region}"
  profile = "aws-prod"
}

provider "aws" {
  alias   = "us-east-1"
  version = "~> 2.0"
  region  = "us-east-1"
  profile = "aws-prod"
}
