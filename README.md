
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client_tag | The tag that will be appplied to clients of the consul cluster. Firewally rules will allow only instances with this tag to communicate with the cluster. | string | `consul-client` | no |
| cluster_name | Name of the cluster to be deployed. | string | - | yes |
| cluster_size | Size of the cluster to create, 3 and 5 are optimal. | string | `3` | no |
| cluster_tag | Tag that will be applied to the instances to allow peer discovery. | string | - | yes |
| consul_cli_rpc_port | Port used for communication from the CLI. | string | `8400` | no |
| consul_dns_port | Port used by clients for DNS. | string | `8600` | no |
| consul_http_port | The ports clients will use to talk to the HTTP API | string | `8500` | no |
| consul_serf_lan_port | Port used to gossip over LAN. | string | `8301` | no |
| consul_serf_wan_port | Port used to gossip over WAN. | string | `8302` | no |
| consul_server_rpc_port | Port used for communication from other agents. | string | `8300` | no |
| disk_image | Image to use when deploying the cluster instances. | string | - | yes |
| gcp_network | Network to attach the instances and firewall rules to. | string | - | yes |
| gcp_project | Name of the project the cluster will be deployed to. | string | - | yes |
| gcp_region | The region to deploy the cluster to. | string | - | yes |
| gcp_subnetwork | Subnetwork to attach the instances and firewall rules to. | string | - | yes |
| host_project | Host project ID if using a shared vpc. | string | `` | no |
| http_health_check_healthy_threshold | Number of consecutive successes required. | string | `2` | no |
| http_health_check_initial_delay | How long, in seconds, to wait before starting to run checks. | string | `50` | no |
| http_health_check_interval | How frequently, in seconds, the HTTP health check should run. | string | `5` | no |
| http_health_check_timeout | How long, in seconds, the check will run before signaling a failure. | string | `5` | no |
| http_health_check_unhealthy_threshold | Number of consective failures required. | string | `2` | no |
| machine_type | The machine type to deploy the instances as. | string | `n1-standard-1` | no |
| prometheus_server_tag | Tag given to the prometheus servers. | string | `prometheus-server` | no |
| scopes | Permissions to access the Google APIs that the instances will have. | list | `<list>` | no |
| shared_vpc | Whether or not Prometheus will be deployed onto a shared vpc. | string | `false` | no |

