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

# backend S3 
resource "aws_s3_bucket" "backend" {
  bucket = "${local.name_prefix}-tf-backend"

  tags = {
    Name        = "${local.name_prefix}-tf-backend"
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "backend" {
  bucket = aws_s3_bucket.backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

# acl 設定
# パブリックアクセスブロック（これで十分プライベート）
resource "aws_s3_bucket_public_access_block" "backend" {
  bucket = aws_s3_bucket.backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 暗号化
resource "aws_s3_bucket_server_side_encryption_configuration" "backend" {
  bucket = aws_s3_bucket.backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}