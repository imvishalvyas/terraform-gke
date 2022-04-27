variable "project_id" {
  description = "project id"
}

variable "cluster_name" {
  description = "cluster name"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes per zone"
}

variable "machine_type" {
  type        = string
  description = "Type of the node compute engines."
}

variable "disk_size_gb" {
  type        = number
  description = "Size of the node's disk."
}

variable "disk_type" {
  type        = string
  description = "Type of the node's disk."
}

variable "cluster_version" {
  default = "1.20"
}

variable "external_ip" {
  default = " static ip "
}

variable "bucket_state_name" {
  description = "Bucket for terraform state"
}

variable "credentials_file" {}