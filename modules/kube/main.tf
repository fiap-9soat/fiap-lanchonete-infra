# Deploy AWS Load Balancer Controller using Helm
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.4.5"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }
}

# Kubernetes Service with NLB annotations
resource "kubernetes_service" "fiap_lanchonete_lb" {
  metadata {
    name      = "fiap-lanchonete-lb"
    namespace = "default"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"                = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-internal"            = "false"
      "service.beta.kubernetes.io/aws-load-balancer-scheme"              = "internet-facing"
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" = "true"
    }
  }

  spec {
    selector = {
      app = "fiap-lanchonete"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_config_map" "mercado_pago_config" {
  metadata {
    name = "mercado-pago-config"
  }
  data = {
    MERCADO_PAGO_URL = "https://api.mercadopago.com/"
    URL_NOTIFICACAO  = "https://www.yourserver.com/notifications"
  }
}

resource "kubernetes_deployment" "fiap_lanchonete_deployment" {
  metadata {
    name = "fiap-lanchonete"
  }
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
          image = "lamarcke/fiap-lanchonete:1.0.2.1"
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
          # TODO: Pegar URL do banco com data
          env {
            name  = "DB_URL"
            value = "mysql:3306"
          }
        }
      }
    }
  }
}