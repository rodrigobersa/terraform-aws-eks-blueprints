################################################################################
# Cluster
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"

  cluster_name                   = local.name
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true

  # EKS Addons
  cluster_addons = {
    coredns             = {}
    kube-proxy          = {}
    vpc-cni             = {}
    aws-guardduty-agent = {}
  }

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    bottlerocket_default = {
      instance_types             = ["m5.large"]
      ami_id                     = data.aws_ami.eks_default_bottlerocket.image_id
      platform                   = "bottlerocket"
      use_custom_launch_template = false

      min_size     = 1
      max_size     = 5
      desired_size = 3

      #ami_type                   = "BOTTLEROCKET_x86_64"
      # enable_bootstrap_user_data = true
      # bootstrap_extra_args       = <<-EOT
      #   [settings.host-containers.admin]
      #   enabled = false

      #   [settings.host-containers.control]
      #   enabled = true

      #   [settings.kernel]
      #   lockdown = "integrity"
      # EOT
    }
  }

  manage_aws_auth_configmap = true
  aws_auth_roles = flatten(
    [
      module.platform_team.aws_auth_configmap_role,
      [for team in module.application_teams : team.aws_auth_configmap_role],
    ]
  )

  tags = local.tags
}

################################################################################
# Blueprints Addons
################################################################################

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_metrics_server    = true
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
    name          = "gatekeeper"
    chart_version = "3.13.0"
    repository    = "https://open-policy-agent.github.io/gatekeeper/charts"
    namespace     = "gatekeeper-system"
    #values        = [templatefile("${path.module}/values.yaml", {})]
  }

  tags = local.tags
}