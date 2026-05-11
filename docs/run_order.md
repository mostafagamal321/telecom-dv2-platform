# SQL Run Order

Run these scripts in SQL Server Management Studio or `sqlcmd` after generating the CSV files.

## 1. Generate Source Data

```powershell
pip install -r requirements.txt
python scripts/generate_data.py
```

Expected files in `data/raw/`:

- `customers.csv`
- `plans.csv`
- `cdr.csv`
- `complaints.csv`
- `payments.csv`
- `devices.csv`
- `kaggle_telco.csv`

## 2. Create Databases

```text
sql/00_database/00_create_databases.sql
```

This script creates the four local SQL Server databases only. It does not create logins or grant server-level permissions.

## 3. Create Warehouse Tables

Run in this order:

```text
sql/01_staging/01_create_staging_tables.sql
sql/02_raw_vault/01_create_raw_vault_tables.sql
sql/03_business_vault/01_create_business_vault_tables.sql
sql/04_info_mart/01_create_information_mart_tables.sql
```

## 4. Load Data

Load CSV files into the staging tables using SSMS Import Wizard, BULK INSERT, Azure Data Studio, or your preferred ETL tool. Record each load in `telecom_staging.dbo.AUDIT_LOG`.

After loading CSVs into staging, run:

```text
sql/02_raw_vault/02_load_raw_vault_from_staging.sql
sql/03_business_vault/02_populate_pit_customer.sql
sql/03_business_vault/03_populate_bridge_customer_plan_device.sql
sql/03_business_vault/04_populate_bsat_churn_score.sql
sql/04_info_mart/02_load_information_mart.sql
```

## 5. Validate

```text
tests/data_quality_checks.sql
docs/sample_queries.sql
```

Use the quality checks first, then run the sample queries to demonstrate the analytical output.
