# Lambda Function Deployment with Assume role

resource "aws_iam_role_policy_attachment" "terraform_lambda_policy" {
  role       = "${aws_iam_role.terraform_function_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "crud_function" {
  filename         = local.filename
  function_name    = local.function_name
  handler          = local.handler
  role             = "${aws_iam_role.terraform_function_role.arn}"
  runtime          = local.runtime
  source_code_hash = "${filebase64sha256("code/index.zip")}"
}