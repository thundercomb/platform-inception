#!/bin/bash

# Set variables

source _vars.sh

# Prepare the environment

echo "Checking if inception project exists ..."
gcloud projects list | awk '{ print $1 }' | grep -q ^"${INCEPTION_PROJECT}"$
if [ $? -ne 0 ]; then
  echo "Inception project does not exist."
  echo "Making inception project ..."
  gcloud projects create ${INCEPTION_PROJECT}
fi

echo "Checking if inception terraform state bucket exists ..."
gsutil ls -p ${INCEPTION_PROJECT} | grep -q gs://${STATE_BUCKET}/
if [ $? -ne 0 ]; then
  echo "Inception terraform state bucket does not exist."
  echo "Linking billing account to project ..."
  gcloud beta billing projects link ${INCEPTION_PROJECT} --billing-account ${BILLING_ACCOUNT}
  echo "Change to inception project ..."
  gcloud config set project ${INCEPTION_PROJECT}
  echo "Sleep to take effect ..."
  sleep 5
  echo "Making storage bucket ..."
  gsutil mb -l ${REGION} -p ${INCEPTION_PROJECT} gs://${STATE_BUCKET}/
fi

echo "Checking if cloud build service is enabled ..."
gcloud services list | grep -q ^cloudbuild.googleapis.com
if [ $? -ne 0 ]; then
  echo "Cloud build service isn't enabled."
  echo "Enabling cloud build service ..."
  gcloud services enable cloudbuild.googleapis.com
fi

# Create infrastructure

cd infra

echo "Deploying infrastructure ..."

terraform init \
  -backend-config="bucket=${STATE_BUCKET}" \
  -backend-config="prefix=inception"
terraform plan
terraform apply -auto-approve
if [ $? -ne 0 ]; then
  echo
  echo "Have a look at the terraform error."
  echo "If you are required to connect the github repo, follow the instructions."
  echo "For example, the first time around the trigger has to be connected to the repo,"
  echo "and you have to manually navigate your browser to:"
  echo "https://console.cloud.google.com/cloud-build/triggers/connect?project=<inception project number>"
  exit 0
fi
cd -

# Display order for further deployment

echo
echo "DONE!"
echo "${INCEPTION_PROJECT} has been created with a trigger for infrastructure"
echo "Follow these steps in the corresponding order:"
echo "1. Trigger the infrastructure build (creates infrastructure + triggers)"
echo "2. Trigger kubeflow deployment"
echo "2. Trigger default-service (creates default App Engine service)"
echo "3. Trigger ingest-ncei-wind"
echo "4. Trigger ingest-clnn-news"
echo "5. Trigger train-iris"
echo "6. Trigger train-climate-news"
echo "7. Trigger serve-iris-predictions"
echo "8. Trigger serve-climate-news"
echo "9. Trigger generate-climate-news"
