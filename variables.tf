/// Required
variable "cluster_name" {
  description = "Name of the cluster to be deployed."
  type        = "string"
}

variable "cluster_tag" {
  description = "Tag that will be applied to the instances to allow peer discovery."
  type        = "string"
}

variable "gcp_project" {
  description = "Name of the project the cluster will be deployed to."
  type        = "string"
}

variable "gcp_region" {
  description = "The region to deploy the cluster to."
  type        = "string"
}

variable "gcp_network" {
  description = "Network to attach the instances and firewall rules to."
  type        = "string"
}

variable "gcp_subnetwork" {
  description = "Subnetwork to attach the instances and firewall rules to."
  type        = "string"
}

variable "disk_image" {
  description = "Image to use when deploying the cluster instances."
  type        = "string"
}

/// Optional
variable "additional_tags" {
    description = "Additional tags to apply to the instances."
    type = "list"
    defautl = []
}
variable "shared_vpc" {
  description = "Whether or not Prometheus will be deployed onto a shared vpc."
  default     = false
}

variable "host_project" {
  description = "Host project ID if using a shared vpc."
  type        = "string"
  default     = ""
}

variable "client_tag" {
  description = "The tag that will be appplied to clients of the consul cluster. Firewally rules will allow only instances with this tag to communicate with the cluster."
  type        = "string"
  default     = "consul-client"
}

variable "machine_type" {
  description = "The machine type to deploy the instances as."
  type        = "string"
  default     = "n1-standard-1"
}

variable "cluster_size" {
  description = "Size of the cluster to create, 3 and 5 are optimal."
  default     = 3
}

variable "scopes" {
  description = "Permissions to access the Google APIs that the instances will have."
  type        = "list"
  default     = ["compute-ro", "logging-write", "storage-rw", "monitoring"]
}

# Consul Ports
variable "consul_http_port" {
  description = "The ports clients will use to talk to the HTTP API"
  default     = 8500
}

variable "consul_dns_port" {
  description = "Port used by clients for DNS."
  default     = 8600
}

variable "consul_server_rpc_port" {
  description = "Port used for communication from other agents."
  default     = 8300
}

variable "consul_cli_rpc_port" {
  description = "Port used for communication from the CLI."
  default     = 8400
}

variable "consul_serf_lan_port" {
  description = "Port used to gossip over LAN."
  default     = 8301
}

variable "consul_serf_wan_port" {
  description = "Port used to gossip over WAN."
  default     = 8302
}

# Health Checks
variable "http_health_check_interval" {
  description = "How frequently, in seconds, the HTTP health check should run."
  default     = 5
}

variable "http_health_check_timeout" {
  description = "How long, in seconds, the check will run before signaling a failure."
  default     = 5
}

variable "http_health_check_healthy_threshold" {
  description = "Number of consecutive successes required."
  default     = 2
}

variable "http_health_check_unhealthy_threshold" {
  description = "Number of consective failures required."
  default     = 2
}

variable "http_health_check_initial_delay" {
  description = "How long, in seconds, to wait before starting to run checks."
  default     = 50
}

variable "prometheus_server_tag" {
  description = "Tag given to the prometheus servers."
  default     = "prometheus-server"
}
