data "opentelekomcloud_identity_project_v3" "current" {}

module "vpc" {
  source     = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  version    = "5.1.0"
  name       = "${var.context}-${var.stage}-vpc"
  cidr_block = var.vpc_cidr
  subnets = {
    "kubernetes-subnet" = cidrsubnet(var.vpc_cidr, 1, 0)
  }
  tags = local.tags
}

module "snat" {
  source        = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/snat"
  version       = "5.1.0"
  name_prefix   = "${var.context}-${var.stage}"
  subnet_id   = module.vpc.subnets["kubernetes-subnet"].id
  vpc_id        = module.vpc.vpc.id
  tags          = local.tags
}

module "cce" {
  source  = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/cce"
  version = "5.1.0"
  name    = "${var.context}-${var.stage}"
  cluster_subnet_id = module.vpc.subnets["kubernetes-subnet"].id
  cluster_vpc_id = module.vpc.vpc.id
  cluster_high_availability = var.cluster_config.high_availability
  cluster_enable_scaling    = var.cluster_config.enable_scaling

  node_count        = var.cluster_config.nodes_count
  node_flavor       = var.cluster_config.node_flavor
  node_storage_type = var.cluster_config.node_storage_type
  node_storage_size = var.cluster_config.node_storage_size
  node_availability_zones = ["${var.region}-03", "${var.region}-01"]

  autoscaler_node_max = var.cluster_config.nodes_max
  authentication_mode = "rbac"


  tags = local.tags
}

module "encyrpted_secrets_bucket" {
  providers         = { opentelekomcloud = opentelekomcloud.top_level_project }
  source            = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/obs_secrets_writer"
  version           = "5.1.0"
  bucket_name       = replace(lower("${data.opentelekomcloud_identity_project_v3.current.name}-${var.context}-${var.stage}-stage-secrets"), "_", "-")
  bucket_object_key = "terraform-secrets"
  secrets = {
    kubectl_config          = module.cce.cluster_credentials.kubectl_config
    kubernetes_ca_cert      = module.cce.cluster_credentials.cluster_certificate_authority_data
    client_certificate_data = module.cce.cluster_credentials.client_certificate_data
    kube_api_endpoint       = module.cce.cluster_credentials.kubectl_external_server
    client_key_data         = module.cce.cluster_credentials.client_key_data
    cce_id                  = module.cce.cluster_id
    cce_name                = module.cce.cluster_name
  }
  tags = local.tags
}