data "kubernetes_service" "fiap_lanchonete_lb" {
  metadata {
    name      = "fiap-lanchonete-lb"
    namespace = "default"
  }
}

data "aws_lb" "fiap_lanchonete_nlb" {
  depends_on = [data.kubernetes_service.fiap_lanchonete_lb]
}

resource "null_resource" "wait_for_nlb" {
  provisioner "local-exec" {
    command = <<EOT
              AWS_REGION=${var.aws_region}\
              AWS_ACCESS_KEY_ID=${var.aws_access_key}\
              AWS_SECRET_ACCESS_KEY=${var.aws_secret_key}\
              AWS_SESSION_TOKEN=${var.aws_token_key}\
              aws elbv2 wait load-balancer-available --load-balancer-arn ${data.aws_lb.fiap_lanchonete_nlb.arn}
              EOT
  }
}

# Create API Gateway VPC Link
# This will error out if 'nlb' is not 'READY'
resource "aws_api_gateway_vpc_link" "fiap_lanchonete_vpc_link" {
  name  = "fiap-lanchonete-vpc-link"
  target_arns = [data.aws_lb.fiap_lanchonete_nlb.arn]
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
  connection_id           = "$${stageVariables.vpc_link_id}" //weird, but correct syntax!
  passthrough_behavior    = "WHEN_NO_MATCH"

  depends_on = [aws_api_gateway_method.any_method, aws_api_gateway_vpc_link.fiap_lanchonete_vpc_link]
}
