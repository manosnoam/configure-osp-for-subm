locals {
  ipsec_natt_port = 4501
  ipsec_ike_port = 501
}

provider "openstack" {
  auth_url         = var.OS_AUTH_URL
  user_name        = var.OS_USERNAME
  password         = var.OS_PASSWORD
  user_domain_name = var.OS_USER_DOMAIN_NAME
  tenant_name      = var.OS_PROJECT_NAME
  project_domain_id = var.OS_PROJECT_DOMAIN_ID
  region           = var.OS_REGION_NAME
}

module "ocp-osp-prep" {
  source     = "./tf-scripts"
  cluster_id = "cluster_id"
  ipsec_natt_port = local.ipsec_natt_port
  ipsec_ike_port = local.ipsec_ike_port
}
