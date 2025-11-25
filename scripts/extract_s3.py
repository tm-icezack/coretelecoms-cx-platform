# coretelecoms/scripts/extract_s3.py (RAW EXTRACTION ONLY)

import boto3
import pandas as pd
import io
import os
from .s3_utils import upload_dataframe_to_s3
from datetime import datetime
from dotenv import load_dotenv
# In both extract_postgres.py and extract_s3.py


load_dotenv()

# --- NO CLEANING FUNCTIONS REQUIRED FOR RAW LOAD ---

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
        
        # Determine key_path and file_name for S3 loader
        key_path = data_type 
        file_name = data_type
        if date_str:
            file_name = f"{data_type}_{date_str}"
        
        # Load the raw DataFrame directly
        upload_dataframe_to_s3(
            df=df, # Loading the raw DataFrame (no df_cleaned variable)
            file_name=file_name, 
            key_path=key_path
        )
        
    except Exception as e:
        print(f" Critical Error in {data_type.upper()} RAW ETL for {file_key}: {e}")

# --- TEST EXECUTION ---

if __name__ == "__main__":
    SOURCE_BUCKET = 'core-telecoms-data-lake'
    TEST_DATE = datetime.now().strftime("%Y-%m-%d")
    
    # 1. Customer Data (Static)
    CUSTOMER_KEY = 'customers/customers_dataset.csv' 
    print("\n--- Running Customer Data Pipeline (RAW Load) ---")
    extract_and_load_raw_s3(SOURCE_BUCKET, CUSTOMER_KEY, 'customers')

    # 2. Call Logs Data (Daily Example)
    CALL_LOG_KEY = f'call logs/call_logs_day_{TEST_DATE}.csv'
    print(f"\n--- Running Call Logs Pipeline (RAW Load) for {TEST_DATE} ---")
    extract_and_load_raw_s3(SOURCE_BUCKET, CALL_LOG_KEY, 'call_logs', TEST_DATE)

    # 3. Social Media Data (Daily Example)
    SOCIAL_KEY = f'social_medias/media_complaint_day_{TEST_DATE}.json'
    print(f"\n--- Running Social Media Pipeline (RAW Load) for {TEST_DATE} ---")
    extract_and_load_raw_s3(SOURCE_BUCKET, SOCIAL_KEY, 'social_media', TEST_DATE)