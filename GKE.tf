provider "google" {
  credentials = file("gke-sa-key.json")
  project     = "forward-bee-435412-h2"
  region      = "us-central1"
}

resource "google_container_cluster" "primary" {
  name               = "my-gke-cluster"
  location           = "us-central1"
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 100
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",        # Full access to Google Cloud services, including Kubernetes API
      "https://www.googleapis.com/auth/logging.write",         # Allows logging to Cloud Logging
      "https://www.googleapis.com/auth/monitoring",            # Allows monitoring metrics to Cloud Monitoring
      "https://www.googleapis.com/auth/trace.append"           # Allows trace data to be sent to Cloud Trace
    ]
  }
}

resource "google_container_node_pool" "primary_nodes" {
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    preemptible  = false
    disk_size_gb = 100
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

output "gke_cluster_name" {
  value = google_container_cluster.primary.name
}

output "gke_cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}