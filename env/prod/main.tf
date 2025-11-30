
terraform {
  backend "s3" {
    bucket         = "prod-terraform-ci-tf-backend"
    key            = "prod/terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    
    # オプション: プロファイルを指定する場合
    # profile = "default"
  }
}

# backend s3 module
module  "backend" {
  source =  "../../modules/backend"
  env = var.env
  aws_region = var.aws_region
}


