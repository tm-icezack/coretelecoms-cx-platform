# CoreTelecoms CX Platform: Production Data Pipeline

The **CoreTelecoms CX Platform** is a robust, production-grade data pipeline designed to efficiently manage and analyze complex, multi-source data streams. It enhances data ingestion, processing, modeling, and analytics while ensuring high reliability, automation, and scalability.

---

## Key Features

- **Production-Grade ELT Solution**  
  Seamlessly ingests data from multiple systems and transforms it for analytics.

- **Resilient Raw Data Layer (AWS S3 + Terraform)**  
  A secure, scalable landing zone for all raw, unmodeled data.

- **Structured Analytics**  
  Snowflake + DBT deliver clean, governed analytical marts for business intelligence.

---

## Data Integration Sources

The platform ingests and centralizes data from:

- **AWS S3** — CSV and JSON datasets  
- **PostgreSQL** — Transactional database (credentials via AWS SSM)  
- **Google Sheets** — Private spreadsheet extraction via Google API  

---

## Architecture Overview (ELT Workflow)

The system uses a modern **Extract → Load → Transform** pipeline:

### **1. Extract & Load (EL)**
- Containerized Python ETL services pull data from S3, PostgreSQL, and Google Sheets  
- Data is converted into **Parquet** format  
- Parquet files are stored in the **S3 Raw Zone**

### **2. Staging & Modeling (LT)**
- Airflow triggers S3 → Snowflake ingestion jobs  
- **DBT** applies transformations, tests, and builds analytical layers

### **3. Orchestration**
- **Apache Airflow** schedules ingestion, loading, DBT runs, and automated workflows

---

## Project Overview / Background

The upgraded platform is now a **production-grade ELT solution** that:

- Ingests complex data sources (S3, Postgres, Google Sheets)  
- Converts all extracted data into **Parquet** for fast, columnar storage  
- Stores extracted datasets in an **AWS S3 Raw Layer** provisioned with **Terraform**
- Loads and transforms data using **Snowflake + DBT**  
- Uses **Apache Airflow** for end-to-end automation  
- Retrieves database credentials securely via **AWS SSM Parameter Store**
- Containerizes services with **Docker** and publishes images to **Docker Hub**

This design ensures data integrity, auditability, and scalable analytics.

---


---

## Tooling & Technology Stack

| Technology            | Purpose                           | Role in Pipeline |
|----------------------|-----------------------------------|------------------|
| **Snowflake**        | Cloud Data Warehouse               | Analytical store |
| **DBT**              | Transformations & Modeling          | Build marts & staging |
| **Apache Airflow**   | Workflow Orchestration              | Schedules entire pipeline |
| **Python**           | ETL Scripting                       | Extract + Load |
| **AWS S3 (Raw Zone)**| Object Storage                      | Raw Parquet storage |
| **Parquet**          | Data Format                         | Columnar compression |
| **AWS SSM**          | Secure Secret Storage               | Postgres credentials |
| **PostgreSQL**       | Transactional Source                | Website complaint data |
| **boto3**            | AWS Python SDK                      | S3 & SSM access |
| **Docker / Compose** | Container orchestration (local dev) | Reproducible env |
| **Google Sheets API**| External Data Source                | Agents lookup data |

---

## Architecture Diagram 
<img width="595" height="600" alt="Gemini_Generated_Image_1jukg01jukg01juk" src="https://github.com/user-attachments/assets/bf2955df-ff88-4003-907f-2b826bc42b42" />



---

## Prerequisites

- Docker & Docker Compose  
- Python 3.8+  
- AWS credentials with S3 + SSM access  
- Google Service Account JSON  
- Snowflake account  

## Production Data Pipeline Setup Guide

### 1. Clone the Repository

```bash
git clone https://github.com/tm-icezack/coretelecoms-cx-platform.git
cd coretelecoms-cx-platform
```

---

## 2. Configure Environment Variables

Copy the sample environment file:

```bash
cp .env.example .env
```

Then update the following variables inside `.env`:

### **AWS Credentials**

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_DEFAULT_REGION`

### **Snowflake Credentials**

* `SNOWFLAKE_ACCOUNT`
* `SNOWFLAKE_USER`
* `SNOWFLAKE_PASSWORD`
* `SNOWFLAKE_DATABASE`
* `SNOWFLAKE_SCHEMA`
* `SNOWFLAKE_WAREHOUSE`

Add any other environment variables your deployment requires.

> **IMPORTANT:**
> **Never commit real credentials to GitHub.** Keep `.env` in `.gitignore`.

---

## 3. Secure Credential Setup (AWS SSM)

Manually upload **PostgreSQL database credentials** to AWS SSM Parameter Store (region: **eu-north-1 / Stockholm**):

Required parameters:

* `POSTGRES_USERNAME`
* `POSTGRES_PASSWORD`
* `POSTGRES_HOST`
* `POSTGRES_PORT`

The ETL script (`ingest_postgres.py`) automatically retrieves these via `boto3` during runtime.

---

## 4. Add Google Service Account JSON

Place your Google Sheets service account key at:

```
airflow/service_account.json
```

---

## 5. Build and Start Docker Containers

```bash
docker-compose up --build
```

---

## 6. Access Airflow UI

Open Airflow in your browser:

👉 **[http://localhost:8080](http://localhost:8080)**

Use it to monitor and trigger DAGs.

---

## 7. Run ETL and DBT Pipeline

Airflow orchestrates the full workflow:

### **Ingestion Layer (Raw Zone)**

* Pulls data from:

  * AWS S3 (CSV/JSON)
  * PostgreSQL (via SSM)
  * Google Sheets
* Converts all sources to **Parquet**
* Writes them to **S3 Raw Data Lake**

### **Staging Layer**

Airflow triggers jobs that load raw Parquet files into Snowflake staging tables.

### **Transformation Layer**

Airflow runs **dbt** to build:

* Staging models
* Intermediate models
* Final analytics marts

---

## 8. Troubleshooting Logs

Use Docker logs to inspect services:

```bash
docker logs -f airflow-scheduler
docker logs -f coretelecoms-etl
```

---




