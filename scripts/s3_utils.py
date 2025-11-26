import boto3
import pandas as pd
import os
import io

def upload_dataframe_to_s3(df: pd.DataFrame, file_name: str, key_path: str):
    """
    Converts a Pandas DataFrame to Parquet format and uploads it to the 
    RAW Data Lake S3 bucket with the specified key structure.
    """
    RAW_BUCKET = os.getenv('RAW_DATA_LAKE_BUCKET_NAME')
    
    if RAW_BUCKET is None:
        RAW_BUCKET = 'coretelecoms-raw-data-lake-isaac'

    s3_key = f'raw/{key_path}/{file_name}.parquet'
    
    print(f"-> Preparing to upload {len(df)} rows to S3 at: s3://{RAW_BUCKET}/{s3_key}")
    
    buffer = io.BytesIO()
    df.to_parquet(buffer, index=False)
    buffer.seek(0)
    
    s3 = boto3.client(
        's3',
        aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
        region_name=os.getenv('AWS_REGION')
    )

    try:
        s3.put_object(Bucket=RAW_BUCKET, Key=s3_key, Body=buffer.getvalue())
        print(f"✅ Successfully uploaded {len(df)} rows to s3://{RAW_BUCKET}/{s3_key}")
    except Exception as e:
        print(f"❌ S3 Upload Failed: {e}")