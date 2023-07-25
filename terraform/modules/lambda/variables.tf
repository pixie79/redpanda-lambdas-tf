variable "module_path" {
  description = "Path to the module src"
  type        = string
}

variable "lambda_function_name" {
  type        = string
  description = "Lambda Function name"
}

variable "environment_variables" {
  type = map(string)
  default = {
    "LOG_LEVEL" = "INFO"
  }
  description = "Environment variables for the lambda function"
}

variable "security_group_ids" {
  description = "The security group ids to attach to the lambda function"
  type        = list(string)
}

variable "subnet_ids" {
  description = "The subnet IDs to place the Lambda function within"
  type        = list(string)
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role to attach to the lambda function"
  type        = string
}

variable "reserved_concurrent_executions" {
  default     = 1
  description = "The amount of reserved concurrent executions for the lambda function"
  type        = number
}

variable "lambda_timeout" {
  default     = 120
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

variable "log_retention_in_days" {
  default     = 14
  description = "The number of days log events are kept in CloudWatch Logs. When updating this property, unsetting it will cause Terraform to re-create the log group."
  type        = number
}

variable "ssm_recovery_window_in_days" {
  default     = 14
  description = "Secrets Manager recovery_window_in_days"
  type        = number
}

variable "cloudwatch_logging_kms_key_id" {
  description = "KMS key to encrypt cloudwatch logs"
  type        = string
}

variable "base_kms_policy_json" {
  description = "Base KMS policy JSON"
  type        = string
}

variable "kms_deletion_window_in_days" {
  default     = 14
  description = "The number of days to wait before deleting a CMK that has been removed from a CloudFormation stack. Default is 14 days."
  type        = number
}

variable "additional_kms_policies" {
  default     = []
  type        = list(any)
  description = "List of additional KMS policies to add to the base policy"
}
