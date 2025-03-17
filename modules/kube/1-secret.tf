resource "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql-secret"
    namespace = "default"
  }
  data = {
    MYSQL_USER = base64encode(var.mysql_username)
    MYSQL_PASSWORD = base64encode(var.mysql_password)
    MYSQL_ROOT_PASSWORD = base64encode(var.mysql_password)
  }
  type = "Opaque"
}

resource "kubernetes_secret" "mercado_pago_secret" {
  metadata {
    name      = "mercado-pago-secret"
    namespace = "default"
  }
  data = {
    MERCADO_PAGO_API_KEY = base64encode(var.mercado_pago_api_key)
    ID_LOJA = base64encode(var.mercado_pago_id_loja)
    ID_CONTA = base64encode(var.mercado_pago_id_conta)
  }
  type = "Opaque"
}
