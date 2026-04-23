terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "momo-terraform-state"
    region   = "ru-central1"
    key      = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
}

# Network
resource "yandex_vpc_network" "momo-network" {
  name = "momo-network"
}

resource "yandex_vpc_subnet" "momo-subnet" {
  name           = "momo-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.momo-network.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

# K8s Cluster
resource "yandex_kubernetes_cluster" "momo-k8s" {
  name       = "momo-k8s"
  network_id = yandex_vpc_network.momo-network.id

  master {
    version = "1.28"
    zonal {
      zone      = yandex_vpc_subnet.momo-subnet.zone
      subnet_id = yandex_vpc_subnet.momo-subnet.id
    }
    public_ip = true
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id

  release_channel = "STABLE"
}

resource "yandex_kubernetes_node_group" "momo-nodes" {
  cluster_id = yandex_kubernetes_cluster.momo-k8s.id
  name       = "momo-nodes"
  version    = "1.28"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.momo-subnet.id]
    }

    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }
}

# S3 Bucket for images
resource "yandex_storage_bucket" "momo-images" {
  bucket = "momo-store-images"
}

# Container Registry
resource "yandex_container_registry" "momo-registry" {
  name = "momo-registry"
}
