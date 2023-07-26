output "function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "function_arn" {
  value = aws_lambda_function.lambda.arn
}

output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.log_group.arn
}
