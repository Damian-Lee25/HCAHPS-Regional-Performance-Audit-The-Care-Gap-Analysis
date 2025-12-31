# Make sure you have installed the package:
# pip install google-cloud-storage

from google.cloud import storage
import json
import os
import sys
import traceback

# Load GCP credentials from JSON file
try:
    with open('gcp_cred.json', 'r') as file:
        gcp_cred = json.load(file)
except FileNotFoundError:
    print("Error: 'gcp_cred.json' file not found. Make sure the file exists in the current directory.")
    sys.exit(1)
except json.JSONDecodeError:
    print("Error: 'gcp_cred.json' is not a valid JSON file.")
    sys.exit(1)
# Create storage client using explicit credentials
try:
    client = storage.Client.from_service_account_info(gcp_cred)
except Exception:
    print("Error: Failed to create GCS client. Check your credentials.")
    print(traceback.format_exc())
    sys.exit(1)
# Update these variables with your details
file_name = 'data/hospitalsurveydata_cleaned.csv'
bucket_name = 'hospital-survey-bucket'

try:
    # Check if the file exists locally
    if not os.path.isfile(file_name):
        raise FileNotFoundError(f"Local file '{file_name}' does not exist.")
    # Get bucket object
    bucket = client.bucket(bucket_name)
    if not bucket.exists():
        raise ValueError(f"Bucket '{bucket_name}' does not exist or is not accessible.")
    # Construct destination path inside bucket
    destination_blob_name = f"{file_name}"
    # Create blob and upload
    blob = bucket.blob(destination_blob_name)
    blob.upload_from_filename(file_name)

    print(f"'{file_name}' has been uploaded successfully to bucket '{bucket_name}'.")

except FileNotFoundError as fnf_error:
    print(f"File error: {fnf_error}")
except ValueError as val_error:
    print(f"Bucket error: {val_error}")
except Exception as e:
    print("An unexpected error occurred while uploading the file:")
    print(traceback.format_exc())

