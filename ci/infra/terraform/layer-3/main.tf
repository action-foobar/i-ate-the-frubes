
terraform {
  backend "gcs" {
    
  }
}

resource "google_app_engine_application" "app" {
  project     = "nowwilltrymore"
  location_id = "europe-west"
}