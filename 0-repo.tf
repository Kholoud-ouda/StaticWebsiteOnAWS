resource "aws_codecommit_repository" "this" {
  repository_name = "${var.project}"
  description     = "This is the Sample App Repository"
}
