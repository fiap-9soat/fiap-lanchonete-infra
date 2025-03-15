resource "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql-secret"
    namespace = "default"
  }
  data = {
    username = base64encode(var.mysql_username)
    password = base64encode(var.mysql_password)
  }
  type = "Opaque"
}

resource "kubernetes_secret" "mercado_pago_secret" {
  metadata {
    name      = "mercado-pago-secret"
    namespace = "default"
  }
  data = {
    api_key = base64encode(var.mercado_pago_api_key)
  }
  type = "Opaque"
}