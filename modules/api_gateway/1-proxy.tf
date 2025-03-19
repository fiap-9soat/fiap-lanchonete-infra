# Proxy all requests to source (eks cluster)
resource "aws_api_gateway_resource" "root_resource" {
  rest_api_id = aws_api_gateway_rest_api.fiap_lanchonete_api.id
  parent_id   = aws_api_gateway_rest_api.fiap_lanchonete_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "any_method" {
  rest_api_id   = aws_api_gateway_rest_api.fiap_lanchonete_api.id
  resource_id   = aws_api_gateway_resource.root_resource.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true
  }

  depends_on = [aws_api_gateway_authorizer.cognito_authorizer]
}
