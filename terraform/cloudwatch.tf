# CloudWatch log groups (automatically created but we can define explicitly for retention)
resource "aws_cloudwatch_log_group" "contact_lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.contact_form_handler.function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "analytics_lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.visitor_logger.function_name}"
  retention_in_days = 14
}

# Alarm: Contact form Lambda errors > 1 in 5 mins
resource "aws_cloudwatch_metric_alarm" "contact_lambda_errors" {
  alarm_name          = "ContactLambdaErrorAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when contact Lambda function errors > 1 in 5 minutes"
  dimensions = {
    FunctionName = aws_lambda_function.contact_form_handler.function_name
  }
}

# Alarm: Analytics Lambda errors > 1 in 5 mins
resource "aws_cloudwatch_metric_alarm" "analytics_lambda_errors" {
  alarm_name          = "AnalyticsLambdaErrorAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when analytics Lambda function errors > 1 in 5 minutes"
  dimensions = {
    FunctionName = aws_lambda_function.visitor_logger.function_name
  }
}



resource "aws_sns_topic" "alerts" {
  name = "lambda-alerts-topic"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "pawar.ritesh2018@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "contact_lambda_errors_secondary" {
  alarm_name          = "ContactLambdaErrorAlarmSecondary"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when contact Lambda function errors > 1 in 5 minutes"
  dimensions = {
    FunctionName = aws_lambda_function.contact_handler.function_name
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
}
