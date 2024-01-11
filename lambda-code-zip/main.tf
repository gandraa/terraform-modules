# ===================================================== #
# - - - - - - - -  ZIP LAMBDA SOURCES - - - - - - - - - #
# ===================================================== #
data "archive_file" "lambda" {
  type             = var.type
  source_dir       = var.source_dir
  output_file_mode = var.output_file_mode
  output_path      = var.output_path
}

# ===================================================== #
# - - - - - - - -  UPLOAD ZIP TO S3 - - - - - - - - - - #
# ===================================================== #
resource "aws_s3_object" "object" {
  bucket = var.bucket_name
  key    = var.s3_key
  source = var.object_source
  source_hash  = filemd5(data.archive_file.lambda.output_path)
}