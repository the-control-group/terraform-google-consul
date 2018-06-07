/*resource "google_compute_health_check" "consul_health_check" {
  name                = "${var.cluster_name}-http-health-check"
  check_interval_sec  = "${var.http_health_check_interval}"
  timeout_sec         = "${var.http_health_check_timeout}"
  healthy_threshold   = "${var.http_health_check_healthy_threshold}"
  unhealthy_threshold = "${var.http_health_check_unhealthy_threshold}"

  http_health_check {
    request_path = "/"
    port         = "${var.consul_http_port}"
  }
}*/

resource "google_compute_instance_template" "consul-group-template" {
  name_prefix = "${var.cluster_name}"

  project = "${var.gcp_project}"
  region  = "${var.gcp_region}"

  machine_type = "${var.machine_type}"
  tags         = concat("${var.cluster_tag}", "${var.additional_tags}")

  labels = {
    group = "${var.cluster_tag}"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = "${var.disk_image}"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = "${var.gcp_subnetwork}"
  }

  service_account {
    scopes = "${var.scopes}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "consul-group-manager" {
  name = "${var.cluster_name}-group-manager"

  base_instance_name = "${var.cluster_name}"
  instance_template  = "${google_compute_instance_template.consul-group-template.self_link}"

  region = "${var.gcp_region}"

  target_size = "${var.cluster_size}"

  update_strategy = "ROLLING_UPDATE"

  rolling_update_policy {
    type                  = "PROACTIVE"
    minimal_action        = "REPLACE"
    max_unavailable_fixed = 1
    min_ready_sec         = 50
  }

  /*auto_healing_policies {
    health_check      = "${google_compute_health_check.consul-health-check.self_link}"
    initial_delay_sec = "${var.http_health_check_initial_delay}"
  }*/
}

resource "google_compute_firewall" "consul-cluster-communication" {
  count   = "${var.shared_vpc == 0 ? 1 : 0}"
  name    = "${var.cluster_name}-cluster-communication"
  network = "${var.gcp_network}"

  allow {
    protocol = "tcp"

    ports = [
      "${var.consul_server_rpc_port}",
      "${var.consul_cli_rpc_port}",
      "${var.consul_serf_lan_port}",
      "${var.consul_serf_wan_port}",
    ]
  }

  allow {
    protocol = "udp"

    ports = [
      "${var.consul_dns_port}",
      "${var.consul_serf_lan_port}",
      "${var.consul_serf_wan_port}",
    ]
  }

  source_tags = ["${var.cluster_tag}"]
}

resource "google_compute_firewall" "consul-client-communication" {
  count   = "${var.shared_vpc == 0 ? 1 : 0}"
  name    = "${var.cluster_name}-client-communication"
  network = "${var.gcp_network}"

  allow {
    protocol = "tcp"

    ports = [
      "${var.consul_http_port}",
      "${var.consul_dns_port}",
    ]
  }

  source_tags = ["${var.client_tag}"]
  target_tags = ["${var.cluster_tag}"]
}

resource "google_compute_firewall" "consul-exporter-communication" {
  count   = "${var.shared_vpc == 0 ? 1 : 0}"
  name    = "${var.cluster_name}-prometheus-communication"
  network = "${var.gcp_network}"

  allow {
    protocol = "tcp"

    ports = ["9107"]
  }

  source_tags = ["${var.prometheus_server_tag}"]
  target_tags = ["${var.cluster_tag}"]
}

resource "google_compute_firewall" "svpc-consul-cluster-communication" {
  count   = "${var.shared_vpc == 1 ? 1 : 0}"
  name    = "${var.cluster_name}-cluster-communication"
  network = "${var.gcp_network}"
  project = "${var.host_project}"

  allow {
    protocol = "tcp"

    ports = [
      "${var.consul_server_rpc_port}",
      "${var.consul_cli_rpc_port}",
      "${var.consul_serf_lan_port}",
      "${var.consul_serf_wan_port}",
    ]
  }

  allow {
    protocol = "udp"

    ports = [
      "${var.consul_dns_port}",
      "${var.consul_serf_lan_port}",
      "${var.consul_serf_wan_port}",
    ]
  }

  source_tags = ["${var.cluster_tag}"]
}

resource "google_compute_firewall" "svpc-consul-client-communication" {
  count   = "${var.shared_vpc == 1 ? 1 : 0}"
  name    = "${var.cluster_name}-client-communication"
  network = "${var.gcp_network}"
  project = "${var.host_project}"

  allow {
    protocol = "tcp"

    ports = [
      "${var.consul_http_port}",
      "${var.consul_dns_port}",
    ]
  }

  source_tags = ["${var.client_tag}"]
  target_tags = ["${var.cluster_tag}"]
}

resource "google_compute_firewall" "svpc-consul-exporter-communication" {
  count   = "${var.shared_vpc == 1 ? 1 : 0}"
  name    = "${var.cluster_name}-prometheus-communication"
  network = "${var.gcp_network}"
  project = "${var.host_project}"

  allow {
    protocol = "tcp"

    ports = ["9107"]
  }

  source_tags = ["${var.prometheus_server_tag}"]
  target_tags = ["${var.cluster_tag}"]
}
