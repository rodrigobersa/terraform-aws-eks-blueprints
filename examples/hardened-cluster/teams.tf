################################################################################
# EKS Blueprints Teams Module - Namespaced Admin
################################################################################
module "platform_team" {
  source = "git@github.com:aws-ia/terraform-aws-eks-blueprints-teams?ref=feat/rbac-permissions"
  #   source  = "aws-ia/eks-blueprints-teams/aws"
  #   version = "1.1.0"

  name = "platform-team"

  users             = [data.aws_caller_identity.current.arn]
  cluster_arn       = module.eks.cluster_arn
  oidc_provider_arn = module.eks.oidc_provider_arn

  labels = {
    team = "platform"
  }

  annotations = {
    team = "platform"
  }

  cluster_role_name = "platform-team"
  cluster_role_rule = {
    resources = ["namespaces", "nodes", "storageclasses", "persistentvolumes", "storageclasses"]
    verbs     = ["get", "list", "watch"]
  }

  additional_role_ref = {
    name = "admin"
  }
  role_ref = {
    kind = "ClusterRole"
    name = "admin"
  }

  tags = local.tags
}

################################################################################
# Multiple Application Teams
################################################################################
module "application_teams" {
  source = "git@github.com:aws-ia/terraform-aws-eks-blueprints-teams?ref=feat/rbac-permissions"
  #   source  = "aws-ia/eks-blueprints-teams/aws"
  #   version = "1.1.0"

  for_each = {
    frontend = {}
    backend  = {}
  }
  name = "app-team-${each.key}"

  users             = [data.aws_caller_identity.current.arn]
  cluster_arn       = module.eks.cluster_arn
  oidc_provider_arn = module.eks.oidc_provider_arn

  role_ref = {
    kind = "ClusterRole"
    name = "edit"
  }

  cluster_role_rule = {
    resources = ["namespaces", "nodes", "storageclasses"]
    verbs     = ["get", "list"]
  }

  namespaces = {
    "app-${each.key}" = {
      labels = {
        teamName    = "${each.key}-team",
        projectName = "${each.key}-project",
      }

      resource_quota = {
        hard = {
          "requests.cpu"    = "2000m",
          "requests.memory" = "4Gi",
          "limits.cpu"      = "4000m",
          "limits.memory"   = "16Gi",
          "pods"            = "20",
          "secrets"         = "20",
          "services"        = "20"
        }
      }

      limit_range = {
        limit = [
          {
            type = "Pod"
            max = {
              cpu    = "200m"
              memory = "1Gi"
            }
          },
          {
            type = "PersistentVolumeClaim"
            min = {
              storage = "24M"
            }
          },
          {
            type = "Container"
            default = {
              cpu    = "50m"
              memory = "24Mi"
            }
          }
        ]
      }

      network_policy = {
        pod_selector = {
          match_expressions = [{
            key      = "name"
            operator = "In"
            values   = ["webfront", "api"]
          }]
        }

        ingress = [{
          ports = [
            {
              port     = "http"
              protocol = "TCP"
            },
            {
              port     = "53"
              protocol = "TCP"
            },
            {
              port     = "53"
              protocol = "UDP"
            }
          ]

          from = [
            {
              namespace_selector = {
                match_labels = {
                  name = "default"
                }
              }
            },
            {
              ip_block = {
                cidr = "10.0.0.0/8"
                except = [
                  "10.0.0.0/24",
                  "10.0.1.0/24",
                ]
              }
            }
          ]
        }]

        egress = [] # single empty rule to allow all egress traffic

        policy_types = ["Ingress", "Egress"]
      }
    }
  }

  tags = local.tags
}