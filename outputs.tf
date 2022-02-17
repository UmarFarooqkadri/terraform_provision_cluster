# endpoint - The IP address of this cluster's Kubernetes master.
output "endpoint" {
  value = google_container_cluster.cluster.endpoint
}

# cluster_ca_certificate - Base64 encoded public certificate that is the root of trust for the cluster.
output "cluster_ca_certificate" {
  value = base64decode(
    google_container_cluster.cluster.master_auth[0].cluster_ca_certificate,
  )
}

# master_version - The current version of the master in the cluster. This may be different than the min_master_version set in the config if the master has been updated by GKE.
output "master_version" {
  value = google_container_cluster.cluster.master_version
}

output "name" {
  value = google_container_cluster.cluster.name
}

