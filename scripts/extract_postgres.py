# scripts/extract_postgres.py

import pandas as pd
import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from datetime import datetime
# Use the relative import, as the execution is being handled by the module method
from .s3_utils import upload_dataframe_to_s3 

load_dotenv()

# --- NO CLEANING FUNCTION REQUIRED FOR RAW LOAD ---

def extract_and_load_raw_postgres(date_str: str):
    """
    Extracts Web Form data (RAW) and loads it to S3.
    """
    # Use underscore for SQL table name format
    table_date = date_str.replace('-', '_')
    table_name = f"Web_form_request_{table_date}"
    
    # Use environment variables from .env
    DB_USER = os.getenv('DB_USER')
    DB_PASSWORD = os.getenv('DB_PASSWORD')
    DB_HOST = os.getenv('DB_HOST')
    DB_PORT = os.getenv('DB_PORT')
    DB_NAME = os.getenv('DB_NAME')
    
    db_url = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

    try:
        engine = create_engine(db_url)
        
        # --- QUICK TEST LIMIT IN SQL ---
        query = f"SELECT * FROM {table_name} LIMIT 10"
        # ---------------------------------
        
        # Step 1: Extract from Postgres
        # FIX: Added dtype=str to avoid 'None' to int conversion errors
       # FIX: Added dtype=str to force string conversion and avoid the 'None' to int conversion errors
        df = pd.read_sql(query, engine, dtype=str, index_col=None) 
        print(f"Successfully extracted RAW {table_name} from Postgres. Rows: {len(df)}")

        # Step 2: Load to Target Raw Data Lake (as Parquet)
        upload_dataframe_to_s3(
            df=df, 
            file_name=f'web_forms_{date_str}', 
            key_path='web_forms' 
        )
        
    except Exception as e:
        # If the table doesn't exist, this is the error we expect
        if "relation" in str(e) and "does not exist" in str(e):
            print(f" Warning: Postgres table {table_name} not found. Skipping extraction.")
        else:
            print(f" Critical Error in Web Forms RAW ETL for {table_name}: {e}")


# --- TEST EXECUTION ---

if __name__ == "__main__":
    # Use today's date for daily structure (change to a fixed date if your source tables use historical names)
    #TEST_DATE = datetime.now().strftime("%Y-%m-%d") 
    TEST_DATE = datetime(2025, 11, 20).strftime("%Y-%m-%d")
    
    print(f"\n--- Running Web Forms Pipeline (RAW Load) for {TEST_DATE} ---")
    extract_and_load_raw_postgres(TEST_DATE)