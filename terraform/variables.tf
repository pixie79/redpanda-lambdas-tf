variable "account_name" {
  description = "Name of the account, acceptable values are listed in https://github.com/P-Olympus/terraform-aws-tagging/blob/main/variables.tf"
  type        = string

  validation {
    # must start with account type, i.e: dev / int / e2e / prd / sandbox and match set pattern,
    # i.e. <account_type>-<str> or <account_type>-<str>-<str>
    condition = anytrue([
      can(regex("^(dev|int|e2e|prd|sandbox)-[a-z]+$", var.account_name)),
      can(regex("^(dev|int|e2e|prd|sandbox)-[a-z]+-[a-z]+$", var.account_name))
    ])
    error_message = "Must be a valid account_name, acceptable regex is set in https://github.com/P-Olympus/terraform-aws-tagging/blob/main/variables.tf ."
  }
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "ci_runner_role_name" {
  description = "CI Runner AWS Role Name"
  type        = string
  default     = ""
}

variable "log_level" {
  default     = "INFO"
  description = "Log level for the lambda function"
  type        = string
  validation {
    condition = anytrue([
      can(regex("^(DEBUG|INFO|WARN|ERROR|CRITICAL)$", var.log_level))
    ])
    error_message = "Must be one of DEBUG, INFO, WARN, ERROR, CRITICAL"
  }
}

variable "key_admins" {
  description = "Emergency secret key admin arns"
  type        = list(string)
  default     = []
}

variable "kms_deletion_window_in_days" {
  default     = 14
  description = "The number of days to wait before deleting a CMK that has been removed from a CloudFormation stack. Default is 14 days."
  type        = number
}

variable "ssm_recovery_window_in_days" {
  default     = 14
  description = "Secrets Manager recovery_window_in_days"
  type        = number
}

variable "kafka_vpc_cidr" {
  description = "CIDR block for kafka vpc"
  type        = string
}

variable "additional_tags" {
  description = "Map for adding extra optional tags"
  type        = map(string)
  default     = {}
}

variable "additional_kms_policies" {
  default     = []
  type        = list(any)
  description = "List of additional KMS policies to add to the base policy"
}

####################################
## DataDog Variables
####################################
variable "dd_api_key_name" {
  description = "Datadog API key name"
  type        = string
}

variable "dd_app_key_name" {
  description = "Datadog APP key name"
  type        = string
}

variable "dd_site" {
  default     = "datadoghq.eu"
  description = "Datadog site"
  type        = string
  validation {
    condition = anytrue([
      can(regex("^(datadoghq\\.com|datadoghq\\.eu|us3\\.datadoghq\\.com|ddog-gov\\.com)$", var.dd_site))
    ])
    error_message = "Must be one of datadoghq.com, datadoghq.eu, us3.datadoghq.com, ddog-gov.com"
  }
}

variable "dd_log_level" {
  default     = "info"
  description = "Datadog log level"
  type        = string
  validation {
    condition = anytrue([
      can(regex("^(debug|info|warn|error|critical)$", var.dd_log_level))
    ])
    error_message = "Must be one of DEBUG, INFO, WARN, ERROR, CRITICAL"
  }
}

variable "dd_trace_enabled" {
  default     = false
  type        = bool
  description = "Enable Datadog tracing"
}

variable "dd_profiling_enabled" {
  default     = false
  type        = bool
  description = "Enable Datadog Profiling"
}

variable "dd_merge_xray_traces" {
  default     = false
  type        = bool
  description = "Enable Datadog Xray Traces Merges"
}

variable "dd_trace_debug" {
  default     = false
  type        = bool
  description = "Enable Datadog Xray Traces debug"
}

variable "dd_flush_to_log" {
  default     = true
  type        = bool
  description = "Enable Datadog flush to log"
}

variable "dd_capture_lambda_payload" {
  default     = true
  type        = bool
  description = "Enable Datadog capture lambda payload"
}

variable "dd_serverless_logs_enabled" {
  default     = true
  type        = bool
  description = "Enable Datadog serverless logs"
}