# Platform Inception

## Overview

Inception process for the GCP Climate Analytics & Machine Learning platform. This repo creates basic GCP resources and a pipeline trigger, using a shell script and Terraform code. The rest of the platform is created from the downstream analytics repo triggering the pipeline.

## Prerequisites

1. terraform >= 0.12
2. bash
3. GCP user account with Organization Admin privileges

## Configuration

### Start script variables

Configure `_start_vars.sh` (see also `_start_vars.sh.example`):  

`INCEPTION_PROJECT` : Inception project id  
`STATE_BUCKET` : `"${INCEPTION_PROJECT}-terraform-state"` - Name of inception process terraform state bucket  
`REGION` : Inception project region, eg. `europe-west2`  
`BILLING_ACCOUNT` : Organisation billing account id

### Terraform variables

Configure `_tf_vars.sh` (see also `_tf_vars.sh.example`):  

`TF_VAR_org_id` : `$(gcloud organizations list | tail -1 | awk '{ print $2 }')` - GCP Organisation id  
`GOOGLE_PROJECT` : `"${INCEPTION_PROJECT}"` - Inception project id  
`TF_VAR_orchestration_project_number` : `$(gcloud projects list | awk -v p="${INCEPTION_PROJECT}" '($1 == p) { print $3 }')` - Inception project number  
`TF_VAR_analytics_project` : Analytics project id  
`TF_VAR_region` : `"${REGION}"` - Inception project region  
`TF_VAR_billing_account` : `"${BILLING_ACCOUNT}"` - Organisation billing account id  
`TF_VAR_owner` : Github account name, eg. `thundercomb`  
`TF_VAR_owner_email` : Project owner email  
`TF_VAR_kubeflow_host` : Kubeflow host id (Only available after Kubeflow pipeline creation)  
`TF_VAR_inception_ip`: `$(curl ifconfig.me)`  

## Run

Run the start script.

`bash start.sh`  
