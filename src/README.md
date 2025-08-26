# src

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.11.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.65.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 3.0.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.38.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.65.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | v21.0.1 |
| <a name="module_external_dns_pod_identity"></a> [external\_dns\_pod\_identity](#module\_external\_dns\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | v1.11.0 |
| <a name="module_external_secrets_pod_identity"></a> [external\_secrets\_pod\_identity](#module\_external\_secrets\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | v1.11.0 |
| <a name="module_ingress_acm_certificate"></a> [ingress\_acm\_certificate](#module\_ingress\_acm\_certificate) | terraform-aws-modules/acm/aws | 5.1.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | v6.0.1 |

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/3.0.2/docs/resources/release) | resource |
| [helm_release.gitops_bridge](https://registry.terraform.io/providers/hashicorp/helm/3.0.2/docs/resources/release) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_chart_version"></a> [argocd\_chart\_version](#input\_argocd\_chart\_version) | The Helm Chart version used to install ArgoCD using Terraform | `string` | `"8.2.1"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region to deploy resources | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Route53 Domain - Hosted Zone - to be used. This resource should be created manually and will be just used in Terraform code as a data source. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment to deploy. It uses this name as the path of the Kubernetes manifests | `string` | n/a | yes |
| <a name="input_gitops_repo_addons_basepath"></a> [gitops\_repo\_addons\_basepath](#input\_gitops\_repo\_addons\_basepath) | Base Path of the repository that contains the Kubernetes manifests for the addons | `string` | n/a | yes |
| <a name="input_gitops_repo_revision"></a> [gitops\_repo\_revision](#input\_gitops\_repo\_revision) | Git revision of the repository that contains the Kubernetes manifests | `string` | n/a | yes |
| <a name="input_gitops_repo_url"></a> [gitops\_repo\_url](#input\_gitops\_repo\_url) | URL of the repository that contains the Kubernetes manifests | `string` | n/a | yes |
| <a name="input_k8s_addons_versions"></a> [k8s\_addons\_versions](#input\_k8s\_addons\_versions) | EKS addons versions. | <pre>object({<br/>    eks-pod-identity-agent = string<br/>    aws-ebs-csi-driver     = string<br/>  })</pre> | <pre>{<br/>  "aws-ebs-csi-driver": "v1.44.0-eksbuild.1",<br/>  "eks-pod-identity-agent": "v1.3.7-eksbuild.2"<br/>}</pre> | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | EKS Kubernetes version. | `string` | `"1.33"` | no |
| <a name="input_vpc_azs_number"></a> [vpc\_azs\_number](#input\_vpc\_azs\_number) | Number of AZs to use when deploying the VPC | `number` | `2` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_k8s_cluster_name"></a> [k8s\_cluster\_name](#output\_k8s\_cluster\_name) | Name of the EKS cluster created by Terraform |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC created by Terraform |
<!-- END_TF_DOCS -->
