terraform {
    required_version = ">= 0.12, <= 0.12.12"

    required_providers {
        openstack = {
        source  = "terraform-provider-openstack/openstack"
        version = "~> 1.37"
        }
    }
    
}
