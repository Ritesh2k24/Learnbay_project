resource "aws_apigatewayv2_api" "contact_api" {
  name          = "ContactFormAPI"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST", "OPTIONS"]
    allow_headers = ["content-type"]
  }
}

# Contact form Lambda integration
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                = aws_apigatewayv2_api.contact_api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = aws_lambda_function.contact_form_handler.invoke_arn
  integration_method    = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "contact_route" {
  api_id    = aws_apigatewayv2_api.contact_api.id
  route_key = "POST /submit"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.contact_form_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.contact_api.execution_arn}/*/*"
}

# Analytics Lambda integration
resource "aws_apigatewayv2_integration" "analytics_integration" {
  api_id                = aws_apigatewayv2_api.contact_api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = aws_lambda_function.visitor_logger.invoke_arn
  integration_method    = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "analytics_route" {
  api_id    = aws_apigatewayv2_api.contact_api.id
  route_key = "POST /analytics"
  target    = "integrations/${aws_apigatewayv2_integration.analytics_integration.id}"
}

resource "aws_lambda_permission" "apigw_analytics_lambda" {
  statement_id  = "AllowExecutionFromAPIGatewayAnalytics"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_logger.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.contact_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.contact_api.id
  name        = "$default"
  auto_deploy = true
}

output "analytics_api_url" {
  value = "${aws_apigatewayv2_api.contact_api.api_endpoint}"
}
