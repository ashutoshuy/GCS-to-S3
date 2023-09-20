# GSB-S3 Migration Tool

## What is GSB-S3 Migration Tool?

The GSB-S3 Migration Tool is a Bash script that facilitates the migration of files from Google Cloud Storage (GCS) to Amazon S3. It automates the process of transferring files between these two cloud storage services.

## Installation

1. Clone the repository to your local machine:

```bash
  it clone https://github.com/ashutoshuy/GCS-to-S3.git
```


2. Make sure you have the required dependencies installed:
- `gsutil` for interacting with Google Cloud Storage.
- AWS Command Line Interface (CLI) for interacting with Amazon S3.
- GNU Parallel for parallel processing (if not already installed, you can typically install it using your package manager).

3. Update the script with your GCS and S3 bucket paths, and Slack API URL.

## Usage

Run the script:

```bash
  ./gsb-s3-migaration.sh
```


The script will perform the following steps:
- Check for files on GCS and S3 buckets.
- Identify files to be migrated.
- Initiate the migration process.
- Provide a summary of the migration.

## Slack Notifications

You can configure Slack notifications by adding code to send messages to your Slack workspace within the script. Replace the comment `# Add Slack notification code here` with your Slack integration code.

## License

This project is licensed under the MIT License.

## Contributors

- Ashutosh Upadhyay (@ashutoshuy)
  

