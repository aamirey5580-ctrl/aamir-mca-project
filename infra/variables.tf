/*
 * ==========================================================
 * Terraform Variables
 * Project: Node.js + MongoDB on GKE
 * Author: Aamir Qureshi
 * ==========================================================
 */

# -- GCP Configuration --
variable "gcp_project" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP Region"
  type        = string
  default     = "asia-south1"
}

variable "gcp_zone" {
  description = "GCP Zone for zonal resources"
  type        = string
  default     = "asia-south1-a"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

# -- Network Configuration --
variable "subnet_cidr" {
  description = "Primary subnet CIDR"
  type        = string
  default     = "10.10.0.0/24"
}

variable "pod_cidr" {
  description = "CIDR for Kubernetes pods"
  type        = string
  default     = "10.20.0.0/16"
}

variable "svc_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
  default     = "10.30.0.0/20"
}

# -- GKE Configuration --
variable "node_count" {
  description = "Number of nodes in GKE cluster"
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "GCE machine type for nodes"
  type        = string
  default     = "e2-small"
}

variable "disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 30
}

variable "use_preemptible" {
  description = "Use preemptible VMs for cost savings"
  type        = bool
  default     = true
}

