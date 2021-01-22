locals {
  ipsec_natt_port = 4501
  ipsec_ike_port = 501
}

provider "openstack" {
  auth_url         = "<auth-url>"
  user_name        = "<user-name>"
  password         = "<password>"
  user_domain_name = "<domainname>"
  tenant_name      = "multi-cluster-networking"
  project_domain_id = "<project-domain-id>"
  region           = "regionOne"
}

module "ocp-osp-prep" {
  source     = "./tf-scripts"
  cluster_id = "cluster_id"
  ipsec_natt_port = local.ipsec_natt_port
  ipsec_ike_port = local.ipsec_ike_port
}
