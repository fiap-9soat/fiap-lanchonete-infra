terraform {
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
  }
}
data "kubernetes_service" "fiap_lanchonete_lb" {
  metadata {
    name      = "fiap-lanchonete-lb"
    namespace = "default"
  }
}

resource "time_sleep" "wait_5min" {
  create_duration = "5m"
}

data "aws_lb" "fiap_lanchonete_nlb" {
  depends_on = [data.kubernetes_service.fiap_lanchonete_lb]
}

# Create API Gateway VPC Link
# This will error out if 'nlb' is not 'READY'
resource "aws_api_gateway_vpc_link" "fiap_lanchonete_vpc_link" {
  name        = "fiap-lanchonete-vpc-link"
  target_arns = [data.aws_lb.fiap_lanchonete_nlb.arn]
  depends_on  = [time_sleep.wait_5min]
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

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  depends_on = [aws_api_gateway_method.any_method, aws_api_gateway_vpc_link.fiap_lanchonete_vpc_link]
}
