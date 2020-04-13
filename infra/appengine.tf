# Used by cloud scheduler

resource "google_app_engine_application" "app" {
  location_id = var.region
}
