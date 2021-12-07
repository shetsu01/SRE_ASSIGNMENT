data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
    statement {
    actions    = ["sts:AssumeRole"]
    effect     = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }

}



data "aws_dynamodb_table" "http-crud-assignment-items" {
  depends_on = [
    module.dynamodb_table
  ]
  name = "http-crud-assignment-items"
}

resource "aws_iam_role" "terraform_function_role" {
  name               = local.role_name
  assume_role_policy = "${data.aws_iam_policy_document.AWSLambdaTrustPolicy.json}"
  inline_policy {
    name = "DynamoDB_Table"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["dynamodb:*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}
