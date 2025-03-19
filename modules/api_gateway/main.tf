resource "null_resource" "previous" {}

resource "time_sleep" "wait_1_min" {
  depends_on = [null_resource.previous]

  create_duration = "60s"
}

# Deploy the API
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.fiap_lanchonete_api.id
  stage_name  = "prod"

  depends_on = [aws_api_gateway_integration.proxy_integration, time_sleep.wait_1_min]
}

