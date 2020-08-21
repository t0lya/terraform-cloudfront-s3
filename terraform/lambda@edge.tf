data "archive_file" "origin_request_lambda_zip" {
  type        = "zip"
  source_dir  = "../lambda/origin-request"
  output_path = "../origin-request.zip"
}

data "archive_file" "origin_response_lambda_zip" {
  type        = "zip"
  source_dir  = "../lambda/origin-response"
  output_path = "../origin-response.zip"
}

resource "aws_iam_role" "lambda_edge_role" {
  name = "lambda_edge_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_edge_policy" {
  name = "lambda_edge_policy"
  role = aws_iam_role.lambda_edge_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogGroup"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_lambda_function" "origin_request_lambda" {
  filename         = data.archive_file.origin_request_lambda_zip.output_path
  source_code_hash = data.archive_file.origin_request_lambda_zip.output_base64sha256
  function_name    = "origin_request_lambda"
  role             = aws_iam_role.lambda_edge_role.arn
  handler          = "index.handler"
  runtime          = "nodejs10.x"
  publish          = true
  timeout          = 30
}

resource "aws_lambda_function" "origin_response_lambda" {
  filename         = data.archive_file.origin_response_lambda_zip.output_path
  source_code_hash = data.archive_file.origin_response_lambda_zip.output_base64sha256
  function_name    = "origin_response_lambda"
  role             = aws_iam_role.lambda_edge_role.arn
  handler          = "index.handler"
  runtime          = "nodejs10.x"
  publish          = true
  timeout          = 30
}
