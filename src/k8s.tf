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

resource "kubernetes_secret_v1" "argocd_cluster_bootstrap" {
  depends_on = [helm_release.argocd]

  type = "Opaque"

  metadata {
    name      = "cluster-secret-bootstrap"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }

    annotations = {
      environment                 = var.environment
      gitops_repo_url             = var.gitops_repo_url
      gitops_repo_addons_basepath = var.gitops_repo_addons_basepath
      gitops_repo_revision        = var.gitops_repo_revision
    }
  }

  data = {
    name   = local.prefix
    server = "https://kubernetes.default.svc" # module.eks.cluster_endpoint
    config = <<-EOF
        {
            "tlsClientConfig": {
                "insecure": false
            }
        }
    EOF
  }
}

resource "kubernetes_manifest" "app_of_apps" {
  depends_on = [helm_release.argocd]
  manifest   = yamldecode(file("../k8s/bootstrap/app-of-apps.yaml"))
}
