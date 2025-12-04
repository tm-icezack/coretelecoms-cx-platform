<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CoreTelecoms CX Platform Documentation</title>
    <!-- Load Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f7f9fc;
        }
        /* Custom styling for the project structure block */
        .project-structure {
            background-color: #1f2937; /* Dark background */
            color: #d1d5db;
            padding: 1rem;
            border-radius: 0.5rem;
            overflow-x: auto;
            white-space: pre;
            font-size: 0.875rem;
            line-height: 1.4;
        }
    </style>
</head>
<body class="p-4 sm:p-8">

    <div class="max-w-6xl mx-auto bg-white shadow-xl rounded-xl p-6 md:p-10">
        <!-- Header -->
        <header class="pb-6 border-b border-gray-200 mb-6">
            <h1 class="text-4xl font-extrabold text-indigo-800">CoreTelecoms CX Platform: Production Data Pipeline</h1>
        </header>

        <!-- Project Overview / Background -->
        <section class="mb-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-4 border-l-4 border-indigo-500 pl-3">Project Overview / Background</h2>
            <p class="text-gray-600 mb-4">
                The CoreTelecoms CX Platform has been upgraded to a **production-grade ELT solution** designed to ingest complex, multi-source data streams, establish a resilient Raw Data Layer, and provide structured analytics for business intelligence.
            </p>
            <p class="text-gray-600 mb-4">
                The platform now integrates data from disparate sources, including AWS S3 buckets (CSV, JSON), a transactional PostgreSQL database (via AWS SSM), and a private Google Spreadsheet. The core architecture follows an ELT pattern:
            </p>
            <ol class="list-decimal list-inside space-y-2 text-gray-700 ml-4">
                <li>
                    <span class="font-semibold text-indigo-700">Extract & Load (EL) to Raw Layer:</span> Data is extracted by a containerized Python service, immediately converted into the **Parquet format** for efficient storage and querying, and loaded into an AWS S3 Raw Zone.
                </li>
                <li>
                    <span class="font-semibold text-indigo-700">Staging & Modeling (LT):</span> Data is moved from S3 Raw Zone into the **Snowflake** data warehouse, where **DBT** (Data Build Tool) executes complex transformations and data modeling, creating clean, performance-optimized Analytical Marts.
                </li>
                <li>
                    <span class="font-semibold text-indigo-700">Orchestration:</span> **Apache Airflow** manages and automates all ingestion and transformation workflows, ensuring data is processed daily with high reliability.
                </li>
            </ol>
            <p class="text-gray-600 mt-4">
                This design ensures data integrity, security (leveraging AWS SSM for credentials), and scalability across all data operations.
            </p>
        </section>

        <!-- Project Structure -->
        <section class="mb-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-4 border-l-4 border-indigo-500 pl-3">Project Structure</h2>
            <p class="text-gray-600 mb-4">
                The structure has been expanded to include dedicated infrastructure management and a clearly defined ETL layer to handle the diverse data sources.
            </p>
            <pre class="project-structure">coretelecoms-cx-platform/
│
├── airflow/                      # Apache Airflow Configuration and DAGs
│   ├── dags/                     # Airflow DAG definitions (Ingestion, Transformation)
│   ├── postgres-data/            # Airflow metadata database storage (local dev)
│   └── service_account.json      # Google Sheets service account credentials
│
├── core_telecoms_dbt/            # DBT project for data modeling in Snowflake
│   ├── models/                   # DBT models (staging, intermediate, and marts)
│   ├── macros/                   # Reusable DBT macros
│   ├── seeds/                    # CSV seed data for DBT
│   ├── snapshots/                # DBT snapshots
│   ├── dbt_project.yml           # DBT project configuration
│   └── profiles.yml              # DBT profiles configuration
│
├── scripts/                      # Python ETL scripts and utilities
│   ├── ingest_s3.py              # Handles Customers, Call Logs, Social Media ingestion (S3 -> Parquet -> S3 Raw)
│   ├── ingest_postgres.py        # Handles Website Forms ingestion (Postgres DB -> Parquet -> S3 Raw)
│   └── ingest_sheets.py          # Handles Agents ingestion (Google Sheets -> Parquet -> S3 Raw)
│
├── infrastructure/               # Terraform or CloudFormation code for cloud resources
│   └── aws_resources.tf          # Defines S3 Buckets, SSM Parameters, etc.
│
├── Dockerfile.airflow            # Dockerfile for Airflow containers
├── Dockerfile.etl                # Dockerfile for the robust ETL container (Python, boto3, psycopg2, pyarrow)
├── docker-compose.yml            # Docker Compose orchestration
└── .env                          # Environment variables for local development (Credentials & Configurations)
</pre>
        </section>

        <!-- Architecture Diagram -->
        <section class="mb-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-4 border-l-4 border-indigo-500 pl-3">Architecture Diagram</h2>
            <p class="text-gray-600 mb-4">
                The new architecture incorporates a dedicated **Raw S3 Zone** to serve as the initial, secure landing area for all extracted data.
            </p>
            <div class="flex justify-center p-4 bg-gray-50 rounded-lg border border-gray-200">
                <!-- Placeholder for a simple flow diagram -->
                
            </div>
        </section>

        <!-- Choice of Tools and Technology -->
        <section class="mb-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-4 border-l-4 border-indigo-500 pl-3">Choice of Tools and Technology</h2>
            <p class="text-gray-600 mb-4">
                The platform utilizes a comprehensive suite of tools to meet the production-grade requirements, specifically incorporating AWS services for secure data access and a dedicated Parquet format layer.
            </p>
            <div class="overflow-x-auto shadow-md rounded-lg">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-indigo-600 text-white">
                        <tr>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Tool / Technology</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Purpose</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Specific Role in the Pipeline</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap font-medium text-gray-900">Snowflake</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Cloud Data Warehouse</td>
                            <td class="px-6 py-4 text-sm text-gray-700">Final destination for analytical data; provides performance and scalability for querying modeled data.</td>
                        </tr>
                        <tr class="hover:bg-gray-50 bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap font-medium text-gray-900">DBT (Data Build Tool)</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Data Modeling & Transformations</td>
                            <td class="px-6 py-4 text-sm text-gray-700">Executes the **Transform** step within Snowflake to create highly optimized analytical marts.</td>
                        </tr>
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap font-medium text-gray-900">Apache Airflow</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Workflow Orchestration</td>
                            <td class="px-6 py-4 text-sm text-gray-700">Schedules, monitors, and manages the entire end-to-end data pipeline (extraction, S3 loading, Snowflake staging, and DBT runs).</td>
                        </tr>
                        <tr class="hover:bg-gray-50 bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap font-medium text-gray-900">Python</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">ETL Scripting</td>
                            <td class="px-6 py-4 text-sm text-gray-700">Core engine for the **Extract** and initial **Load** logic. Used for connecting to all sources and performing in-memory data cleaning/standardization before Parquet conversion.</td>
                        </tr>
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap font-medium text-gray-900">AWS S3 (Raw Zone)</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Cloud Object Storage</td>
                            <td class="px-6 py-4 text-sm text-gray-700">**Mandatory Raw Data Layer.** Stores all ingested data immediately after extraction, converted to the **Parquet** format, along with metadata (load time).</td>
                        </tr>
                        <tr class="hover:bg-gray-50 bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap font-medium text-gray-900">Parquet</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Data Format Standard</td>
                            <td class="px-6 py-4 text-sm text-gray-700">Chosen format for the Raw Layer for its columnar storage benefits, providing compression and efficient read/write speeds.</td>
                        </tr>
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap font-medium text-gray-900">AWS SSM Parameter Store</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Secure Credential Management</td>
                            <td class="px-6 py-4 text-sm text-gray-700">Securely stores sensitive credentials, specifically the **Postgres Database credentials**, ensuring secrets are not exposed in code or environment files.</td>
                        </tr>
                        <tr class="hover:bg-gray-50 bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap font-medium text-gray-900">PostgreSQL</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Transactional Database Source</td>
                            <td class="px-6 py-4 text-sm text-gray-700">Source system for daily **Website Complaint Forms** data.</td>
                        </tr>
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap font-medium text-gray-900">boto3 (Python Library)</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">AWS SDK for Python</td>
                            <td class="px-6 py-4 text-sm text-gray-700">Used within the ETL scripts to interact with S3 (source files, Raw Zone storage) and AWS SSM (credential retrieval).</td>
                        </tr>
                        <tr class="hover:bg-gray-50 bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap font-medium text-gray-900">Docker / Compose</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Containerization & Orchestration</td>
                            <td class="px-6 py-4 text-sm text-gray-700">Ensures consistent, isolated, and reproducible environments for both the Airflow service and the ETL ingestion service.</td>
                        </tr>
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap font-medium text-gray-900">PostgreSQL (Metadata)</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Airflow Metadata Database</td>
                            <td class="px-6 py-4 text-sm text-gray-700">Backend database for Airflow to track DAG runs and task state.</td>
                        </tr>
                        <tr class="hover:bg-gray-50 bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap font-medium text-gray-900">Google Sheets API</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Data Source (Agents)</td>
                            <td class="px-6 py-4 text-sm text-gray-700">Provides programmatic access to extract the static **Agents** lookup data from the private spreadsheet.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Project Setup -->
        <section class="mb-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-4 border-l-4 border-indigo-500 pl-3">Project Setup</h2>

            <h3 class="text-xl font-semibold text-gray-700 mb-2 mt-4">Prerequisites</h3>
            <ul class="list-disc list-inside space-y-1 text-gray-600 ml-4">
                <li>Docker and Docker Compose</li>
                <li>Python >= 3.8</li>
                <li>AWS Account credentials configured for the Stockholm region (S3 and SSM access).</li>
                <li>Google Service Account JSON for Sheets access.</li>
                <li>Snowflake account credentials.</li>
            </ul>

            <h3 class="text-xl font-semibold text-gray-700 mb-2 mt-6">Steps</h3>
            <ol class="list-decimal list-inside space-y-4 text-gray-700 ml-4">
                <li>
                    <span class="font-semibold">Clone the repository</span>
                    <pre class="bg-gray-100 p-3 rounded text-sm text-gray-800 mt-1 overflow-x-auto">git clone https://github.com/tm-icezack/coretelecoms-cx-platform.git
cd coretelecoms-cx-platform</pre>
                </li>
                <li>
                    <span class="font-semibold">Configure Environment Variables</span>
                    <p class="text-sm text-gray-600 mt-1">
                        Copy `.env.example` to `.env` and update with your AWS credentials (Access Key/Secret Key for programmatic access), Snowflake credentials, and any other necessary environment variables. <span class="text-red-600 font-bold">DO NOT EXPOSE THE KEYS ON GITHUB.</span>
                    </p>
                </li>
                <li>
                    <span class="font-semibold">Secure Credential Setup (AWS SSM)</span>
                    <p class="text-sm text-gray-600 mt-1">
                        Manually upload the Postgres database credentials (username/password/host/port) to the AWS SSM Parameter Store in the Stockholm region. The ETL script (`ingest_postgres.py`) will retrieve these at runtime using <code class="bg-gray-200 px-1 rounded">boto3</code>.
                    </p>
                </li>
                <li>
                    <span class="font-semibold">Add Google Service Account JSON</span>
                    <p class="text-sm text-gray-600 mt-1">
                        Place your Google Sheets service account JSON file at <code class="bg-gray-200 px-1 rounded">airflow/service_account.json</code>.
                    </p>
                </li>
                <li>
                    <span class="font-semibold">Build and start containers</span>
                    <pre class="bg-gray-100 p-3 rounded text-sm text-gray-800 mt-1 overflow-x-auto">docker-compose up --build</pre>
                </li>
                <li>
                    <span class="font-semibold">Access Airflow UI</span>
                    <p class="text-sm text-gray-600 mt-1">
                        Open <a href="http://localhost:8080" class="text-indigo-600 hover:text-indigo-800 font-medium">http://localhost:8080</a> to monitor DAGs.
                    </p>
                </li>
                <li>
                    <span class="font-semibold">Run ETL and DBT</span>
                    <p class="text-sm text-gray-600 mt-1">
                        The Airflow DAGs will now handle the full pipeline:
                    </p>
                    <ul class="list-disc list-inside text-gray-600 ml-4 space-y-1 mt-1">
                        <li>**Ingestion:** ETL service reads from S3, Postgres (via SSM), and Sheets, converts to Parquet, and loads into the S3 Raw Zone.</li>
                        <li>**Staging:** Airflow triggers S3-to-Snowflake load jobs.</li>
                        <li>**Transformation:** Airflow triggers DBT to build the analytical models.</li>
                    </ul>
                </li>
                <li>
                    <span class="font-semibold">Check logs for issues</span>
                    <pre class="bg-gray-100 p-3 rounded text-sm text-gray-800 mt-1 overflow-x-auto">docker logs -f airflow-scheduler
docker logs -f coretelecoms-etl</pre>
                </li>
            </ol>
        </section>

    </div>

</body>
</html>
