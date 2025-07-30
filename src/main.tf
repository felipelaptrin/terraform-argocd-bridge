##############################
##### NETWORKING
##############################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v6.0.1"

  name = local.prefix
  cidr = var.vpc_cidr

  azs              = local.azs
  private_subnets  = local.private_subnets
  public_subnets   = local.public_subnets
  database_subnets = local.database_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  # VPC Requirements: https://docs.aws.amazon.com/eks/latest/userguide/network-reqs.html
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"       = "1"
    "kubernetes.io/cluster/${local.prefix}" = "owned"
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb"                = "1"
    "kubernetes.io/cluster/${local.prefix}" = "owned"
  }
}

##############################
##### KUBERNETES
##############################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "v21.0.1"

  name               = local.prefix
  kubernetes_version = var.k8s_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = false

  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    eks-pod-identity-agent = {
      addon_version = var.k8s_addons_versions["eks-pod-identity-agent"]
    }
    aws-ebs-csi-driver = {
      addon_version = var.k8s_addons_versions["aws-ebs-csi-driver"]
    }
  }

  # Allow SSM
  iam_role_additional_policies = {
    ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  # Best way to grant users access to Kubernetes API: https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html
  access_entries = {
    sso_admins = {
      principal_arn = "arn:aws:iam::937168356724:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_35d503478c27a34c"
      policy_associations = {
        sso_admins = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  # Using EKS-Optimized Images: https://aws.amazon.com/blogs/containers/amazon-eks-optimized-amazon-linux-2023-amis-now-available/
  eks_managed_node_groups = {
    general-purpose = {
      ami_type = "AL2023_ARM_64_STANDARD"
      instance_types = [
        "t3a.large"
      ]
      min_size     = 1
      max_size     = 1
      desired_size = 1
      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 1
      }
    }
  }
}

module "ingress_acm_certificate" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"

  domain_name = var.domain
  zone_id     = local.hosted_zone_id

  validation_method = "DNS"
  subject_alternative_names = [
    "*.${var.domain}",
  ]
  wait_for_validation = true
}
