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
          aws_region                  = var.aws_region
        }
        data = {
          name             = local.prefix
          vpc_id           = module.vpc.vpc_id
          eks_cluster_name = module.eks.cluster_name
        }
      }
    })
  ]
}

##############################
##### EXTERNAL-DNS
##############################
module "external_dns_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "v1.11.0"

  name                          = "aws-external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [local.hosted_zone_arn]
  associations = {
    external-dns = {
      cluster_name    = module.eks.cluster_name
      namespace       = "external-dns"
      service_account = "external-dns"
    }
  }
}

##############################
##### EXTERNAL SECRETS
##############################
module "external_secrets_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "v1.11.0"

  name = "external-secrets"

  attach_external_secrets_policy        = true
  external_secrets_secrets_manager_arns = ["arn:aws:secretsmanager:${var.aws_region}:*:*:*"]

  associations = {
    external-secrets = {
      cluster_name    = module.eks.cluster_name
      namespace       = "external-secrets"
      service_account = "external-secrets"
    }
  }
}

##############################
##### ALB CONTROLLER
##############################
module "aws_lb_controller_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "v1.11.0"

  name = "aws-load-balancer-controller"

  attach_aws_lb_controller_policy = true

  associations = {
    alb = {
      cluster_name    = module.eks.cluster_name
      namespace       = "kube-system"
      service_account = "aws-load-balancer-controller"
    }
  }
}
