#!/bin/bash

# Configuration
SERVICE_NAME="guestpass"
REGION="us-west1"
GCLOUD_PATH="/Users/chetmcknight/google-cloud-sdk/bin/gcloud"

# Fallback: check if gcloud is in PATH if specific path doesn't work
if [ ! -f "$GCLOUD_PATH" ]; then
    if command -v gcloud &> /dev/null; then
        GCLOUD_PATH="gcloud"
    else
        echo "❌ Error: Google Cloud SDK (gcloud) not found at $GCLOUD_PATH or in PATH."
        exit 1
    fi
fi

echo "Using gcloud at: $GCLOUD_PATH"

# Check for active project
PROJECT_ID=$($GCLOUD_PATH config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ] || [ "$PROJECT_ID" == "(unset)" ]; then
    echo "❌ Error: No active Google Cloud Project found."
    echo "   Run '$GCLOUD_PATH config set project <YOUR_PROJECT_ID>' to select one."
    exit 1
fi

echo "🚀 Deploying '$SERVICE_NAME' to Cloud Run ($REGION) in project '$PROJECT_ID'..."
echo "   Source: Current directory"

# Deploy command
$GCLOUD_PATH run deploy "$SERVICE_NAME" \
  --source . \
  --region "$REGION" \
  --allow-unauthenticated \
  --platform managed

if [ $? -eq 0 ]; then
    echo "✅ Deployment Successful!"
else
    echo "❌ Deployment Failed."
fi
