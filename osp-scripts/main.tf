locals {
  cluster_id            = "cluster_id"
  ipsec_natt_port       = 4501
  ipsec_ike_port        = 501
  os_auth_url           = "https://openstack-auth-url:13000/v3"
  os_username           = "openstack-user"
  os_password           = "openstack-pass"
  os_user_domain_name   = "openstack.domain"
  os_tenant_name        = "openstack-project"
  os_project_domain_id  = "openstack-project-id"
  os_region             = "openstack-region"
}

provider "openstack" {
  auth_url          = local.os_auth_url
  user_name         = local.os_username
  password          = local.os_password
  user_domain_name  = local.os_user_domain_name
  tenant_name       = local.os_tenant_name
  project_domain_id = local.os_project_domain_id
  region            = local.os_region
}

module "ocp-osp-prep" {
  source          = "./tf-scripts"
  cluster_id      = local.cluster_id
  ipsec_natt_port = local.ipsec_natt_port
  ipsec_ike_port  = local.ipsec_ike_port
}
