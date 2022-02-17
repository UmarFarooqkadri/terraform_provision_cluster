locals {
  region = var.region

  #default_zone   = "${element(sort(data.google_compute_zones.available.names), 0)}"
  #zone  = "${var.is_custom_zone ? var.custom_zone : local.default_zone}"

  zone                               = var.custom_zone
  labels                             = {}
  tags                               = []
  environment_prefix                 = var.production_cluster ? "prod" : "nonprod"
  monitoring_service                 = "monitoring.googleapis.com/kubernetes"
  logging_service                    = "logging.googleapis.com/kubernetes"
  auto_repair                        = var.production_cluster ? true : var.auto_repair
  auto_upgrade                       = var.production_cluster ? false : var.auto_upgrade
  maintenance_start_time             = var.production_cluster ? "17:00" : var.maintenance_start_time
  preemptible_compute                = var.production_cluster ? false : var.preemptible_compute
  prevent_destroy                    = var.production_cluster
  disable_horizontal_pod_autoscaling = var.production_cluster ? false : var.disable_horizontal_pod_autoscaling
  disable_http_load_balancing        = var.production_cluster ? false : var.disable_http_load_balancing
  disable_network_policy_config      = var.production_cluster ? true : var.disable_network_policy_config
  min_node_count                     = var.min_node_count
  max_node_count                     = var.max_node_count
  machine_type                       = "n1-standard-2"
}

resource "random_pet" "cluster_name" {
  prefix    = local.environment_prefix
  length    = 2
  separator = "-"
}

resource "google_container_cluster" "cluster" {
  project = var.project_id

  name = random_pet.cluster_name.id

  initial_node_count = local.min_node_count

  location = local.zone

  monitoring_service = local.monitoring_service
  logging_service    = local.logging_service

  # disable all basic and certificate auth - only auth via OpenID is available
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  lifecycle {
    ignore_changes = [
      initial_node_count,
      node_config,
      node_version,
    ]
  }

  remove_default_node_pool = true

  # https://github.com/terraform-providers/terraform-provider-google/issues/1648
  network = "projects/${var.project_id}/global/networks/default"

  addons_config {
    horizontal_pod_autoscaling {
      disabled = local.disable_horizontal_pod_autoscaling
    }

    http_load_balancing {
      disabled = local.disable_http_load_balancing
    }

    network_policy_config {
      disabled = local.disable_network_policy_config
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = local.maintenance_start_time
    }
  }
}

resource "google_container_node_pool" "nodepool" {
  project  = var.project_id
  name     = "${random_pet.cluster_name.id}-nodes"
  location = local.zone

  # ideally the initial_node_count should be the same as local.min_node_count
  # after the node pool is created, the min_node_count is updated due to more app deployed to the cluster
  # the change of the initial_node_count will cause the noode pool to be destroyed and re-created again
  # to minimize the impact and potential down time. this is set to the default initial size.
  initial_node_count = var.production_cluster ? 3 : 1

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  autoscaling {
    min_node_count = local.min_node_count
    max_node_count = local.max_node_count
  }

  cluster = google_container_cluster.cluster.name

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    image_type   = "COS_CONTAINERD"
    labels       = local.labels
    tags         = local.tags
    preemptible  = local.preemptible_compute
    machine_type = local.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_container_node_pool" "nodepool-2" {
  count    = var.second_nodepool ? 1 : 0
  project  = var.project_id
  name     = "${random_pet.cluster_name.id}-nodes-2"
  location = local.zone

  initial_node_count = "3"

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  cluster = google_container_cluster.cluster.name

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    image_type = "COS_CONTAINERD"

    labels = {
      nodetype  = "search"
      dedicated = "search"
    }

    preemptible  = local.preemptible_compute
    machine_type = "e2-standard-2"

    oauth_scopes = [
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

