
// HTTP API gateway creation

resource "aws_apigatewayv2_api" "http_api" {
  name          = local.apigateway_name
  protocol_type = local.protocol_type
  route_key     = local.route_key
  target        = aws_lambda_function.crud_function.arn
}

// Stage Creation


// Route creation

resource "aws_apigatewayv2_route" "get1" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /items/{id}"
  target = "integrations/${aws_apigatewayv2_integration.http_api.id}"
}

resource "aws_apigatewayv2_route" "get2" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /items"
  target = "integrations/${aws_apigatewayv2_integration.http_api.id}"

}

resource "aws_apigatewayv2_route" "put" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "PUT /items"
  target = "integrations/${aws_apigatewayv2_integration.http_api.id}"

}

resource "aws_apigatewayv2_route" "delete" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "DELETE /items/{id}"
  target = "integrations/${aws_apigatewayv2_integration.http_api.id}"

}

// Creates an integration

resource "aws_apigatewayv2_integration" "http_api" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_method     = "POST"
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.crud_function.invoke_arn
  payload_format_version = "2.0"
}

# ---------------------------------------------------------------------------------------------------------------------
# Allow Lambda to be invoked by the HTTP API (v2) gateway
# Provider Docs: https://www.terraform.io/docs/providers/aws/r/lambda_permission.html
# Additional Docs: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-troubleshooting-lambda.html
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lambda_permission" "http_api" {
  action        = "lambda:InvokeFunction"
  function_name = local.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}