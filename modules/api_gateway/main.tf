data "aws_cognito_user_pools" "cognito_user_pools" {
  name = var.cognito_user_pool_name
}

data "kubernetes_service" "fiap_lanchonete_lb" {
  metadata {
    name      = "fiap-lanchonete-lb"
    namespace = "default"
  }
}

data "aws_lb" "fiap_lanchonete_nlb" {
  depends_on = [data.kubernetes_service.fiap_lanchonete_lb]
}

# Create API Gateway VPC Link
resource "aws_api_gateway_vpc_link" "fiap_lanchonete_vpc_link" {
  name = "fiap-lanchonete-vpc-link"
  target_arns = [data.aws_lb.fiap_lanchonete_nlb.arn]
}

resource "aws_api_gateway_rest_api" "fiap_lanchonete_api" {
  name = "fiap-lanchonete-api"
}

# Proxy all requests to source (eks cluster)
resource "aws_api_gateway_resource" "root_resource" {
  rest_api_id = aws_api_gateway_rest_api.fiap_lanchonete_api.id
  parent_id   = aws_api_gateway_rest_api.fiap_lanchonete_api.root_resource_id
  path_part   = "{proxy+}"
}

# Define the ANY method for the root resource
resource "aws_api_gateway_method" "any_method" {
  rest_api_id   = aws_api_gateway_rest_api.fiap_lanchonete_api.id
  resource_id   = aws_api_gateway_resource.root_resource.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
  depends_on = [aws_api_gateway_authorizer.cognito_authorizer]
}

# Define integration with the backend via VPC Link
resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.fiap_lanchonete_api.id
  resource_id             = aws_api_gateway_resource.root_resource.id
  http_method             = aws_api_gateway_method.any_method.http_method
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.fiap_lanchonete_nlb.dns_name}/{proxy}"
  integration_http_method = "ANY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.fiap_lanchonete_vpc_link.id
  passthrough_behavior    = "WHEN_NO_MATCH"

  depends_on = [aws_api_gateway_method.any_method, aws_api_gateway_vpc_link.fiap_lanchonete_vpc_link]
}

# Use Cognito as Authorization method for the API
resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name            = "cognito-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.fiap_lanchonete_api.id
  authorizer_uri  = "arn:aws:apigateway:${var.aws_region}:cognito-idp:action/Authorize"
  identity_source = "method.request.header.Authorization"
  provider_arns   = data.aws_cognito_user_pools.cognito_user_pools.arns
  type            = "COGNITO_USER_POOLS"
  depends_on = [data.aws_cognito_user_pools.cognito_user_pools]
}


# Deploy the API
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.fiap_lanchonete_api.id
  stage_name  = "prod"

  depends_on = [aws_api_gateway_integration.proxy_integration]
}

