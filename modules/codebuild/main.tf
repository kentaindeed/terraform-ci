# terraform 実行用の Codebuild

locals {
  common_variables = {
    region = "ap-northeast-1"
    profile = "default"
  }

  common_tags = {
    Project = "terraform-ci"
    Owner = "kentaindeed"
    CreatedBy = "terraform"
    CreatedAt   = formatdate("YYYY-MM-DD", timeadd(timestamp(), "9h"))  # JST
  }

  availability_zones = [
    "ap-northeast-1a", 
    "ap-northeast-1d", 
    "ap-northeast-1c"
]

    name_prefix = "${var.env}-${local.common_tags.Project}"
}

resource "aws_codebuild_project" "terraform-ci" {
  name = "${local.name_prefix}-ci-codebuild"
  description = "terraform ci"
  build_timeout = "300"
  service_role = aws_iam_role.codebuild.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type = "LINUX_CONTAINER"
    privileged_mode = false
    image_pull_credentials_type = "CODEBUILD"
  }
  source {
    type = "GITHUB"
    location = "https://github.com/${var.github_owner}/${var.github_repo}.git"
    git_clone_depth = 1
    buildspec = templatefile("${path.module}/templates/buildspec.yml.tpl", {
      TF_VERSION  = var.TF_VERSION
      env = var.env
    })
    
    # private の時のみコメントを外す
    # auth {
    #   type = "OAUTH"
    # }
  }

  # source は基本的にmain のみを使用
  source_version = "main"

  tags = local.common_tags
  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }
}

# codebuild webhook
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook
resource "aws_codebuild_webhook" "terraform-ci" {
  project_name = aws_codebuild_project.terraform-ci.name
  build_type = "BUILD"

  # terraform のrepo でpush イベントが起こると実行
  filter_group {
    filter {
      type = "EVENT"
      pattern = "PULL_REQUEST_MERGED"
    }

    filter {
      type = "HEAD_REF"
      pattern = "main"
    }
  }
}


