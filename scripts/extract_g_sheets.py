# scripts/extract_g_sheets.py

import pandas as pd
import gspread
import os
from dotenv import load_dotenv
from .s3_utils import upload_dataframe_to_s3 

load_dotenv()

# --- Configuration from Environment ---
GCP_KEY_FILE_PATH = os.getenv('GCP_SERVICE_KEY_PATH')
SPREADSHEET_URL = os.getenv('GOOGLE_SHEET_URL')
# Uses 'agents' from .env, defaults to 'Sheet1'
SHEET_NAME = os.getenv('GOOGLE_SHEET_WORKSHEET', 'agents') 
# --------------------------------------

def extract_and_load_g_sheets(sheet_url: str, worksheet_name: str, key_path: str):
    """
    Authenticates, extracts data from a Google Sheet (Agents), and loads it raw to S3.
    """
    if not GCP_KEY_FILE_PATH or not sheet_url:
        print("❌ Configuration Error: GCP_SERVICE_KEY_PATH or GOOGLE_SHEET_URL is missing.")
        return

    print(f"-> Attempting to connect to Google Sheet: {worksheet_name}")
    try:
        # 1. Authenticate using the service account key file
        gc = gspread.service_account(filename=GCP_KEY_FILE_PATH)

        # 2. Open the spreadsheet by URL
        spreadsheet = gc.open_by_url(sheet_url)
        worksheet = spreadsheet.worksheet(worksheet_name)
        
        # 3. Get all data as a list of lists (header row included)
        data = worksheet.get_all_values()

        # 4. Convert to DataFrame
        df = pd.DataFrame(data[1:], columns=data[0])

        # --- QUICK TEST LIMIT ---
        df = df.head(10) 
        # ------------------------
        
        print(f"Successfully extracted data from {worksheet_name}. Rows: {len(df)}")

        # 5. Load to Target Raw Data Lake (as Parquet)
        # Key path is set to 'agents'
        upload_dataframe_to_s3(
            df=df, 
            file_name=SHEET_NAME, 
            key_path=key_path
        )
        
    except Exception as e:
        print(f"❌ Critical Error in Google Sheets ETL for {worksheet_name}: {e}")
        # Reminder: Ensure the service account email is shared with the Google Sheet.


if __name__ == "__main__":
    print(f"\n--- Running Google Sheets Pipeline ---")
    extract_and_load_g_sheets(
        sheet_url=SPREADSHEET_URL,
        worksheet_name=SHEET_NAME,
        key_path='agents' # Use 'agents' as the S3 folder path
    )