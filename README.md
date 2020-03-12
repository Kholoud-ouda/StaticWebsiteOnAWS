## StaticWebsiteOnAWS

Terraform code to provision infrastructure on AWS for Angular frontEnd website that will be host in S3 bucket.
Multiple environment can be provision using the same code.

## AWS Resources that will be used:

1- Route53
2- SSL Certificate to be used in cloudfront (Redirect all Http to Https requests)
3- Cloudfront
4- S3 Bucket (s3 bucker for the website per environment & s3 bucket for pipelines artifacts)
5- AWS repository,CodeBuild & Code Pipeline
6- AWS IAM Role

## Architecture

![Image description](staticWebSiteArc.png)
