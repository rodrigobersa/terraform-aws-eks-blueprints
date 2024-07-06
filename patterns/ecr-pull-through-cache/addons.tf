locals {
  ecr_account_id = var.ecr_account_id != "" ? var.ecr_account_id : data.aws_caller_identity.current.account_id
  ecr_region     = var.ecr_region != "" ? var.ecr_region : local.region
  ecr_url        = "${local.ecr_account_id}.dkr.ecr.${local.ecr_region}.amazonaws.com"
}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_argocd = true
  argocd = {
    set = [{
      name  = "global.image.repository"
      value = "${local.ecr_url}/quay/argoproj/argocd"
      },
      {
        name  = "dex.image.repository"
        value = "${local.ecr_url}/docker-hub/dexidp/dex"
      },
      {
        name  = "haproxy.image.repository"
        value = "${local.ecr_url}/docker-hub/library/haproxy"
      }
    ]
  }

  enable_metrics_server = true
  metrics_server = {
    set = [{
      name  = "image.repository"
      value = "${local.ecr_url}/k8s/metrics-server/metrics-server"
      }
    ]
  }

  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    set = [{
      name  = "image.repository"
      value = "${local.ecr_url}/ecr/eks/aws-load-balancer-controller"
      }
    ]
  }

  enable_kube_prometheus_stack = true
  kube_prometheus_stack = {
    set = [{
      name  = "global.imageRegistry"
      value = local.ecr_url
      },
      {
        name  = "prometheusOperator.image.repository"
        value = "quay/prometheus-operator/prometheus-operator"
      },
      {
        name  = "prometheusOperator.admissionWebhooks.deployment.image.repository"
        value = "quay/prometheus-operator/admission-webhook"
      },
      {
        name  = "prometheusOperator.admissionWebhooks.patch.image.repository"
        value = "k8s/ingress-nginx/kube-webhook-certgen"
      },
      {
        name  = "prometheusOperator.prometheusConfigReloader.image.repository"
        value = "quay/prometheus-operator/prometheus-config-reloader"
      },
      {
        name  = "alertmanager.alertmanagerSpec.image.repository"
        value = "quay/prometheus/alertmanager"
      },
      {
        name  = "prometheus.prometheusSpec.image.repository"
        value = "quay/prometheus/prometheus"
      },
      {
        name  = "prometheus-node-exporter.image.repository"
        value = "quay/prometheus/node-exporter"
      },
      {
        name  = "kube-state-metrics.image.repository"
        value = "k8s/kube-state-metrics/kube-state-metrics"
      },
      {
        name  = "grafana.global.imageRegistry"
        value = local.ecr_url
      },
      {
        name  = "grafana.downloadDashboardsImage.repository"
        value = "${local.ecr_url}/docker-hub/curlimages/curl"
      },
      {
        name  = "grafana.image.repository"
        value = "${local.ecr_url}/docker-hub/grafana/grafana"
      },
      {
        name  = "grafana.imageRenderer.image.repository"
        value = "${local.ecr_url}/docker-hub/grafana/grafana-image-renderer"
      },
      {
        name  = "grafana.sidecar.image.repository"
        value = "${local.ecr_url}/quay/kiwigrid/k8s-sidecar"
    }]
  }

  depends_on = [module.eks.cluster_addons]
}

#---------------------------------------------------------------
# Gatekeeper
#---------------------------------------------------------------
module "gatekeeper" {
  source  = "aws-ia/eks-blueprints-addon/aws"
  version = "1.1.1"

  name             = "gatekeeper"
  description      = "A Helm chart to deploy gatekeeper project"
  namespace        = "gatekeeper-system"
  create_namespace = true
  chart            = "gatekeeper"
  chart_version    = "3.16.3"
  repository       = "https://open-policy-agent.github.io/gatekeeper/charts"
  set = [
    {
      name  = "image.repository"
      value = "${local.ecr_url}/docker-hub/openpolicyagent/gatekeeper"
    },
    {
      name  = "image.crdRepository"
      value = "${local.ecr_url}/docker-hub/openpolicyagent/gatekeeper-crds"
    },
    {
      name  = "postUpgrade.labelNamespaceimage.repository"
      value = "${local.ecr_url}/docker-hub/openpolicyagent/gatekeeper-crds"
    },
    {
      name  = "postInstall.labelNamespace.image.repository"
      value = "${local.ecr_url}/docker-hub/openpolicyagent/gatekeeper-crds"
    },
    {
      name  = "probeWebhook.image.repository"
      value = "${local.ecr_url}/docker-hub/curlimages/curl"
    },
    {
      name  = "preUninstall.deleteWebhookConfigurations.image.repository"
      value = "${local.ecr_url}/docker-hub/openpolicyagent/gatekeeper-crds"
  }]

  depends_on = [module.eks_blueprints_addons]
}
