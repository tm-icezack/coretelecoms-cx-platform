from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2025, 12, 1),
    'retries': 1
}

with DAG('etl_then_dbt',
         default_args=default_args,
         schedule_interval=None,
         catchup=False) as dag:

    run_etl = BashOperator(
    task_id='run_etl',
    bash_command='cd /opt/airflow && python -m scripts.main',
    dag=dag
    )




    run_dbt = BashOperator(
    task_id='run_dbt',
    bash_command='dbt run --project-dir /opt/airflow/dbt --profiles-dir /opt/airflow/dbt',
    )

    run_etl >> run_dbt
