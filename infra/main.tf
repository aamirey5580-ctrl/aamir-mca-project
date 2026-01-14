/*
 * ==========================================================
 * Main Infrastructure Configuration
 * Project: Node.js + MongoDB on GKE
 * Author: Aamir Qureshi
 * ==========================================================
 */

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# -- Provider Configuration --
provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

# -- Local Variables --
locals {
  app_name = "nodejs-mongo"
  env      = var.environment
  
  common_tags = {
    project     = local.app_name
    environment = local.env
    managed_by  = "terraform"
    owner       = "aamir-qureshi"
  }
}

# ==========================================================
# NETWORKING - VPC and Subnets
# ==========================================================

resource "google_compute_network" "main" {
  name                    = "${local.app_name}-network-${local.env}"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "private" {
  name          = "${local.app_name}-subnet-${local.env}"
  ip_cidr_range = var.subnet_cidr
  region        = var.gcp_region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = var.pod_cidr
  }

  secondary_ip_range {
    range_name    = "svc-range"
    ip_cidr_range = var.svc_cidr
  }
}

# -- NAT Gateway for outbound connectivity --
resource "google_compute_router" "nat_router" {
  name    = "${local.app_name}-router-${local.env}"
  region  = var.gcp_region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${local.app_name}-nat-${local.env}"
  router                             = google_compute_router.nat_router.name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# ==========================================================
# FIREWALL RULES
# ==========================================================

resource "google_compute_firewall" "internal_allow" {
  name    = "${local.app_name}-allow-internal-${local.env}"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.subnet_cidr, var.pod_cidr, var.svc_cidr]
}

resource "google_compute_firewall" "health_check" {
  name    = "${local.app_name}-allow-health-${local.env}"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}

# ==========================================================
# IAM - Service Account for GKE
# ==========================================================

resource "google_service_account" "gke_sa" {
  account_id   = "${local.app_name}-gke-sa"
  display_name = "GKE Service Account for ${local.app_name}"
}

resource "google_project_iam_member" "gke_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/storage.objectViewer",
    "roles/artifactregistry.reader",
  ])

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

# ==========================================================
# GKE CLUSTER
# ==========================================================

resource "google_container_cluster" "app_cluster" {
  name     = "${local.app_name}-cluster-${local.env}"
  location = var.gcp_zone

  # Remove default node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  # Networking
  network    = google_compute_network.main.name
  subnetwork = google_compute_subnetwork.private.name

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-range"
    services_secondary_range_name = "svc-range"
  }

  # Private cluster
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "public-access"
    }
  }

  # Workload Identity
  workload_identity_config {
    workload_pool = "${var.gcp_project}.svc.id.goog"
  }

  # Addons
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  # Labels
  resource_labels = local.common_tags

  deletion_protection = false
}

# ==========================================================
# GKE NODE POOL
# ==========================================================

resource "google_container_node_pool" "app_nodes" {
  name       = "${local.app_name}-nodepool-${local.env}"
  location   = var.gcp_zone
  cluster    = google_container_cluster.app_cluster.name
  node_count = var.node_count

  node_config {
    preemptible  = var.use_preemptible
    machine_type = var.machine_type
    disk_size_gb = var.disk_size
    disk_type    = "pd-standard"

    service_account = google_service_account.gke_sa.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    labels = local.common_tags
    tags   = ["gke-node", local.app_name]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_secure_boot = true
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

