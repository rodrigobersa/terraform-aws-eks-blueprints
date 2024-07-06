# defaults to data.aws_caller_identity.current.account_id
variable "ecr_account_id" {
  type        = string
  description = "ECR repository AWS Account ID"
  default     = ""
}

# defaults to local.region 
variable "ecr_region" {
  type        = string
  description = "ECR repository AWS Region"
  default     = ""
}
