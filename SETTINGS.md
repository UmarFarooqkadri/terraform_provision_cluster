name - (Required) The name of the cluster, unique within the project and zone.
zone - (Optional) The zone that the master and the number of nodes specified in initial_node_count should be created in. Only one of zone and region may be set. If neither zone nor region are set, the provider zone is used.
region - (Optional, Beta) The region to create the cluster in, for Regional Clusters.
additional_zones - (Optional) The list of additional Google Compute Engine locations in which the cluster's nodes should be located. If additional zones are configured, the number of nodes specified in initial_node_count is created in all specified zones.
addons_config - (Optional) The configuration for addons supported by GKE. Structure is documented below.
cluster_ipv4_cidr - (Optional) The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR.
description - (Optional) Description of the cluster.
enable_binary_authorization - (Optional) Enable Binary Authorization for this cluster. If enabled, all container images will be validated by Google Binary Authorization.
enable_kubernetes_alpha - (Optional) Whether to enable Kubernetes Alpha features for this cluster. Note that when this option is enabled, the cluster cannot be upgraded and will be automatically deleted after 30 days.
enable_legacy_abac - (Optional) Whether the ABAC authorizer is enabled for this cluster. When enabled, identities in the system, including service accounts, nodes, and controllers, will have statically granted permissions beyond those provided by the RBAC configuration or IAM. Defaults to false
initial_node_count - (Optional) The number of nodes to create in this cluster (not including the Kubernetes master). Must be set if node_pool is not set.
ip_allocation_policy - (Optional) Configuration for cluster IP allocation. As of now, only pre-allocated subnetworks (custom type with secondary ranges) are supported. This will activate IP aliases. See the official documentation Structure is documented below.
logging_service - (Optional) The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none. Defaults to logging.googleapis.com
maintenance_policy - (Optional) The maintenance policy to use for the cluster. Structure is documented below.
master_auth - (Optional) The authentication information for accessing the Kubernetes master. Structure is documented below.
master_authorized_networks_config - (Optional) The desired configuration options for master authorized networks. Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists).
master_ipv4_cidr_block - (Optional, Beta) Specifies a private RFC1918 block for the master's VPC. The master range must not overlap with any subnet in your cluster's VPC. The master and your cluster use VPC peering. Must be specified in CIDR notation and must be /28 subnet.
min_master_version - (Optional) The minimum version of the master. GKE will auto-update the master to new versions, so this does not guarantee the current master version--use the read-only master_version field to obtain that. If unset, the cluster's version will be set by GKE to the version of the most recent official release (which is not necessarily the latest version).
monitoring_service - (Optional) The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none. Defaults to monitoring.googleapis.com
network - (Optional) The name or self_link of the Google Compute Engine network to which the cluster is connected. For Shared VPC, set this to the self link of the shared network.
network_policy - (Optional) Configuration options for the NetworkPolicy feature. Structure is documented below.
node_config - (Optional) Parameters used in creating the cluster's nodes. Structure is documented below.
node_pool - (Optional) List of node pools associated with this cluster. See google_container_node_pool for schema.
node_version - (Optional) The Kubernetes version on the nodes. Must either be unset or set to the same value as min_master_version on create. Defaults to the default version set by GKE which is not necessarily the latest version.
pod_security_policy_config - (Optional, Beta) Configuration for the PodSecurityPolicy feature. Structure is documented below.
private_cluster - (Optional, Beta) If true, a private cluster will be created, meaning nodes do not get public IP addresses. It is mandatory to specify master_ipv4_cidr_block and ip_allocation_policy with this option.
project - (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used.
remove_default_node_pool - (Optional) If true, deletes the default node pool upon cluster creation.
resource_labels - (Optional) The GCE resource labels (a map of key/value pairs) to be applied to the cluster.
subnetwork - (Optional) The name or self_link of the Google Compute Engine subnetwork in which the cluster's instances are launched.

# addons
horizontal_pod_autoscaling - (Optional) The status of the Horizontal Pod Autoscaling addon, which increases or decreases the number of replica pods a replication controller has based on the resource usage of the existing pods. It ensures that a Heapster pod is running in the cluster, which is also used by the Cloud Monitoring service. It is enabled by default; set disabled = true to disable.
http_load_balancing - (Optional) The status of the HTTP (L7) load balancing controller addon, which makes it easy to set up HTTP load balancers for services in a cluster. It is enabled by default; set disabled = true to disable.
kubernetes_dashboard - (Optional) The status of the Kubernetes Dashboard add-on, which controls whether the Kubernetes Dashboard is enabled for this cluster. It is enabled by default; set disabled = true to disable.
network_policy_config - (Optional) Whether we should enable the network policy addon for the master. This must be enabled in order to enable network policy for the nodes. It can only be disabled if the nodes already do not have network policies enabled. Set disabled = true to disable. 