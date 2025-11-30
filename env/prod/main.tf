
terraform {
  backend "s3" {
    bucket  = "prod-terraform-ci-tf-backend"
    key     = "prod/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true

    # オプション: プロファイルを指定する場合
    # profile = "default"
  }
}

# backend s3 module
module "backend" {
  source     = "../../modules/backend"
  env        = var.env
  aws_region = var.aws_region
}


module "codebuild" {
  source     = "../../modules/codebuild"
  env        = var.env
  aws_region = var.aws_region
  github_owner  = var.github_owner
  github_repo   = var.github_repo
  TF_VERSION = var.TF_VERSION
}