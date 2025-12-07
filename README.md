# Suno Analytics Engineering Demo

A complete end-to-end analytics engineering project demonstrating modern data pipeline practices using DuckDB, dbt, Airflow, and Python.

## Project Overview

This project simulates an analytics engineering workflow for Suno (an AI music generation platform), transforming raw event data into actionable business insights through a layered data transformation architecture.

## Architecture

```
┌─────────────┐
│  Raw CSVs   │  (data/raw_*.csv)
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Staging   │  (stg_events, stg_users, stg_subscriptions)
│   Models    │  - Clean, cast, parse JSON
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    Core     │  (dim_user, dim_song, fact_user_day)
│   Models    │  - Business logic, joins, aggregations
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    Marts    │  (mrt_product_funnel)
│   Models    │  - Business-ready metrics
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Dashboard  │  (funnel_dashboard.py)
│  & Reports  │
└─────────────┘
```

## Schema Diagram

```
raw_users
├── user_id (PK)
├── signup_ts
├── marketing_channel
├── region
└── is_creator

raw_events
├── event_id (PK)
├── event_timestamp
├── user_id (FK → raw_users)
├── song_id
├── event_type
└── properties (JSON)

raw_subscriptions
├── user_id (FK → raw_users)
├── plan_tier
├── is_active
├── current_period_start
└── current_period_end

         ┌─────────────┐
         │  dim_user   │
         └──────┬──────┘
                │
    ┌───────────┼───────────┐
    │           │           │
┌───▼───┐  ┌───▼───┐  ┌───▼──────┐
│dim_song│  │fact_  │  │mrt_      │
│       │  │user_  │  │product_  │
│       │  │day    │  │funnel    │
└───────┘  └───────┘  └──────────┘
```

## Setup Instructions

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure dbt Profile

Create a `~/.dbt/profiles.yml` file with the following configuration:

```yaml
suno_analytics:
  outputs:
    dev:
      type: duckdb
      path: suno_analytics.duckdb
      schema: main
  target: dev
```

### 3. Run dbt Commands

Navigate to the `suno_analytics` directory:

```bash
cd suno-analytics-demo/suno_analytics
```

Install dbt dependencies:

```bash
dbt deps
```

Run all models:

```bash
dbt run
```

Run all tests:

```bash
dbt test
```

Run a specific model:

```bash
dbt run --select stg_events
```

Run tests for a specific model:

```bash
dbt test --select stg_events
```

### 4. Generate Documentation

```bash
dbt docs generate
dbt docs serve
```

## Project Structure

```
suno-analytics-demo/
├── data/
│   ├── raw_events.csv          # Event data (song_generated, exported, etc.)
│   ├── raw_users.csv            # User signup data
│   └── raw_subscriptions.csv    # Subscription data
├── suno_analytics/
│   ├── dbt_project.yml          # dbt project configuration
│   ├── models/
│   │   ├── staging/
│   │   │   ├── sources.yml      # External CSV source definitions
│   │   │   ├── stg_events.sql   # Clean events, parse JSON
│   │   │   ├── stg_users.sql    # Clean user data
│   │   │   └── stg_subscriptions.sql  # Clean subscription data
│   │   ├── core/
│   │   │   ├── dim_user.sql     # User dimension with first song
│   │   │   ├── dim_song.sql     # Song dimension
│   │   │   └── fact_user_day.sql # Daily user activity facts
│   │   └── marts/
│   │       └── mrt_product_funnel.sql  # Product funnel metrics
│   └── schema.yml               # Data quality tests & documentation
├── dags/
│   └── suno_analytics_daily.py  # Airflow DAG for daily pipeline
├── dashboard/
│   └── funnel_dashboard.py      # Python script to visualize funnel
├── requirements.txt             # Python dependencies
└── README.md                    # This file
```

## Business Questions Answered

1. **Product Funnel Analysis**: How many users progress from signup → first song → first export → paid subscription?
2. **User Engagement**: What is the daily activity per user (songs generated, exported, extended)?
3. **User Segmentation**: Which users are creators? What marketing channels drive signups?
4. **Song Analytics**: What genres, moods, and model versions are most popular?
5. **Conversion Rates**: What percentage of users convert at each funnel stage?

## Key Features

### Data Quality Tests

- **Uniqueness**: Ensures no duplicate event_ids, user_ids, song_ids
- **Not Null**: Validates required fields are populated
- **Accepted Values**: Validates event_type, plan_tier, marketing_channel
- **Relationships**: Ensures referential integrity between tables

### Staging Layer

- Cleans and standardizes raw data
- Parses JSON properties from events
- Casts data types appropriately
- Adds derived fields (event_date, signup_date)

### Core Layer

- **dim_user**: Single source of truth for user attributes
- **dim_song**: One row per generated song
- **fact_user_day**: Daily grain fact table for user activity

### Marts Layer

- **mrt_product_funnel**: Business-ready metrics for product analytics

## Why This Demonstrates Analytics Engineering Skills

1. **Modern Stack**: Uses DuckDB (fast analytical database) + dbt (transformation framework)
2. **Layered Architecture**: Follows medallion architecture (bronze → silver → gold)
3. **Data Quality**: Comprehensive testing with dbt tests
4. **Documentation**: Self-documenting with schema.yml descriptions
5. **Orchestration**: Airflow DAG for production scheduling
6. **Visualization**: Python dashboard for stakeholder communication
7. **Best Practices**: Modular, testable, maintainable code structure

## Running the Dashboard

After running `dbt run`, execute the dashboard script:

```bash
cd suno-analytics-demo/dashboard
python funnel_dashboard.py
```

This will:
1. Connect to the DuckDB database
2. Query the `mrt_product_funnel` model
3. Generate a bar chart visualization
4. Save as `funnel_dashboard.png`

## Airflow Integration

The Airflow DAG (`suno_analytics_daily.py`) runs:
1. `dbt deps` - Install dependencies
2. `dbt run` - Execute all models
3. `dbt test` - Run data quality tests

To use with Airflow:
1. Copy the DAG file to your Airflow `dags/` directory
2. Ensure dbt is installed in your Airflow environment
3. Adjust paths in the DAG to match your setup

## Next Steps

- Add more marts (marketing attribution, retention analysis)
- Implement incremental models for large datasets
- Add snapshots for SCD Type 2 tracking
- Create additional dashboards (user retention, song popularity)
- Set up CI/CD for dbt runs

## License

This is a demo project for educational purposes.

