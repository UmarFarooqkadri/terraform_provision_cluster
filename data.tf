data "google_compute_zones" "available" {
  region  = local.region
  project = var.project_id
  status  = "UP"
}

