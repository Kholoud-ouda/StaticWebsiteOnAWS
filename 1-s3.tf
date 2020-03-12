## S3 Bucket to host the Static website with public access policy 
resource "aws_s3_bucket" "this" {
  count  = "${var.environmentNumber}"
  bucket = "${var.frontendBucketName[count.index]}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": [
                "arn:aws:s3:::${var.frontendBucketName[count.index]}",
                "arn:aws:s3:::${var.frontendBucketName[count.index]}/*"
            ]
        }
    ]
}
POLICY
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

## Allow public access to the bucket 
resource "aws_s3_bucket_public_access_block" "this" {
  count  = "${var.environmentNumber}"
  bucket = "${aws_s3_bucket.this[count.index].id}"

  block_public_acls = false
}

resource "aws_s3_bucket" "artifactsBucket" {
  bucket        = "${var.project}-pipelines-artifacts"
  force_destroy = false
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "SSEAndSSLPolicy",
    "Statement" : [
      {
        "Sid" : "DenyUnEncryptedObjectUploads",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:PutObject",
        "Resource" : "arn:aws:s3:::${var.project}-pipelines-artifacts/*",
        "Condition" : {
          "StringNotEquals" : {
            "s3:x-amz-server-side-encryption" : "aws:kms"
          }
        }
      },
      {
        "Sid" : "DenyInsecureConnections",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : "arn:aws:s3:::${var.project}-pipelines-artifacts/*",
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        }
      }
    ]
  })
  tags = {
    Project = "${var.project}"
  }
}
