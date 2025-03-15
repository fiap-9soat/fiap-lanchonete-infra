# Recupera o user_pool criado no '-auth'
data "aws_cognito_user_pools" "cognito_user_pools" {
  name = var.cognito_user_pool_name
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
