resource "google_cloudbuild_trigger" "analytics_infra" {
  provider = google-beta

  github {
    owner = "thundercomb"
    name  = "analytics-infra"
    push {
      branch = "^master$"
    }
  }

  description = "BUILD: Analytics Infra"
  filename    = "cloudbuild.yaml"
  included_files = [
    "*"
  ]
}
