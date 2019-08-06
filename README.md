# terraform-gke

Hashicorp Terraform is opensource tool, Using which we can automate the provosioning of resources workflow. You can create compute, storage, network and many more resources on every cloud providers. We can automated every process using terraform. Here we will learn how to deploy kubernetes cluster using terraform on GCP.

`Prerequisites :`
1. `Terraform Installed`
2. `Kubectl Installed`
3. `google cloud sdk`
4. `googlc cloud project`

First we will create variable file and input all the variables into that.

`myvariables.tf'

```
#https://youtu.be/IT-Tpunrf7A?list=PLH1ul2iNXl7vk8RUchIiMBeXqDnFTi4_M&t=1106
# Variables
#
variable "project" {
  default = "linuxguru"
}

variable "region" {
  default = "us-east1-b"
}

variable "cluster_name" {
  default = "my-cluster"
}

variable "cluster_zone" {
  default = "us-east1-b"
}

variable "cluster_k8s_version" {
  default = "1.11.10-gke.5"
}

variable "initial_node_count" {
  default = 1
}

variable "autoscaling_min_node_count" {
  default = 1
}

variable "autoscaling_max_node_count" {
  default = 1
}

variable "disk_size_gb" {
  default = 10
}

variable "disk_type" {
  default = "pd-standard"
}

variable "machine_type" {
  default = "g1-small"
}

```

Now we will create terraform resources file and for create cluster.

`cluster_spec.tf`

```
# GKE Cluster
#
resource "google_container_cluster" "cluster" {
  name               = "${var.cluster_name}"
  location               = "${var.cluster_zone}"
  min_master_version = "${var.cluster_k8s_version}"

  addons_config {
    network_policy_config {
      disabled = true
    }

    http_load_balancing {
      disabled = false
    }

    kubernetes_dashboard {
      disabled = false
    }
  }

  node_pool {
    name               = "default-pool"
    initial_node_count = "${var.initial_node_count}"

    management {
      auto_repair = true
    }

    autoscaling {
      min_node_count = "${var.autoscaling_min_node_count}"
      max_node_count = "${var.autoscaling_max_node_count}"
    }

    node_config {
      preemptible  = false
      disk_size_gb = "${var.disk_size_gb}"
      disk_type    = "${var.disk_type}"

      machine_type = "${var.machine_type}"

      oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append",
        "https://www.googleapis.com/auth/compute",
      ]

      labels {
        env = "prod"
      }
    }
  }
}

#
# Output for K8S
#
output "client_certificate" {
  value = "${google_container_cluster.cluster.master_auth.0.client_certificate}"
  sensitive = true
}

output "client_key" {
  value = "${google_container_cluster.cluster.master_auth.0.client_key}"
  sensitive = true
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.cluster.master_auth.0.cluster_ca_certificate}"
  sensitive = true
}

output "host" {
  value = "${google_container_cluster.cluster.endpoint}"
  sensitive = true
}
```
