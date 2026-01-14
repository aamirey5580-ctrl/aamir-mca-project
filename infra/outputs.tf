/*
 * ==========================================================
 * Terraform Outputs
 * Project: Node.js + MongoDB on GKE
 * Author: Aamir Qureshi
 * ==========================================================
 */

output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.app_cluster.name
}

output "cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = google_container_cluster.app_cluster.endpoint
  sensitive   = true
}

output "cluster_ca_cert" {
  description = "Cluster CA certificate"
  value       = google_container_cluster.app_cluster.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "network_name" {
  description = "VPC network name"
  value       = google_compute_network.main.name
}

output "subnet_name" {
  description = "Subnet name"
  value       = google_compute_subnetwork.private.name
}

output "service_account" {
  description = "GKE service account email"
  value       = google_service_account.gke_sa.email
}

output "get_credentials_cmd" {
  description = "Command to configure kubectl"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.app_cluster.name} --zone ${var.gcp_zone} --project ${var.gcp_project}"
}

output "project_info" {
  description = "Project information"
  value = {
    project = var.gcp_project
    region  = var.gcp_region
    zone    = var.gcp_zone
    env     = var.environment
  }
}

