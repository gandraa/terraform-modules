# ===================================================== #
# - - - - - - - - -  Data Section - - - - - - - - - - - #
# ===================================================== #
data "aws_ssm_parameter" "dynatrace_api_key" {
  name    = "/infra/dynatrace/log_forwarder/log_ingest"
}

# ===================================================== #
# - - - - - - - - - - - S3 bucket - - - - - - - - - - - #
# ===================================================== #
resource "aws_s3_bucket" "delivery_bucket" {
  bucket = var.bucket_name
} 

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_configuration" {
  bucket = aws_s3_bucket.delivery_bucket.id

  rule {
    id = "${var.bucket_name}-rule-1"
    expiration {
      days = 7
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = aws_s3_bucket.delivery_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ===================================================== #
# - - - - - Delivery stream Role and Policies - - - - - #
# ===================================================== #
resource "aws_iam_role" "delivery_stream_role" {
  name               = "xbp-delivery-stream-role-${var.account_name}"
  assume_role_policy = file("${path.module}/../assets/policies/delivery-stream-assume-role.json")
}

resource "aws_iam_policy" "firehose_delivery_policy" {
  name              = "xbp-firehose-delivery-policy-${var.account_name}"
  policy            = templatefile("${path.module}/../assets/policies/firehose-delivery-policy.json", { delivery_bucket_arn = "${aws_s3_bucket.delivery_bucket.arn}"})
}

resource "aws_iam_policy" "firehose_lambda_invocation_policy" {
  name              = "xbp-firehose-lambda-invocation-policy-${var.account_name}"
  policy            = templatefile("${path.module}/../assets/policies/firehose-lambda-invocation-policy.json", { aws_region = var.aws_region, aws_account_id = var.aws_account_id, aws_lambda_function_name = aws_lambda_function.lambda_dynatrace.function_name })
}

resource "aws_iam_role_policy_attachment" "firehose_delivery_policy_attachment" {
  role              = aws_iam_role.delivery_stream_role.name
  policy_arn        = aws_iam_policy.firehose_delivery_policy.arn
}

resource "aws_iam_role_policy_attachment" "firehose_lambda_invocation_attachment" {
  role              = aws_iam_role.delivery_stream_role.name
  policy_arn        = aws_iam_policy.firehose_lambda_invocation_policy.arn
}


# ===================================================== #
# - - - - - - - - Lambda Role and Policies - - - - - -  #
# ===================================================== #
resource "aws_iam_role" "lambda_role" {
  name                = "xbp-lambda-role-${var.account_name}"
  assume_role_policy  = file("${path.module}/../assets/policies/lambda-assume-role.json")
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
}

resource "aws_iam_policy" "cloudwatch_put_metric_data_policy" {
  name    = "cloudwatch-put-metric-data-policy"
  policy  = file("${path.module}/../assets/policies/cloudwatch-put-metric-data.json")
}

resource "aws_iam_role_policy_attachment" "put_metric_data_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.cloudwatch_put_metric_data_policy.arn
}


# ===================================================== #
# -  - - - - CloudWatch Logs Role and Policies - - - - - #
# ===================================================== #
resource "aws_iam_role" "cloudwatch_logs_role" {
  name               = "dynatrace_cloudwatch_logs_role"
  assume_role_policy = file("${path.module}/../assets/policies/dynatrace-cloudwatch-logs-assume-role.json")
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name   = "dynatrace_cloudwatch_logs_policy"
  policy = templatefile("${path.module}/../assets/policies/dynatrace-cloudwatch-logs-policy.json", { firehose_metric_streams_arn = "${aws_kinesis_firehose_delivery_stream.firehose_log_streams.arn}"})
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy_attatch" {
  role       = aws_iam_role.cloudwatch_logs_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

# ===================================================== #
# - - - - AWS Kinesis Firehose Delivery Stream - - - -  #
# ===================================================== #
resource "aws_kinesis_firehose_delivery_stream" "firehose_log_streams" {
  name        = "xbp_firehose_log_streams"
  destination = "extended_s3"

  extended_s3_configuration {
    bucket_arn  = aws_s3_bucket.delivery_bucket.arn
    role_arn    = aws_iam_role.delivery_stream_role.arn

    prefix                   = "success-"
    error_output_prefix      = "error-"
    compression_format       = "GZIP"
    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = aws_lambda_function.lambda_dynatrace.arn
        }
        parameters {
          parameter_name  = "BufferSizeInMBs"          
          parameter_value = "3"        
          }

        parameters {
          parameter_name  = "BufferIntervalInSeconds"
          parameter_value = "60"
        }
      }
    }
  }
}


# ===================================================== #
# - - - - AWS Cloudwatch Subscription Filter - - - - -  #
# ===================================================== #
resource "aws_cloudwatch_log_subscription_filter" "kinesis_firehose_logfilter" {
  for_each        = toset(var.log_group_name)
  name            = join("-",[substr(replace(each.key, "/","-"), 1, length(each.key) - 1),"subscription"])
  log_group_name  = each.key
  filter_pattern  = ""
  role_arn        = aws_iam_role.cloudwatch_logs_role.arn
  destination_arn = aws_kinesis_firehose_delivery_stream.firehose_log_streams.arn
}


# ===================================================== #
# - - - - - - - - AWS Lambda Function - - - - - - - - - #
# ===================================================== #
resource "aws_lambda_function" "lambda_dynatrace" {
  function_name              = var.lambda_function_name
  filename                   = var.lambda_output_path
  handler                    = "index.handler"
  runtime                    = "python3.8"
  memory_size                = 256
  timeout                    = 60
  role                       = aws_iam_role.lambda_role.arn
  source_code_hash           = data.archive_file.lambda_dynatrace_archive_file.output_base64sha256

  environment {
    variables = {
      DEBUG                  = "false"
      DYNATRACE_API_KEY      = data.aws_ssm_parameter.dynatrace_api_key.value
      DYNATRACE_ENV_URL      = var.dynatrace_environment_url
      VERIFY_SSL             = var.verify_ssl_target_activegate
      MAX_LOG_CONTENT_LENGTH = var.max_log_content_length
      CLOUD_LOG_FORWARDER    = join(":", [var.aws_account_id, var.aws_region])
    }
  }
}

# ===================================================== #
# - - - - - - - -  ZIP LAMBDA SOURCES - - - - - - - - - #
# ===================================================== #
data "archive_file" "lambda_dynatrace_archive_file" {
  type             = "zip"
  source_dir       = var.lambda_source_dir
  output_file_mode = "0666"
  output_path      = var.lambda_output_path
}