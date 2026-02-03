#!/bin/bash

set -e

# Environment Variables
AWS_REGION="us-east-1"
S3_BUCKET_NAME="tfvishal-easy-shop-state-bucket"
DYNAMODB_TABLE_NAME="ES-terraform-state-lock"

echo "--- Deleting AWS Resources for Terraform Backend ---"
echo ""

# Empty the S3 Bucket (including versions and delete markers)
echo "Emptying S3 bucket: $S3_BUCKET_NAME..."

objects_to_delete=$(aws s3api list-object-versions \
    --bucket "$S3_BUCKET_NAME" \
    --output=json \
    --query='{Objects: Versions[].[Key,VersionId],DeleteMarkers:DeleteMarkers[].[Key,VersionId]}' \
    --region "$AWS_REGION")

if [ "$(echo "$objects_to_delete" | jq '.Objects | length')" -gt 0 ] || \
   [ "$(echo "$objects_to_delete" | jq '.DeleteMarkers | length')" -gt 0 ]; then

    delete_payload=$(echo "$objects_to_delete" | jq -c '{Objects: (.Objects + .DeleteMarkers | map({Key: .[0], VersionId: .[1]}) | unique)}')

    aws s3api delete-objects \
        --bucket "$S3_BUCKET_NAME" \
        --delete "$delete_payload" \
        --region "$AWS_REGION"

    echo "S3 bucket emptied."
else
    echo "S3 bucket is already empty."
fi

# Delete the S3 Bucket
echo "Deleting S3 bucket..."
aws s3 rb s3://"$S3_BUCKET_NAME" --region "$AWS_REGION" --force
echo "S3 bucket deleted."

# Delete the DynamoDB Table
echo "Deleting DynamoDB table..."
aws dynamodb delete-table \
    --table-name "$DYNAMODB_TABLE_NAME" \
    --region "$AWS_REGION"
echo "DynamoDB table deleted."

echo "✅ Terraform backend resources deleted successfully."