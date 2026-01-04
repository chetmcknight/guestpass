#!/bin/bash

# Configuration
PROJECT_ID="gen-lang-client-0626258694"
SERVICE_ACCOUNT="570795383152-compute@developer.gserviceaccount.com"
GCLOUD_PATH="/Users/chetmcknight/google-cloud-sdk/bin/gcloud"

echo "🔧 Attempting to fix IAM permissions for Service Account: $SERVICE_ACCOUNT"

# Grant Storage Admin (to access the source code bucket)
echo "1. Granting roles/storage.admin..."
$GCLOUD_PATH projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:$SERVICE_ACCOUNT" \
    --role="roles/storage.admin"

# Grant Cloud Build Service Account role (to execute builds)
echo "2. Granting roles/cloudbuild.builds.builder..."
$GCLOUD_PATH projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:$SERVICE_ACCOUNT" \
    --role="roles/cloudbuild.builds.builder"

echo "✅ Permissions updated. Please retry the deployment."
