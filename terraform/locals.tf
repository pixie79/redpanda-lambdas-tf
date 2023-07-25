
locals {
  aws_region     = data.aws_region.current.name
  aws_account_id = data.aws_caller_identity.current.account_id
  ci_arn         = "arn:aws:iam::${local.aws_account_id}:role/${var.ci_runner_role_name}"
  generic_name   = "${local.aws_account_id}-kafka-lambdas"


  environment = replace(var.account_name, "/-.*/", "")
  tags = merge(
    var.additional_tags,
    {
      AccountName = var.account_name
      Environment = local.environment
    }
  )

  dd_env_map = {
    DD_ENV                     = local.environment
    DD_SITE                    = var.dd_site
    DD_TRACE_ENABLED           = var.dd_trace_enabled
    DD_PROFILING_ENABLED       = var.dd_profiling_enabled
    DD_API_KEY                 = "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${var.dd_api_key_name}"
    DD_APP_KEY                 = "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${var.dd_app_key_name}"
    DD_MERGE_XRAY_TRACES       = var.dd_merge_xray_traces
    DD_LOG_LEVEL               = var.dd_log_level
    DD_TRACE_DEBUG             = var.dd_trace_debug
    DD_FLUSH_TO_LOG            = var.dd_flush_to_log
    DD_CAPTURE_LAMBDA_PAYLOAD  = var.dd_capture_lambda_payload
    DD_SERVERLESS_LOGS_ENABLED = var.dd_serverless_logs_enabled
  }

}