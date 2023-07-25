provider "aws" {
  region = "af-south-1"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "ireland"
}

data "aws_secretsmanager_secret_version" "datadog_api_key" {
  secret_id = var.dd_api_key_name
}

data "aws_secretsmanager_secret_version" "datadog_app_key" {
  secret_id = var.dd_app_key_name
}

provider "datadog" {
  api_url  = "https://${var.dd_site}/"
  api_key  = data.aws_secretsmanager_secret_version.datadog_api_key.secret_string
  app_key  = data.aws_secretsmanager_secret_version.datadog_app_key.secret_string
  validate = true
}

terraform {
  required_version = ">= 1.3.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.42.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">=2.4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.2.1"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = ">=3.18.0"
    }
  }
  backend "s3" {
  }
}
