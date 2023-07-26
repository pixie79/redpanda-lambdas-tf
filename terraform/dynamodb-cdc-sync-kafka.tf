locals {
  dynamodb_cdc_sync_lambda_function_name = "${local.generic_name}-dynamodb-cdc-sync-kafka"
}

module "dynamodb-cdc-sync" {
  count       = length(var.source_dynamodb_table_arns) > 0 ? 1 : 0
  source      = "./modules/lambda"
  module_path = "${path.root}/lambda-src/dynamodb-cdc-sync-kafka"
  environment_variables = merge(
    {
      DD_SERVICE            = local.dynamodb_cdc_sync_lambda_function_name
      DD_VERSION            = 1
      LOG_LEVEL             = var.log_level
      KAFKA_CREDENTIALS_KEY = "${local.dynamodb_cdc_sync_lambda_function_name}_credentials"
      ENVIRONMENT           = local.environment
    }, local.dd_env_map
  )
  lambda_function_name = local.dynamodb_cdc_sync_lambda_function_name
  security_group_ids   = [aws_security_group.this.id]
  subnet_ids           = [data.aws_subnets.this.ids]
  lambda_role_arn      = aws_iam_role.lambda.arn
  tags = merge(
    { "Name" : local.dynamodb_cdc_sync_lambda_function_name },
    local.tags
  )
  cloudwatch_logging_kms_key_id = aws_kms_key.cloudwatch_key.id
  base_kms_policy_json          = data.aws_iam_policy_document.base_kms_policy.json
  aws_account_id                = local.aws_account_id
  aws_region                    = local.aws_region
  ssm_recovery_window_in_days   = var.ssm_recovery_window_in_days
}

resource "aws_lambda_event_source_mapping" "allow_dynamodb_table_to_trigger_lambda" {
  for_each                       = toset(var.source_dynamodb_table_arns)
  event_source_arn               = each.key
  function_name                  = module.dynamodb-cdc-sync[0].function_arn
  parallelization_factor         = var.parallelization_factor
  bisect_batch_on_function_error = true
}

# Code for EventBridge Trigger
#resource "aws_lambda_permission" "this" {
#  statement_id  = "AllowExecutionFromEventBridge"
#  action        = "lambda:InvokeFunction"
#  function_name = module.dynamodb-cdc-sync.function_name
#  principal     = "events.amazonaws.com"
#  source_arn    = "arn:aws:events:${local.aws_region}:${local.aws_account_id}:*/*/*"
#}
