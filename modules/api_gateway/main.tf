# Deploy the API
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.fiap_lanchonete_api.id
  stage_name  = "prod"

  lifecycle {
    # https://github.com/hashicorp/terraform-provider-aws/issues/12195
    create_before_destroy = true
  }

  depends_on = [aws_api_gateway_integration.proxy_integration]
}

