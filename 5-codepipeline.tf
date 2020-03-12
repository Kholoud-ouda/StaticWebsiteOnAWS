########################################################################################
######  Pipeline to deploy the static web site to s3 bucket. The pipeline         ######
####    has 2 stages. 1- for pulling code 2- deploy on s3(bucket name need to be    ####
###     passed as a varibale).                                                       ###
########################################################################################
resource "aws_codepipeline" "this" {
  count    = "${var.environmentNumber}"
  name     = "${var.project}-${var.environment[count.index]}-FrontEnd-Pipeline"
  role_arn = "${aws_iam_role.codePipelineRole.arn}"

  artifact_store {
    location = "${aws_s3_bucket.artifactsBucket.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      configuration = {
        RepositoryName = "${var.project}"
        BranchName     = "${var.repoBranch[count.index]}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      configuration = {
        ProjectName = "${aws_codebuild_project.this.arn}"
        EnvironmentVariables = jsonencode([
          {
            name  = "BUCKET_NAME"
            value = "${aws_s3_bucket.this[count.index].bucket}"
          },
          {
            name  = "BUILD_ENV"
            value = "${lower(var.environment[count.index])}"
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }
}
