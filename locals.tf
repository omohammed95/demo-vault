locals {
  helm_values = [{
    vault = {
      # Injector isn't activated since it isn't used for now.
      # TODO when activated, manage CA bundle issue in "vault-agent-injector-cfg" making app go out-of-sync
      injector = {
        enabled = false
      }
      server = {
        dev = {
          enabled = true
        }
        ingress = {
          enabled = true
          annotations = {
            "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
            "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
            "traefik.ingress.kubernetes.io/router.tls"         = "true"
            "ingress.kubernetes.io/ssl-redirect"               = "true"
            "kubernetes.io/ingress.allow-http"                 = "false"
          }
          hosts = [
            {
              host = "vault.apps.${var.cluster_name}.${var.base_domain}"
            },
            {
              host = "vault.apps.${var.base_domain}"
            }
          ]
          tls = [
            {
              secretName = "vault-tls"
              hosts = [
                "vault.apps.${var.cluster_name}.${var.base_domain}",
                "vault.apps.${var.base_domain}"
              ]
            }
          ]
        }
      }
    }
  }]
}