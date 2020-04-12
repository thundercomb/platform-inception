resource "google_project_service" "inception" {
  for_each = toset([
    "appengine.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "accesscontextmanager.googleapis.com"
  ])
  service = each.key
}
