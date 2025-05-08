resource "aws_apigatewayv2_api" "contact_api" {
  name          = "ContactFormAPI"
  protocol_type = "HTTP"
}

# Contact Form Integration
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

resource "aws_apigatewayv2_integration_response" "contact_response" {
  api_id                   = aws_apigatewayv2_api.contact_api.id
  integration_id           = aws_apigatewayv2_integration.lambda_integration.id
  integration_response_key = "/200/"
  response_parameters = {
    "access-control-allow-origin" = "'*'"
  }
}

resource "aws_apigatewayv2_route_response" "contact_route_response" {
  api_id              = aws_apigatewayv2_api.contact_api.id
  route_id            = aws_apigatewayv2_route.contact_route.id
  route_response_key  = "200"
  response_parameters = {
    "access-control-allow-origin" = "'*'"
  }
}

# Contact Lambda Permission
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.contact_form_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.contact_api.execution_arn}/*/*"
}

# Analytics Integration
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

resource "aws_apigatewayv2_integration_response" "analytics_response" {
  api_id                   = aws_apigatewayv2_api.contact_api.id
  integration_id           = aws_apigatewayv2_integration.analytics_integration.id
  integration_response_key = "/200/"
  response_parameters = {
    "access-control-allow-origin" = "'*'"
  }
}

resource "aws_apigatewayv2_route_response" "analytics_route_response" {
  api_id              = aws_apigatewayv2_api.contact_api.id
  route_id            = aws_apigatewayv2_route.analytics_route.id
  route_response_key  = "200"
  response_parameters = {
    "access-control-allow-origin" = "'*'"
  }
}

# Analytics Lambda Permission
resource "aws_lambda_permission" "apigw_analytics_lambda" {
  statement_id  = "AllowExecutionFromAPIGatewayAnalytics"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_logger.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.contact_api.execution_arn}/*/*"
}

# Default Stage
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.contact_api.id
  name        = "$default"
  auto_deploy = true
}

# Output the API endpoint
output "analytics_api_url" {
  value = "${aws_apigatewayv2_api.contact_api.api_endpoint}/analytics"
}
