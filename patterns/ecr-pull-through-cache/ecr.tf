variable "docker_secret" {
  description = "Inform your docker username and accessToken to allow pullTroughCache to get images from Docekr.io. E.g. `{username='user',accessToken='pass'}`"
  type = object({
    username    = string
    accessToken = string
  })
  sensitive = true
  default = {
    username    = ""
    accessToken = ""
  }
}

module "secrets-manager" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.1.2"

  name                    = "ecr-pullthroughcache/docker"
  secret_string           = jsonencode(var.docker_secret)
  recovery_window_in_days = 0
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.2.1"

  create_repository = false

  registry_pull_through_cache_rules = {
    ecr = {
      ecr_repository_prefix = "ecr"
      upstream_registry_url = "public.ecr.aws"
    }
    k8s = {
      ecr_repository_prefix = "k8s"
      upstream_registry_url = "registry.k8s.io"
    }
    quay = {
      ecr_repository_prefix = "quay"
      upstream_registry_url = "quay.io"
    }
    dockerhub = {
      ecr_repository_prefix = "docker-hub"
      upstream_registry_url = "registry-1.docker.io"
      credential_arn        = module.secrets-manager.secret_arn
    }
  }

  manage_registry_scanning_configuration = true
  registry_scan_type                     = "ENHANCED"
  registry_scan_rules = [
    {
      scan_frequency = "SCAN_ON_PUSH"
      filter = [
        {
          filter      = "*"
          filter_type = "WILDCARD"
        },
      ]
    }
  ]
}
