#!/bin/bash

# Define the source GCS bucket and destination S3 bucket paths
GCS_BUCKET="gs://<Source GCS Path>"
S3_BUCKET="s3://<Destination S3 path>"

# Define the Slack API URL
SLACK_API_URL="https://slack.com/api/chat.postMessage"

# Function to transfer a file from GCS to S3
transfer_file() {
  local line="$1"
  gsutil cp "$line" .
  filename=$(basename "$line")
  aws s3 cp "$filename" "$S3_BUCKET"
  rm -f "$filename"
}

# Export the function for parallel processing
export -f transfer_file

# Start of the migration process
echo "---------------------------------------"
echo "              GSB-S3 Migration"
echo "---------------------------------------"
echo ""

# Check for the list of files on Google Storage Bucket
echo "Checking for the list of files on Google Storage Bucket..."
gsutil ls "$GCS_BUCKET" > gcs-list.out
echo "Done!"
no_of_gcp_file=$(wc -l < gcs-list.out)
echo "Number of files on GCP: $no_of_gcp_file"
echo ""

# Check for the list of files on AWS S3 Bucket
echo "Checking for the list of files on AWS S3 Bucket..."
aws s3 ls "$S3_BUCKET" > aws-list.out
awk '{ print "'"$GCS_BUCKET"'" $4 }' aws-list.out > s3-list.out
echo "Done!"
no_of_s3_file=$(wc -l < s3-list.out)
echo "Number of files on AWS: $no_of_s3_file"
echo ""

# Check for files present in GCS but not in S3
echo "Checking for files present in GCS but not in S3..."
grep -F -x -v -f s3-list.out gcs-list.out > required-list.out
no_of_migrate_file=$(wc -l < required-list.out)
echo "Done, total number of files to migrate: $no_of_migrate_file"
echo ""

if [ $no_of_migrate_file -gt 0 ]; then
  echo "Migration from GCP to S3 is starting..."
  sleep 5
  cat required-list.out | parallel transfer_file
  echo ""
  echo "---------------------- SUCCESSFULL -------------------"

  # Removing Temporary Files
  rm gcs-list.out
  rm aws-list.out
  rm s3-list.out
  rm required-list.out

  echo ""
  echo "---------> Migration done successfully <---------"
  echo ""
  echo "Total AWS FILES: $no_of_s3_file"
  echo "Total GCP FILES: $no_of_gcp_file"
  echo "Total files transferred: $no_of_migrate_file"
  echo ""
  echo ""
  echo "Sending Notification regarding the migration on SLACK..."
  MESSAGE="Migration done successfully ----- total files transferred: $no_of_migrate_file"
  # Add Slack notification code here

elif [ $no_of_migrate_file -eq 0 ]; then
  echo ""
  echo "Files are UP-TO-Date"
  echo ""
  rm gcs-list.out
  rm aws-list.out
  rm s3-list.out
  rm required-list.out
  echo ""
  echo "Total AWS FILES: $no_of_s3_file"
  echo "Total GCP FILES: $no_of_gcp_file"

else
  echo "Something went wrong!"
fi

echo ""
echo ""
echo "--------------- THE END ------------------"
