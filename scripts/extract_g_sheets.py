# scripts/extract_g_sheets.py

import pandas as pd
import gspread
import os
from dotenv import load_dotenv
from .s3_utils import upload_dataframe_to_s3 

load_dotenv()

# --- Configuration from Environment ---
GCP_KEY_FILE_PATH = os.getenv('GCP_SERVICE_KEY_PATH', '/opt/airflow/service_account.json')
SPREADSHEET_URL = os.getenv('GOOGLE_SHEET_URL')
# Uses 'agents' from .env, defaults to 'Sheet1'
SHEET_NAME = os.getenv('GOOGLE_SHEET_WORKSHEET', 'agents') 
# --------------------------------------
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = GCP_KEY_FILE_PATH
# ----------------------------------------------------------
# FUNCTION: EXTRACT FROM GOOGLE SHEETS AND LOAD TO S3

def extract_and_load_g_sheets(sheet_url: str, worksheet_name: str, key_path: str):
    """
    Authenticates, extracts data from a Google Sheet (Agents), and loads it raw to S3.
    """
    if not GCP_KEY_FILE_PATH or not sheet_url:
        print("❌ Configuration Error: GCP_SERVICE_KEY_PATH or GOOGLE_SHEET_URL is missing.")
        return

    print(f"-> Attempting to connect to Google Sheet: {worksheet_name}")
    try:
        gc = gspread.service_account(filename=GCP_KEY_FILE_PATH)
        spreadsheet = gc.open_by_url(sheet_url)
        worksheet = spreadsheet.worksheet(worksheet_name)
        data = worksheet.get_all_values()
        df = pd.DataFrame(data[1:], columns=data[0])

        # --- QUICK TEST LIMIT ---
        #df = df.head(10)
        # ------------------------

        print(f"Successfully extracted data from {worksheet_name}. Rows: {len(df)}")

        upload_dataframe_to_s3(
            df=df, 
            file_name=SHEET_NAME, 
            key_path=key_path
        )

    except Exception as e:
        print(f"❌ Critical Error in Google Sheets ETL for {worksheet_name}: {e}")


# ----------------------------------------------------------
# NEW: run() WRAPPER FOR scripts.main TO IMPORT AND EXECUTE
# ----------------------------------------------------------

def run():
    """
    Entry point for Google Sheets extraction when called from scripts.main
    """
    print("\n--- Running Google Sheets Pipeline ---")
    extract_and_load_g_sheets(
        sheet_url=SPREADSHEET_URL,
        worksheet_name=SHEET_NAME,
        key_path='agents'  # Use 'agents' as the S3 folder path
    )


# ------------------------------
# LOCAL TEST RUN
# ------------------------------

if __name__ == "__main__":
    run()
