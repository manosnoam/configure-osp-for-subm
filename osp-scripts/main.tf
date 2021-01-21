locals {
  ipsec_natt_port = 4501
  ipsec_ike_port = 501
}

provider "openstack" {
}

module "ocp-osp-prep" {
  source     = "./tf-scripts"
  cluster_id = "cluster_id"
  ipsec_natt_port = local.ipsec_natt_port
  ipsec_ike_port = local.ipsec_ike_port
}
