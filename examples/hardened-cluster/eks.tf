################################################################################
# Cluster
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"

  cluster_name                   = local.name
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Fargate profiles use the cluster primary security group so these are not utilized
  create_cluster_security_group = false
  create_node_security_group    = false

  # Fargate profiles definition
  fargate_profiles = {
    karpenter = {
      selectors = [
        { namespace = "karpenter" }
      ]
    }
    kube_system = {
      name = "kube-system"
      selectors = [
        { namespace = "kube-system" }
      ]
    }
  }

  # EKS Addons
  cluster_addons = {
    coredns = {
      configuration_values = jsonencode({
        computeType = "Fargate"
        resources = {
          limits = {
            cpu    = "0.25"
            memory = "256M"
          }
          requests = {
            cpu    = "0.25"
            memory = "256M"
          }
        }
      })
    }
    kube-proxy          = {}
    vpc-cni             = {}
    aws-guardduty-agent = {}
  }

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  manage_aws_auth_configmap = true
  aws_auth_roles = flatten(
    [
      module.platform_team.aws_auth_configmap_role,
      [for team in module.application_teams : team.aws_auth_configmap_role],
      {
        rolearn  = module.eks_blueprints_addons.karpenter.node_iam_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes",
        ]
      }
    ]
  )



  # eks_managed_node_groups = {
  #   bottlerocket_default = {
  #     instance_types             = ["m5.large"]
  #     ami_id                     = data.aws_ami.eks_default_bottlerocket.image_id
  #     platform                   = "bottlerocket"
  #     use_custom_launch_template = false

  #     min_size     = 1
  #     max_size     = 5
  #     desired_size = 3

  #   #   enable_bootstrap_user_data = true
  #   #   bootstrap_extra_args = <<-EOT
  #   #     # extra args added
  #   #     [settings.kernel]
  #   #     lockdown = "integrity"
  #   #   EOT
  #   }
  # }

  tags = merge(local.tags, {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "karpenter.sh/discovery" = local.name
  })
}

################################################################################
# Blueprints Addons
################################################################################

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.2"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_metrics_server = true
  metrics_server = {
    set = [{
      name  = "image.repository"
      value = "public.ecr.aws/eks-distro/kubernetes-sigs/metrics-server"
      },
      {
        name  = "image.tag"
        value = "v0.6.4-eks-1-28-latest"
      },
      {
        name  = "image.pullSecrets"
        value = [data.aws_ecrpublic_authorization_token.token.authorization_token]
      }
    ]
  }

  enable_aws_for_fluentbit = true
  aws_for_fluentbit_cw_log_group = {
    create          = true
    use_name_prefix = true # Set this to true to enable name prefix
    name_prefix     = "eks-cluster-logs-"
    retention       = 7
  }
  aws_for_fluentbit = {
    enable_containerinsights = true
    set = [{
      name  = "cloudWatchLogs.autoCreateGroup"
      value = true
      },
      {
        name  = "hostNetwork"
        value = true
      },
      {
        name  = "dnsPolicy"
        value = "ClusterFirstWithHostNet"
      }
    ]
    s3_bucket_arns = [
      module.logs_s3_bucket.s3_bucket_arn,
      "${module.logs_s3_bucket.s3_bucket_arn}/logs/*"
    ]
  }

  enable_gatekeeper = true
  gatekeeper = {
    set = [{
      name  = "image.repository"
      value = "public.ecr.aws/bitnami/keycloak-gatekeeper"
      },
      {
        name  = "image.tag"
        value = "10.0.0"
      },
      {
        name  = "image.pullSecrets"
        value = [data.aws_ecrpublic_authorization_token.token.authorization_token]
      }
    ]
  }

  enable_karpenter = true
  karpenter = {
    repository_username = data.aws_ecrpublic_authorization_token.token.user_name
    repository_password = data.aws_ecrpublic_authorization_token.token.password
  }

  tags = local.tags
}
