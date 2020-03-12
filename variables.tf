variable "region" {
  default = "ap-northeast-1"
}

variable "environmentNumber" {
  default = "1"
}

variable "environment" {
  type = "map"
  default = {
    "0" = "Staging"
    "1" = "Prod"
  }
}

variable "project" {
  default = "example"
}

variable "frontendBucketName" {
  type = "map"
  default = {
    "0" = "staging.example.com"
    "1" = "example.com"
  }
}


variable "domainName" {
  default = "example.com"
}

variable "pipelineRoleArn" {
  default = "arn:aws:iam::852943587558:role/finterra-codePipeline-role"
}


variable "repoBranch" {
  type = "map"
  default = {
    "0" = "staging"
    "1" = "master"
  }
}
variable "buildProject" {
  default = "angularBuildProject"
}
