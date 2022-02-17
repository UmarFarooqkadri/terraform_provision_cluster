# Google Container Engine Cluster (Kubernetes)
#### this is a mixure of terraform-docs and manual docs

### Required

| Name | Description | Type |
|------|-------------|:----:|
| project_id | Id of the GCP Project to create the cluster in. | string |

### Options

| Name | Description | Type | Default |
|------|-------------|:----:|:-----:|
| production_cluster | This is a production cluster - configuration is *overridden with enforced production config*. | boolean | `false` |
| auto_repair | Whether the nodes will be automatically repaired. | boolean | `true` |
| auto_upgrade | Whether the nodes will be automatically upgraded. | boolean | `true` |
| disable_horizontal_pod_autoscaling | Horizontal Pod Autoscaling addon, which increases or decreases the number of replica pods a replication controller has based on the resource usage of the existing pods. | boolean | `false` |
| disable_http_load_balancing | The status of the HTTP (L7) load balancing controller addon, which makes it easy to set up HTTP load balancers for services in a cluster. It is enabled by default | boolean | `false` |
| maintenance_start_time | GMT Time window specified for daily maintenance operations. Default 5pm - 3am AEST/1am AWST | string | `17:00` |
| disable_network_policy_config | Whether we should enable the network policy addon for the master. This must be enabled in order to enable network policy for the nodes. It can only be disabled if the nodes already do not have network policies enabled. | boolean | `false` |
| preemptible_compute | Set the underlying node VMs are preemptible. Not recommended for production workloads. | boolean | `true` |

## Production Configuration

Any cluster flagged as production will have all configuration options ignored and the below configuration applied.

```hcl
  production_cluster_settings = {
    auto_repair                = true
    auto_upgrade               = false
    maintenance_start_time     = "17:00"
    preemptible_compute        = false

    disable_horizontal_pod_autoscaling = true
    disable_http_load_balancing        = true
    disable_kubernetes_dashboard       = true
    disable_network_policy_config      = true

    min_node_count             = 3
    max_node_count             = 10
  }
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| auto\_repair | Whether the nodes will be automatically repaired. | string | `true` | no |
| auto\_upgrade | Whether the nodes will be automatically upgraded. | string | `true` | no |
| disable\_horizontal\_pod\_autoscaling | Horizontal Pod Autoscaling addon, which increases or decreases the number of replica pods a replication controller has based on the resource usage of the existing pods. | string | `false` | no |
| disable\_http\_load\_balancing | The status of the HTTP (L7) load balancing controller addon, which makes it easy to set up HTTP load balancers for services in a cluster. It is enabled by default | string | `false` | no |
| disable\_kubernetes\_dashboard | The status of the Kubernetes Dashboard add-on, which controls whether the Kubernetes Dashboard is enabled for this cluster. It is enabled by default | string | `false` | no |
| disable\_network\_policy\_config | Whether we should enable the network policy addon for the master. This must be enabled in order to enable network policy for the nodes. It can only be disabled if the nodes already do not have network policies enabled. | string | `true` | no |
| maintenance\_start\_time | GMT Time window specified for daily maintenance operations. Default 5pm - 3am AEST/1am AWST | string | `17:00` | no |
| max\_node\_count | - | string | `5` | no |
| min\_node\_count | - | string | `1` | no |
| preemptible\_compute | Set the underlying node VMs are preemptible. Not recommended for production workloads. | string | `true` | no |
| production\_cluster | This is a production cluster - configuration is overridden with enforced production config. | string | `true` | no |
| project\_id | - | string | - | yes |
| region | - | string | `australia-southeast1` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ca\_certificate | cluster_ca_certificate - Base64 encoded public certificate that is the root of trust for the cluster. |
| endpoint | endpoint - The IP address of this cluster's Kubernetes master. |
| master\_version | master_version - The current version of the master in the cluster. This may be different than the min_master_version set in the config if the master has been updated by GKE. |
| name | - |