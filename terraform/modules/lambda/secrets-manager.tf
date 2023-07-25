data "aws_iam_policy_document" "base_ssm_kms_policy" {
  statement {
    sid    = "Allow access for lambdas"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]
    resources = [
      "arn:aws:kms:${var.aws_region}:${var.aws_account_id}:key/*",
      "arn:aws:kms:${var.aws_region}:${var.aws_account_id}:alias/${var.lambda_function_name}-cloudwatch"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test = "ArnLike"
      values = [
        "arn:aws:iam::${var.aws_account_id}:role/${var.lambda_function_name}"
      ]
      variable = "aws:PrincipalArn"
    }
  }
}

resource "aws_kms_key" "api_key" {
  description         = "${var.lambda_function_name}-creds"
  policy              = data.aws_iam_policy_document.kms_policy.json
  enable_key_rotation = true
}

resource "aws_kms_alias" "api_key" {
  target_key_id = aws_kms_key.api_key.id
  name          = "alias/redpanda/lambda/${var.lambda_function_name}"
}

resource "aws_secretsmanager_secret" "this" {
  name                    = "${var.lambda_function_name}_credentials"
  kms_key_id              = aws_kms_key.api_key.arn
  recovery_window_in_days = var.ssm_recovery_window_in_days
}

data "aws_iam_policy_document" "kms_policy" {
  source_policy_documents = concat(
    [
      var.base_kms_policy_json,
      data.aws_iam_policy_document.base_ssm_kms_policy.json
    ],
  var.additional_kms_policies)
}
