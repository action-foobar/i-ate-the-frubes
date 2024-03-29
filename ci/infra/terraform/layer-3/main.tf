terraform {
  backend "gcs" {

  }
}

provider "google" {
  project = "donefortheday"
}
locals {
  project = "donefortheday"
  file = "./sample.zip"
  # domain = null
  domain = "redpill.thereisnocloud.stevengonsalvez.com"
}

module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "~> 5.1"
  name    = "tf-myapp-lb"
  project = local.project

  ssl                             = var.ssl
  managed_ssl_certificate_domains = [local.domain]
  https_redirect                  = var.ssl

  backends = {
    default = {
      description = null
      groups = [
        {
          group = google_compute_region_network_endpoint_group.appengine_neg.id
        }
      ]
      enable_cdn              = false
      security_policy         = null
      custom_request_headers  = null
      custom_response_headers = null

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
      log_config = {
        enable      = false
        sample_rate = null
      }
    }
  }
}


resource "google_compute_region_network_endpoint_group" "appengine_neg" {
  name                  = "appengine-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "europe-west1"
  project               = local.project
  app_engine {
    service = google_app_engine_standard_app_version.myapp_v1.service
    version = google_app_engine_standard_app_version.myapp_v1.version_id
  }
}

resource "google_app_engine_standard_app_version" "myapp_v1" {
  version_id = "v1"
  service    = "myapp"
  runtime    = "nodejs16"
  #project = local.project

  entrypoint {
    shell = "npm start"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
    }
  }

  env_variables = {
    port = "8080"
    REGION = var.REGION
  }

  automatic_scaling {
    max_concurrent_requests = 10
    min_idle_instances      = 1
    max_idle_instances      = 3
    min_pending_latency     = "1s"
    max_pending_latency     = "5s"
    standard_scheduler_settings {
      target_cpu_utilization        = 0.5
      target_throughput_utilization = 0.75
      min_instances                 = 2
      max_instances                 = 10
    }
  }

  delete_service_on_destroy = true
  }

resource "random_id" "random" {
  keepers = {
    uuid = uuid()
  }
  byte_length = 8
}

resource "random_uuid" "test" {
}

resource "random_string" "storage_name" {
  length  = 10
  upper   = false
  lower   = true
  number  = true
  special = false
}

resource "google_storage_bucket" "bucket" {
  name     = "appengine-${random_string.storage_name.result}"
  location = "EU"
  project  = local.project
}

resource "google_storage_bucket_object" "object" {
  name   = "myapp-${random_uuid.test.result}.zip"
  bucket = google_storage_bucket.bucket.name
  source = local.file
}

# resource "google_cloud_run_service_iam_member" "public-access" {
#   location = google_app_engine_standard_app_version.myapp_v1.location
#   project  = google_app_engine_standard_app_version.myapp_v1.project
#   service  = google_app_engine_standard_app_version.myapp_v1.name
#   role     = "roles/run.invoker"
#   member   = "allUsers"
# }

resource "google_dns_managed_zone" "example" {
  name     = "thereisnocloud"
  dns_name = "stevengonsalvez.com."
}

resource "google_dns_record_set" "example" {
  managed_zone = google_dns_managed_zone.example.name

  name    = "redpill.${google_dns_managed_zone.example.name}.${google_dns_managed_zone.example.dns_name}"
  type    = "A"
  rrdatas = [module.lb-http.external_ip]
  ttl     = 300
}