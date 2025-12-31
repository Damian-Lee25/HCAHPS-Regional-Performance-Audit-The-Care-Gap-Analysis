import functions_framework
from google.cloud import bigquery
from google.cloud.bigquery import LoadJobConfig
import time
import traceback

# Triggered by a change in a storage bucket
@functions_framework.cloud_event
def hello_gcs(cloud_event):
    try:
        data = cloud_event.data

        event_id = cloud_event["id"]
        event_type = cloud_event["type"]

        bucket = data["bucket"]
        filename = data["name"]
        metageneration = data.get("metageneration")
        timeCreated = data.get("timeCreated")
        updated = data.get("updated")

        print(f"Event ID: {event_id}")
        print(f"Event type: {event_type}")
        print(f"Bucket: {bucket}")
        print(f"File: {filename}")
        print(f"Metageneration: {metageneration}")
        print(f"Created: {timeCreated}")
        print(f"Updated: {updated}")

        # Load file to BigQuery
        load_bq(filename)

    except KeyError as e:
        print(f"KeyError: missing expected field: {e}")
    except Exception as e:
        print("Unexpected error processing CloudEvent:")
        print(traceback.format_exc())


# Send file from GCS to BigQuery and create table if needed
dataset = 'new_analysis'
table = 'survey_data'

def load_bq(filename):
    try:
        client = bigquery.Client()
        table_ref = client.dataset(dataset).table(table)

        job_config = LoadJobConfig()
        job_config.source_format = bigquery.SourceFormat.CSV
        job_config.skip_leading_rows = 1
        job_config.autodetect = True  # Automatically detects schema

        uri = f'gs://hospital-survey-bucket/{filename}'
        print(f"Loading file {uri} into BigQuery table {dataset}.{table}")

        load_job = client.load_table_from_uri(
            uri,
            table_ref,
            job_config=job_config
        )

        load_job.result()  # Wait for job to complete
        num_rows = load_job.output_rows
        print(f"{num_rows} rows loaded into {table} successfully.")

    except Exception as e:
        print(f"Failed to load {filename} into BigQuery:")
        print(traceback.format_exc())