terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.79.0"
    }
  }

  required_version = "~> 1.1.8"

  backend "gcs" {
    bucket      = var.bucket_state_name
    prefix      = "terraform/state"
    credentials = var.credentials_file
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = var.credentials_file
}
