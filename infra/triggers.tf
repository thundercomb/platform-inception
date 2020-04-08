resource "google_cloudbuild_trigger" "analytics_infra" {
  provider = google-beta

  github {
    owner = "thundercomb"
    name  = "analytics-infra"
    push {
      branch = "^master$"
    }
  }

  substitutions = {
    _ORG_ID              = var.org_id
    _ANALYTICS_PROJECT   = var.analytics_project
    _REGION              = var.region
    _BILLING_ACCOUNT     = var.billing_account
    _OWNER               = var.owner
    _OWNER_EMAIL         = var.owner_email
    _OAUTH_CLIENT_ID     = var.oauth_client_id
    _OAUTH_CLIENT_SECRET = var.oauth_client_secret
  }

  description = "BUILD: Analytics Infra"
  filename    = "cloudbuild.yaml"
  included_files = [
    "**/*"
  ]

  depends_on = [google_project_service.inception]
}
