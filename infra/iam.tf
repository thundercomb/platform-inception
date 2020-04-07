resource "google_organization_iam_binding" "cloud_build_storage_admin" {
  org_id = var.org_id
  role   = "roles/storage.admin"

  members = [
    "serviceAccount:${var.inception_project_number}@cloudbuild.gserviceaccount.com"
  ]
}
