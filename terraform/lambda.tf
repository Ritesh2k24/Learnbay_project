resource "aws_iam_role" "lambda_exec" {
  name = "lambda-contact-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamo_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_lambda_function" "contact_form_handler" {
  filename         = "lambda/contact_handler.zip"
  function_name    = "contactFormHandler"
  handler          = "contact_handler.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("${path.module}/lambda/contact_handler.zip")
}


resource "aws_lambda_function" "visitor_logger" {
  filename         = "lambda/visitor_logger.zip"
  function_name    = "visitorLogger"
  handler          = "visitor_logger.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("${path.module}/lambda/visitor_logger.zip")
}
