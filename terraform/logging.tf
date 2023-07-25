data "aws_iam_policy_document" "base_cloudwatch_kms_policy" {
  statement {
    sid    = "Allow general key access"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${local.aws_region}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [
      "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:key/*",
      "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:alias/${local.generic_name}-*"
    ]
  }

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test = "ArnLike"
      values = [
        "arn:aws:logs:${local.aws_region}:${local.aws_account_id}:log-group:${local.generic_name}-*"
      ]
      variable = "kms:EncryptionContext:aws:logs:arn"
    }
  }

  statement {
    sid    = "Allow access for lambdas"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]
    resources = [
      "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:key/*",
      "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:alias/${local.generic_name}-cloudwatch"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test = "ArnLike"
      values = [
        "arn:aws:iam::${local.aws_account_id}:role/${local.generic_name}-*"
      ]
      variable = "aws:PrincipalArn"
    }
  }
}

data "aws_iam_policy_document" "kms_policy" {
  source_policy_documents = concat(
    [
      data.aws_iam_policy_document.base_kms_policy.json,
      data.aws_iam_policy_document.base_cloudwatch_kms_policy.json
    ],
  var.additional_kms_policies)
}

resource "aws_kms_key" "cloudwatch_key" {
  description             = "${local.generic_name}-cloudwatch"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_policy.json
}

resource "aws_kms_alias" "cloudwatch_key_alias" {
  target_key_id = aws_kms_key.cloudwatch_key.id
  name          = "alias/${local.generic_name}-cloudwatch"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
