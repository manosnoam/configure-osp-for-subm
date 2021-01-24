locals {
  ipsec_natt_port = 4501
  ipsec_ike_port = 501
}

provider "openstack" {
  auth_url         = "${var.osp_auth_url}"
  user_name        = "${var.osp_user}"
  password         = "${var.osp_password}"
  user_domain_name = "${var.osp_domain}"
  tenant_name      = "${var.osp_project}"
  project_domain_id = "${var.osp_project_id}"
  region           = "${var.osp_region}"
}

module "ocp-osp-prep" {
  source     = "./tf-scripts"
  cluster_id = "cluster_id"
  ipsec_natt_port = local.ipsec_natt_port
  ipsec_ike_port = local.ipsec_ike_port
}
