// create a policy to allow writing into logs and create logs stream
resource "aws_iam_policy" "lambda_policy" {
  name        = local.generic_name
  description = "Policy for lambda ${local.generic_name}"
  policy      = data.aws_iam_policy_document.lambda_execution_policy.json
}

// attach policy to out created lambda role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda.id
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role" "lambda" {
  name               = local.generic_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}