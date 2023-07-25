// build the binary for the lambda function in a specified path
resource "null_resource" "function_binary" {
  triggers = {
    build_number = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOT
    cd ${var.module_path}
    go version
    go mod tidy
    export CGO_ENABLED=0
    export GOARCH=amd64
    export GOOS=linux
    go build -mod=readonly -ldflags='-s -w' -o bootstrap
    EOT
  }
}

// zip the binary, as we can use only zip files to AWS lambda
data "archive_file" "lambda" {
  depends_on  = [null_resource.function_binary]
  type        = "zip"
  source_file = "${var.module_path}/bootstrap"
  output_path = "bootstrap.zip"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.cloudwatch_logging_kms_key_id
}

resource "aws_lambda_function" "lambda" {
  filename                       = data.archive_file.lambda.output_path
  source_code_hash               = data.archive_file.lambda.output_base64sha256
  function_name                  = var.lambda_function_name
  role                           = var.lambda_role_arn
  handler                        = "bootstrap"
  runtime                        = "provided.al2"
  timeout                        = var.lambda_timeout
  reserved_concurrent_executions = var.reserved_concurrent_executions
  tracing_config {
    mode = "Active"
  }
  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids
  }
  tags = var.tags
  environment {
    variables = var.environment_variables
  }
  depends_on = [
    null_resource.function_binary,
    data.archive_file.lambda,
    aws_cloudwatch_log_group.log_group
  ]
}
