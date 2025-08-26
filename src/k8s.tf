##############################
##### BOOTSTRAP
##############################
resource "helm_release" "argocd" {
  depends_on = [module.eks]

  name             = "argocd"
  description      = "Helm Chart to install ArgoCD via Terraform Helm Provider"
  namespace        = "argocd"
  create_namespace = true
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  repository       = "https://argoproj.github.io/argo-helm"
}

resource "helm_release" "gitops_bridge" {
  depends_on = [helm_release.argocd]

  name             = "gitops-bridge"
  description      = "Bridge the gap between Iac and GitOps"
  namespace        = "argocd"
  create_namespace = true
  chart            = "${path.module}/../k8s/chart/gitops-bridge"

  values = [
    yamlencode({
      namespace = "argocd"
      secret = {
        name = "cluster-secret-bootstrap"
        type = "Opaque"
        annotations = {
          gitops_repo_url             = var.gitops_repo_url
          gitops_repo_addons_basepath = var.gitops_repo_addons_basepath
          gitops_repo_revision        = var.gitops_repo_revision
          environment                 = var.environment
        }
        data = {
          name = local.prefix
        }
      }
    })
  ]
}
