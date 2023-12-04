variable "namespace" {
  default = "pipecd-local"
}

data "external" "pipecd-local-secrets" {
  program = ["helm", "secrets", "decrypt", "--terraform", "${path.module}/config/secrets.yaml"]
}

resource "helm_release" "pipecd-local" {
  name       = var.namespace
  chart      = "${path.root}/../pipecd/manifests/pipecd"
  namespace = var.namespace
  create_namespace = true
  timeout = 240

  values = [
    file("${path.module}/config/values.yaml"),
    base64decode(data.external.pipecd-local-secrets.result.content_base64)
  ]
}
