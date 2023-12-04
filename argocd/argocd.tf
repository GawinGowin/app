variable "namespace" {
  default = "argocd"
}

resource "helm_release" "argo" {
  name       = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace = var.namespace
  create_namespace = true
  values = [
    file("${path.module}/config/values.yaml"),
  ]
}

data "kubernetes_service" "argo" {
  depends_on = [helm_release.argo]
  metadata {
    name = "argocd-server"
    namespace = var.namespace
  }
}
