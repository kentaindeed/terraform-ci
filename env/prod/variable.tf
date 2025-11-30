# variable

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "prod"
}

variable "github_owner" {
  description = "GitHub owner"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository"
  type        = string
}

variable "TF_VERSION" {
  description = "Terraform version"
  type        = string
}