# scripts/extract_postgres.py

import pandas as pd
import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from datetime import datetime
from .s3_utils import upload_dataframe_to_s3 

load_dotenv()

# -------------------------------
# RAW POSTGRES EXTRACTION FUNCTION
# -------------------------------

def extract_and_load_raw_postgres(date_str: str):
    """
    Extracts Web Form data (RAW) and loads it to S3.
    """
    table_date = date_str.replace('-', '_')
    table_name = f"customer_complaints.web_form_request_{table_date}"
    
    DB_USER = os.getenv('DB_USER')
    DB_PASSWORD = os.getenv('DB_PASSWORD')
    DB_HOST = os.getenv('DB_HOST')
    DB_PORT = os.getenv('DB_PORT')
    DB_NAME = os.getenv('DB_NAME')
    
    db_url = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

    try:
        engine = create_engine(db_url)
        query = f"SELECT * FROM {table_name} LIMIT 10"
        df = pd.read_sql(query, engine, dtype=str, index_col=None)
        print(f"Successfully extracted RAW {table_name} from Postgres. Rows: {len(df)}")

        upload_dataframe_to_s3(
            df=df, 
            file_name=f'web_forms_{date_str}', 
            key_path='web_forms' 
        )
        
    except Exception as e:
        if "relation" in str(e) and "does not exist" in str(e):
            print(f" Warning: Postgres table {table_name} not found. Skipping extraction.")
        else:
            print(f" Critical Error in Web Forms RAW ETL for {table_name}: {e}")


# ----------------------------------------------------------
# NEW: run() WRAPPER FOR scripts.main TO IMPORT AND EXECUTE
# ----------------------------------------------------------

def run():
    """
    Entry point for Postgres extraction when called from scripts.main
    """
    TEST_DATE = datetime(2025, 11, 20).strftime("%Y-%m-%d")
    print(f"\n--- Running Web Forms Pipeline (RAW Load) for {TEST_DATE} ---")
    extract_and_load_raw_postgres(TEST_DATE)


# ------------------------------
# LOCAL TEST RUN
# ------------------------------

if __name__ == "__main__":
    run()
