# Terraform AWS Code for Redpanda Lambda Ingest functions


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >=2.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.42.0 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | >=3.18.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >=3.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.9.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamodb-cdc-sync"></a> [dynamodb-cdc-sync](#module\_dynamodb-cdc-sync) | ./modules/lambda | n/a |
| <a name="module_event-bridge-rudderstack_sync"></a> [event-bridge-rudderstack\_sync](#module\_event-bridge-rudderstack\_sync) | terraform-aws-modules/eventbridge/aws | 2.3.0 |
| <a name="module_rudderstack_sync"></a> [rudderstack\_sync](#module\_rudderstack\_sync) | ./modules/lambda | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.cloudwatch_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.cloudwatch_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_event_source_mapping.allow_dynamodb_table_to_trigger_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.base_cloudwatch_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.base_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.rudderstack](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.rudderstack_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret_version.datadog_api_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.datadog_app_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_subnets.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpcs.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpcs) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | Name of the account, acceptable values are listed in https://github.com/P-Olympus/terraform-aws-tagging/blob/main/variables.tf | `string` | n/a | yes |
| <a name="input_additional_kms_policies"></a> [additional\_kms\_policies](#input\_additional\_kms\_policies) | List of additional KMS policies to add to the base policy | `list(any)` | `[]` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Map for adding extra optional tags | `map(string)` | `{}` | no |
| <a name="input_ci_runner_role_name"></a> [ci\_runner\_role\_name](#input\_ci\_runner\_role\_name) | CI Runner AWS Role Name | `string` | `""` | no |
| <a name="input_dd_api_key_name"></a> [dd\_api\_key\_name](#input\_dd\_api\_key\_name) | Datadog API key name | `string` | n/a | yes |
| <a name="input_dd_app_key_name"></a> [dd\_app\_key\_name](#input\_dd\_app\_key\_name) | Datadog APP key name | `string` | n/a | yes |
| <a name="input_dd_capture_lambda_payload"></a> [dd\_capture\_lambda\_payload](#input\_dd\_capture\_lambda\_payload) | Enable Datadog capture lambda payload | `bool` | `true` | no |
| <a name="input_dd_flush_to_log"></a> [dd\_flush\_to\_log](#input\_dd\_flush\_to\_log) | Enable Datadog flush to log | `bool` | `true` | no |
| <a name="input_dd_log_level"></a> [dd\_log\_level](#input\_dd\_log\_level) | Datadog log level | `string` | `"info"` | no |
| <a name="input_dd_merge_xray_traces"></a> [dd\_merge\_xray\_traces](#input\_dd\_merge\_xray\_traces) | Enable Datadog Xray Traces Merges | `bool` | `false` | no |
| <a name="input_dd_profiling_enabled"></a> [dd\_profiling\_enabled](#input\_dd\_profiling\_enabled) | Enable Datadog Profiling | `bool` | `false` | no |
| <a name="input_dd_serverless_logs_enabled"></a> [dd\_serverless\_logs\_enabled](#input\_dd\_serverless\_logs\_enabled) | Enable Datadog serverless logs | `bool` | `true` | no |
| <a name="input_dd_site"></a> [dd\_site](#input\_dd\_site) | Datadog site | `string` | `"datadoghq.eu"` | no |
| <a name="input_dd_trace_debug"></a> [dd\_trace\_debug](#input\_dd\_trace\_debug) | Enable Datadog Xray Traces debug | `bool` | `false` | no |
| <a name="input_dd_trace_enabled"></a> [dd\_trace\_enabled](#input\_dd\_trace\_enabled) | Enable Datadog tracing | `bool` | `false` | no |
| <a name="input_kafka_vpc_cidr"></a> [kafka\_vpc\_cidr](#input\_kafka\_vpc\_cidr) | CIDR block for kafka vpc | `string` | n/a | yes |
| <a name="input_key_admins"></a> [key\_admins](#input\_key\_admins) | Emergency secret key admin arns | `list(string)` | `[]` | no |
| <a name="input_kms_deletion_window_in_days"></a> [kms\_deletion\_window\_in\_days](#input\_kms\_deletion\_window\_in\_days) | The number of days to wait before deleting a CMK that has been removed from a CloudFormation stack. Default is 14 days. | `number` | `14` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Log level for the lambda function | `string` | `"INFO"` | no |
| <a name="input_parallelization_factor"></a> [parallelization\_factor](#input\_parallelization\_factor) | The number of shards to create for the stream. The default value is 1. | `number` | `2` | no |
| <a name="input_rudderstack_account_ids"></a> [rudderstack\_account\_ids](#input\_rudderstack\_account\_ids) | The AWS account ID of the Rudderstack account | `list(string)` | `[]` | no |
| <a name="input_source_dynamodb_table_arns"></a> [source\_dynamodb\_table\_arns](#input\_source\_dynamodb\_table\_arns) | List of DynamoDB table ARNs to allow access to | `list(string)` | `[]` | no |
| <a name="input_ssm_recovery_window_in_days"></a> [ssm\_recovery\_window\_in\_days](#input\_ssm\_recovery\_window\_in\_days) | Secrets Manager recovery\_window\_in\_days | `number` | `14` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
