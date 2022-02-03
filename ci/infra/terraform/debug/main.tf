provider "google" {
  project = "donefortheday"
}

data "google_dns_managed_zone" "env_dns_zone" {
  name = "whoatemyfrubes"
}

output "google_dns_managed_zone" {
    value = "${data.google_dns_managed_zone.env_dns_zone.id}"
}