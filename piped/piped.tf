variable "namespace" {
  default = "piped"
}

data "external" "piped-secrets" {
  program = ["helm", "secrets", "decrypt", "--terraform", "${path.module}/config/secrets.yaml"]
}

resource "helm_release" "piped" {
  name       = "piped"
  repository = "oci://ghcr.io/pipe-cd/chart"
  chart      = "piped"
  version    = "v0.45.3"
  namespace = var.namespace
  create_namespace = true
  timeout = 120

  values = [
    base64decode(data.external.piped-secrets.result.content_base64)
  ]

  set {
    name  = "config.data"
    value = file("${path.module}/config/piped_config.yaml")
  }
}
