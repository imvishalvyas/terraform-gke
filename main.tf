
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  min_master_version       = var.cluster_version
  remove_default_node_pool = true
  initial_node_count       = 1
}


resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes
  version    = var.cluster_version

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      env = var.project_id
    }

    image_type   = "COS"
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    preemptible  = false
    tags = [
      "gke-node",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

