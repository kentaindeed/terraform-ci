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