# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "gleam-test-table"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# DynamoDB Table
resource "aws_dynamodb_table" "test_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST" # On-demand pricing
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S" # String
  }
  tags = {
    Name        = var.table_name
    Environment = var.environment
    Project     = "gleam-dynamodb-client"
  }
}

# Output the table details
output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.test_table.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.test_table.arn
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

# IAM User for testing (optional - you can use existing credentials)
resource "aws_iam_user" "dynamodb_test_user" {
  name = "gleam-dynamodb-test-user"
  path = "/"

  tags = {
    Name        = "DynamoDB Test User"
    Environment = var.environment
    Project     = "gleam-dynamodb-client"
  }
}

# IAM Policy for DynamoDB access
resource "aws_iam_policy" "dynamodb_policy" {
  name        = "gleam-dynamodb-test-policy"
  path        = "/"
  description = "IAM policy for DynamoDB access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = aws_dynamodb_table.test_table.arn
      }
    ]
  })
}

# Attach policy to user
resource "aws_iam_user_policy_attachment" "dynamodb_policy_attachment" {
  user       = aws_iam_user.dynamodb_test_user.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

# Create access keys (be careful with these in production!)
resource "aws_iam_access_key" "dynamodb_test_key" {
  user = aws_iam_user.dynamodb_test_user.name
}

# Output credentials (handle carefully!)
output "access_key_id" {
  description = "Access key ID for DynamoDB user"
  value       = aws_iam_access_key.dynamodb_test_key.id
  sensitive   = false # Set to true in production
}

output "secret_access_key" {
  description = "Secret access key for DynamoDB user"
  value       = aws_iam_access_key.dynamodb_test_key.secret
  sensitive   = true
}

# Sample data (optional)
resource "aws_dynamodb_table_item" "sample_item" {
  table_name = aws_dynamodb_table.test_table.name
  hash_key   = aws_dynamodb_table.test_table.hash_key

  item = jsonencode({
    id = {
      S = "test-user-123"
    }
    name = {
      S = "John Doe"
    }
    email = {
      S = "john.doe@example.com"
    }
    age = {
      N = "30"
    }
    active = {
      BOOL = true
    }
  })
}
