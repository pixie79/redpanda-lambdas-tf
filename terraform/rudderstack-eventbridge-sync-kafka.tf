locals {
  rudderstack_lambda_function_name = "${local.generic_name}-rudderstack"
}


module "rudderstack_sync" {
  count       = length(var.rudderstack_account_ids) > 0 ? 1 : 0
  source      = "./modules/lambda"
  module_path = "${path.root}/lambda-src/eventbridge-sync-kafka"
  environment_variables = merge(
    {
      DD_SERVICE            = local.rudderstack_lambda_function_name
      DD_VERSION            = 1
      LOG_LEVEL             = var.log_level
      KAFKA_CREDENTIALS_KEY = "${local.rudderstack_lambda_function_name}_credentials"
      ENVIRONMENT           = local.environment
    }, local.dd_env_map
  )
  lambda_function_name = local.rudderstack_lambda_function_name
  security_group_ids   = [aws_security_group.this.id]
  subnet_ids           = [data.aws_subnets.this.ids]
  lambda_role_arn      = aws_iam_role.lambda.arn
  tags = merge(
    { "Name" : local.rudderstack_lambda_function_name },
    local.tags
  )
  cloudwatch_logging_kms_key_id = aws_kms_key.cloudwatch_key.id
  base_kms_policy_json          = data.aws_iam_policy_document.base_kms_policy.json
  aws_account_id                = local.aws_account_id
  aws_region                    = local.aws_region
  ssm_recovery_window_in_days   = var.ssm_recovery_window_in_days
}

module "event-bridge-rudderstack_sync" {
  count                    = length(var.rudderstack_account_ids) > 0 ? 1 : 0
  source                   = "terraform-aws-modules/eventbridge/aws"
  version                  = "2.3.0"
  bus_name                 = local.rudderstack_lambda_function_name
  create_rules             = true
  create_bus               = true
  attach_cloudwatch_policy = true
  cloudwatch_target_arns   = module.rudderstack_sync[0].cloudwatch_log_group_arn
  rules = {
    rule1 = {
      description   = "Capture pattern matching data"
      event_pattern = jsonencode({ "source" : ["rudderstack"] })
      enabled       = true
    }
  }
  targets = {
    rule1 = [
      {
        name = "send-events-to-api-gw"
        arn  = module.rudderstack_sync[0].function_arn
      }
    ]
  }
}

data "aws_iam_policy_document" "rudderstack" {
  statement {
    effect = "Allow"
    actions = [
      "events:PutEvents"
    ]
    resources = [module.event-bridge-rudderstack_sync[0].eventbridge_bus_arn]
  }
}

data "aws_iam_policy_document" "rudderstack_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = var.rudderstack_account_ids
    }
  }
}

resource "aws_iam_role" "this" {
  count              = length(var.rudderstack_account_ids) > 0 ? 1 : 0
  name               = "${local.rudderstack_lambda_function_name}-service"
  assume_role_policy = data.aws_iam_policy_document.rudderstack_assume_role_policy.json
  inline_policy {
    name   = "policy-allow-events"
    policy = data.aws_iam_policy_document.rudderstack.json
  }
}
