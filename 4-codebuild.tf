########################################################################################
######  General code Build project to be used from different pipleines            ######
####     Expected to find buildspec.yml file in the root repo branch                ####
########################################################################################
resource "aws_codebuild_project" "this" {
  name          = "angularBuildProject"
  description   = "Angular build and deploy project to s3 bucket."
  build_timeout = "60"
  service_role  = "${aws_iam_role.codeBuildRole.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}
