variable "environment" {
  description = "Environment to deploy. It uses this name as the path of the Kubernetes manifests"
  type        = string

  validation {
    condition     = contains(["dev"], var.environment)
    error_message = "Valid values for var: environment are (dev)."
  }
}

##############################
##### DOMAIN
##############################
variable "domain" {
  description = "Route53 Domain - Hosted Zone - to be used. This resource should be created manually and will be just used in Terraform code as a data source."
  type        = string
}

##############################
##### AWS RELATED
##############################
variable "aws_region" {
  description = "AWS Region to deploy resources"
  type        = string
}

##############################
##### NETWORKING
##############################
variable "vpc_azs_number" {
  description = "Number of AZs to use when deploying the VPC"
  type        = number
  default     = 2
}

variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type        = string
}

##############################
##### KUBERNETES RELATED
##############################
variable "k8s_version" {
  description = "EKS Kubernetes version."
  type        = string
  default     = "1.33"
}

variable "k8s_addons_versions" {
  description = "EKS addons versions."
  type = object({
    eks-pod-identity-agent = string
    aws-ebs-csi-driver     = string
  })
  default = {
    eks-pod-identity-agent = "v1.3.7-eksbuild.2"
    aws-ebs-csi-driver     = "v1.44.0-eksbuild.1"
  }
}

##############################
##### KUBERNETES BOOTSTRAP RELATED
##############################
variable "argocd_chart_version" {
  description = "The Helm Chart version used to install ArgoCD using Terraform"
  type        = string
  default     = "8.2.1"
}

variable "gitops_repo_url" {
  description = "URL of the repository that contains the Kubernetes manifests"
  type        = string
}

variable "gitops_repo_addons_basepath" {
  description = "Base Path of the repository that contains the Kubernetes manifests for the addons"
  type        = string
}

variable "gitops_repo_revision" {
  description = "Git revision of the repository that contains the Kubernetes manifests"
  type        = string
}
