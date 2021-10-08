data "archive_file" "toctoc_api_artefact" {
  output_path = "files/toctoc-api-artefact.zip"
  type        = "zip"
  source_file = "${local.lambdas_path}/toctoc-api/index.js"
}

resource "aws_lambda_function" "toctoc_api" {
  function_name = "toctoc_api"
  handler       = "index.handler"
  description   = "integration to adalo API with toctoc backend"
  role          = aws_iam_role.toctoc_api_lambda.arn
  runtime       = "nodejs14.x"

  filename         = data.archive_file.toctoc_api_artefact.output_path
  source_code_hash = data.archive_file.toctoc_api_artefact.output_base64sha256

  timeout     = 5
  memory_size = 128

  layers = [aws_lambda_layer_version.got.arn]
}
