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
    _ORG_ID                   = var.org_id
    _INCEPTION_PROJECT_NUMBER = var.inception_project_number
    _ANALYTICS_PROJECT        = var.analytics_project
    _REGION                   = var.region
    _BILLING_ACCOUNT          = var.billing_account
    _OWNER                    = var.owner
    _OWNER_EMAIL              = var.owner_email
    _KUBEFLOW_HOST            = var.kubeflow_host
    _INCEPTION_IP             = var.inception_ip
  }

  description = "BUILD: Analytics Infra"
  filename    = "cloudbuild.yaml"
  included_files = [
    "**/*"
  ]

  depends_on = [google_project_service.inception]
}
