data "openstack_networking_secgroup_v2" "workers-sg" {
  name = "${var.cluster_id}-worker"
}

data "openstack_networking_secgroup_v2" "masters-sg" {
  name = "${var.cluster_id}-master"
}

# Add a rule for vxlan traffic for all workers.
resource "openstack_networking_secgroup_rule_v2" "worker-to-worker-vxlan-rule" {
  security_group_id = data.openstack_networking_secgroup_v2.workers-sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 4800
  port_range_max    = 4800
  remote_group_id   = data.openstack_networking_secgroup_v2.workers-sg.id
}

# Add a rule for vxlan traffic from master nodes to worker nodes.
resource "openstack_networking_secgroup_rule_v2" "master-to-worker-vxlan-rule" {
  security_group_id = data.openstack_networking_secgroup_v2.workers-sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 4800
  port_range_max    = 4800
  remote_group_id   = data.openstack_networking_secgroup_v2.masters-sg.id
}

# Add a rule for vxlan traffic from worker nodes to master nodes.
resource "openstack_networking_secgroup_rule_v2" "worker-to-master-vxlan-rule" {
  security_group_id = data.openstack_networking_secgroup_v2.masters-sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 4800
  port_range_max    = 4800
  remote_group_id   = data.openstack_networking_secgroup_v2.workers-sg.id
}

# Add a rule for metrics traffic for all workers.
resource "openstack_networking_secgroup_rule_v2" "worker-to-worker-metrics-rule" {
  security_group_id = data.openstack_networking_secgroup_v2.workers-sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_group_id   = data.openstack_networking_secgroup_v2.workers-sg.id
}

# Add a rule for metrics traffic from master nodes to worker nodes.
resource "openstack_networking_secgroup_rule_v2" "master-to-worker-metrics-rule" {
  security_group_id = data.openstack_networking_secgroup_v2.workers-sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_group_id   = data.openstack_networking_secgroup_v2.masters-sg.id
}

# Add a rule for metrics traffic from worker nodes to master nodes.
resource "openstack_networking_secgroup_rule_v2" "worker-to-master-metrics-rule" {
  security_group_id = data.openstack_networking_secgroup_v2.masters-sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_group_id   = data.openstack_networking_secgroup_v2.workers-sg.id
}





