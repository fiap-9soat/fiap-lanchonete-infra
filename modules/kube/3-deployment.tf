resource "kubernetes_deployment" "fiap_lanchonete_deployment" {
  metadata {
    name = "fiap-lanchonete"
  }
  wait_for_rollout = true

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "fiap-lanchonete"
      }
    }
    template {
      metadata {
        labels = {
          app = "fiap-lanchonete"
        }
      }
      spec {
        container {
          name  = "fiap-lanchonete"
          image = "lamarcke/fiap-lanchonete:1.0.6"
          port {
            container_port = 8080
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map.mercado_pago_config.metadata[0].name
            }
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.mysql_secret.metadata[0].name
            }
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.mercado_pago_secret.metadata[0].name
            }
          }
          env {
            name  = "DB_URL"
            value = var.mysql_url
          }
          env {
            name  = "ID_CONTA"
            value = var.mercado_pago_id_conta
          }
        }
      }
    }
  }
}
