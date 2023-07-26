data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  tags = {
    Name = var.subnet_name
  }
}

data "aws_vpcs" "vpc" {}

data "aws_vpc" "this" {
  id = tolist(data.aws_vpcs.vpc.ids)[0]
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "lambda_execution_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "cloudwatch:PutMetricData",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DeleteNetworkInterface",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses",
      "secretsmanager:GetSecretValue",
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords"
    ]
  }
  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]

    resources = [
      "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:alias/*",
      "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:key/*"
    ]
  }

  dynamic "statement" {
    for_each = var.source_dynamodb_table_arns

    content {
      effect = "Allow"
      actions = [
        "dynamodb:BatchGetItem",
        "dynamodb:GetItem",
        "dynamodb:GetRecords",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:GetShardIterator",
        "dynamodb:DescribeStream",
        "dynamodb:ListStreams"
      ]
      resources = [
        statement.value,
        "${statement.value}/*"
      ]
    }
  }
}

data "aws_iam_policy_document" "base_kms_policy" {
  statement {
    sid = "Enable CI User"
    principals {
      identifiers = [local.ci_arn]
      type        = "AWS"
    }
    actions = [
      "kms:*"
    ]
    resources = [
      "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:key/*",
      "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:alias/${local.generic_name}-*"
    ]
  }

  statement {
    sid     = "Allow access for Key SSO Administrators"
    effect  = "Allow"
    actions = ["kms:*"]
    resources = [
      "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:key/*",
      "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:alias/${local.generic_name}-*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "ArnLike"
      values   = var.key_admins
      variable = "aws:PrincipalArn"
    }
  }
}
