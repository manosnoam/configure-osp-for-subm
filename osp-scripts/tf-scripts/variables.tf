variable "ipsec_ike_port" {
  description = "IPSEC IKE port, normally port 500"
}

variable "ipsec_natt_port" {
  description = "IPSEC NATT and encapsulation port, normally 4500"
}

variable "cluster_id" {
  description = "infraID from metadata json."
}

variable "OS_AUTH_URL" { }

variable "OS_USERNAME" { }

variable "OS_PASSWORD" { }

variable "OS_USER_DOMAIN_NAME" { }

variable "OS_PROJECT_NAME" { }

variable "OS_PROJECT_DOMAIN_ID" { }

variable "OS_REGION_NAME" {
  default = "regionOne"
}
