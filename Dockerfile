# Base image
FROM python:3.12-slim

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install dbt
RUN pip install dbt-core dbt-postgres

# Copy scripts for ETL
COPY scripts/ ./scripts/
COPY service_account.json ./service_account.json
COPY .env ./.env

ENV PYTHONUNBUFFERED=1

CMD ["python", "-m", "scripts.main"]
