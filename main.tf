################################################################################
# VPC
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name               = "${local.common_name}-vpc"
  cidr               = var.vpc_cidr
  azs                = var.azs
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = var.enable_nat_gateway
  private_subnet_tags = {
    Tier = "Private"
  }
  public_subnet_tags = {
    Tier = "Public"
  }
  tags = local.common_tags
}

# data "aws_availability_zones" "available" {}
# azs      = slice(data.aws_availability_zones.available.names, 0, 3)
# private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]

################################################################################
# Cluster
################################################################################

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.11.4"

  cluster_name = "${local.common_name}-cluster"

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 1
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  tags = local.common_tags
}

################################################################################
# Shared ALB
################################################################################

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = "${local.common_name}-alb"

  load_balancer_type = "application"

  vpc_id                         = module.vpc.vpc_id
  subnets                        = module.vpc.public_subnets
  security_group_use_name_prefix = false
  security_group_name            = "${local.common_name}-alb"

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = var.vpc_cidr
    }
  }

  listeners = {
    external_http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "ex_ecs"
      }
    }
  }
  # Fake target group to default listener rule (Can not create ALB without default rule)
  target_groups = {
    ex_ecs = {
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true
      create_attachment                 = false
    }
  }
  enable_deletion_protection = false
  tags                       = local.common_tags
}
