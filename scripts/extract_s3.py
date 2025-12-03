import boto3
import pandas as pd
import io
import os
from .s3_utils import upload_dataframe_to_s3
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

# -------------------------------
# RAW S3 EXTRACT & LOAD FUNCTION
# -------------------------------

def extract_and_load_raw_s3(bucket_name, file_key, data_type: str, date_str: str = None):
    """
    Extracts data from S3 and loads it directly to the Raw Data Lake without transformation.
    """
    s3 = boto3.client(
        's3',
        aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
        region_name=os.getenv('AWS_REGION')
    )

    try:
        response = s3.get_object(Bucket=bucket_name, Key=file_key)
        data = response['Body'].read()
        
        if file_key.endswith('.csv'):
            df = pd.read_csv(io.BytesIO(data))
        elif file_key.endswith('.json'):
            df = pd.read_json(io.BytesIO(data))
        else:
            raise ValueError(f"Unsupported file type for {file_key}")
        
        # --- QUICK TEST LIMIT ---
        df = df.head(10) 
        # ------------------------

        print(f"Successfully extracted RAW {file_key} from Source S3. Rows: {len(df)}")
        
        # Determine upload path
        key_path = data_type 
        file_name = data_type if not date_str else f"{data_type}_{date_str}"
        
        upload_dataframe_to_s3(
            df=df,
            file_name=file_name,
            key_path=key_path
        )
        
    except Exception as e:
        print(f" Critical Error in {data_type.upper()} RAW ETL for {file_key}: {e}")


# ----------------------------------------------------------
# NEW: run() WRAPPER FOR scripts.main TO IMPORT AND EXECUTE
# ----------------------------------------------------------

def run():
    """
    Entry point for S3 RAW extraction when called from scripts.main.
    """
    SOURCE_BUCKET = 'core-telecoms-data-lake'
    TEST_DATE = datetime(2025, 11, 20).strftime("%Y-%m-%d")

    # --- Customer Data (Static) ---
    CUSTOMER_KEY = 'customers/customers_dataset.csv'
    print("\n--- Running Customer Data Pipeline (RAW Load) ---")
    extract_and_load_raw_s3(SOURCE_BUCKET, CUSTOMER_KEY, 'customers')

    # --- Call Logs ---
    print(f"\n--- Running Call Logs Pipeline (RAW Load) for {TEST_DATE} ---")
    CALL_LOG_KEY = f'call logs/call_logs_day_{TEST_DATE}.csv'
    extract_and_load_raw_s3(SOURCE_BUCKET, CALL_LOG_KEY, 'call_logs', TEST_DATE)

    # --- Social Media ---
    print(f"\n--- Running Social Media Pipeline (RAW Load) for {TEST_DATE} ---")
    SOCIAL_KEY = f'social_medias/media_complaint_day_{TEST_DATE}.json'
    extract_and_load_raw_s3(SOURCE_BUCKET, SOCIAL_KEY, 'social_media', TEST_DATE)


# ------------------------------
# LOCAL TEST RUN
# ------------------------------

if __name__ == "__main__":
    run()
