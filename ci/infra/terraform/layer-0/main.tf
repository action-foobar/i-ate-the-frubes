terraform {
  backend "gcs" {
    
  }
}

module "gcs_buckets" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 2.2"
  project_id  = "nowwilltrymore"
  names = ["first"]
  prefix = "statestore"
  # set_admin_roles = true
  # admins = ["group:foo-admins@example.com"]
  # versioning = {
  #   first = true
  # }
  # bucket_admins = {
  #   second = "user:spam@example.com,eggs@example.com"
  # }
}