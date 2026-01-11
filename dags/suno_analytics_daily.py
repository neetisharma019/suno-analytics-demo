"""
Airflow DAG for Suno Analytics daily pipeline.

This DAG runs the dbt models and tests on a daily schedule.
"""

from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'analytics',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'suno_analytics_daily',
    default_args=default_args,
    description='Daily dbt run and test for Suno Analytics',
    schedule_interval='@daily',
    start_date=datetime(2025, 11, 1),
    catchup=False,
    tags=['analytics', 'dbt', 'suno'],
)

# Task to run dbt dependencies
dbt_deps = BashOperator(
    task_id='dbt_deps',
    bash_command='cd /opt/airflow/dags/../suno-analytics-demo/suno_analytics && dbt deps',
    dag=dag,
)

# Task to run dbt models
dbt_run = BashOperator(
    task_id='dbt_run',
    bash_command='cd /opt/airflow/dags/../suno-analytics-demo/suno_analytics && dbt run',
    dag=dag,
)

# Task to run dbt tests
dbt_test = BashOperator(
    task_id='dbt_test',
    bash_command='cd /opt/airflow/dags/../suno-analytics-demo/suno_analytics && dbt test',
    dag=dag,
)

# Set task dependencies
dbt_deps >> dbt_run >> dbt_test

