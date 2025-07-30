locals {
  prefix = "gitops-bridge"

  azs              = slice(data.aws_availability_zones.available.names, 0, var.vpc_azs_number)
  private_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 8)]

  hosted_zone_id = data.aws_route53_zone.this.zone_id
  # hosted_zone_arn = data.aws_route53_zone.this.arn
}
