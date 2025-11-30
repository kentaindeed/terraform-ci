locals {
  common_variables = {
    region = "ap-northeast-1"
    profile = "default"
  }

  common_tags = {
    Environment = "prod"
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

}