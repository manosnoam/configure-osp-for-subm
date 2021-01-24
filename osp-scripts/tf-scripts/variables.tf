variable "ipsec_ike_port" {
  description = "IPSEC IKE port, normally port 500"
}

variable "ipsec_natt_port" {
  description = "IPSEC NATT and encapsulation port, normally 4500"
}

variable "cluster_id" {
  description = "infraID from metadata json."
}

variable "osp_auth_url" { }

variable "osp_user" { }

variable "osp_password" { }

variable "osp_domain" { }

variable "osp_project" { }

variable "osp_project_id" { }

variable "osp_region" {
  default = "regionOne"
}

