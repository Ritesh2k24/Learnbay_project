resource "aws_dynamodb_table" "contact_submissions" {
  name           = "contact-submissions"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "prod"
    Name        = "ContactFormSubmissions"
  }
}


resource "aws_dynamodb_table" "visitor_analytics" {
  name         = "visitor-analytics"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "prod"
    Name        = "VisitorAnalytics"
  }
}
