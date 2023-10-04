# module "shield-advanced" {
#   source  = "aws-ia/shield-advanced/aws"
#   version = "0.0.1"

#   name         = "LoadBalancer protection"

#   resource_arn = module.eks.eks_managed_node_groups.

#   protection_group_config = [
#     {
#       id            = "ALB Resource"
#       aggregation   = "MEAN"
#       pattern       = "BY_RESOURCE_TYPE"
#       resource_type = "APPLICATION_LOAD_BALANCER"
#     },
#     {
#       id            = "CLB Resource"
#       aggregation   = "MEAN"
#       pattern       = "BY_RESOURCE_TYPE"
#       resource_type = "CLASSIC_LOAD_BALANCER"
#     }
#   ]
# }
