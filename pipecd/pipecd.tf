variable "namespace" {
  default = "pipecd"
}

data "external" "pipecd-secrets" {
  program = ["helm", "secrets", "decrypt", "--terraform", "${path.module}/config/secrets.yaml"]
}

resource "helm_release" "pipecd" {
  name       = var.namespace
  repository = "oci://ghcr.io/pipe-cd/chart"
  chart      = "pipecd"
  version    = "v0.45.4"
  namespace = var.namespace
  create_namespace = true
  
  values = [
    file("${path.module}/config/values.yaml"),
    base64decode(data.external.pipecd-secrets.result.content_base64)
  ]
}
