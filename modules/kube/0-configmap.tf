resource "kubernetes_config_map" "mercado_pago_config" {
  metadata {
    name = "mercado-pago-config"
  }
  data = {
    MERCADO_PAGO_URL = "https://api.mercadopago.com/"
    URL_NOTIFICACAO  = "https://www.yourserver.com/notifications"
  }
}
