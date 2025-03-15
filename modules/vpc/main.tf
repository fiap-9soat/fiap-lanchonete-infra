# Filter out local zones, which are not currently supported
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  name = basename(path.cwd)
  vpc_cidr             = "10.0.0.0/16"
  availability_zone_names = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnet_names = [for k, v in local.availability_zone_names : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnet_names  = [for k, v in local.availability_zone_names : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  tags = {
    GithubRepo = "fiap-lanchonete-infra"
    GithubOrg  = "fiap-9soat"
  }
}

