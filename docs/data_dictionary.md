# Data Dictionary

## Source Files

| File | Grain | Description |
| --- | --- | --- |
| `customers.csv` | One row per customer | Customer profile, plan code, tenure, charges, and Kaggle churn label. |
| `plans.csv` | One row per plan | Plan name, average fee, data limit, and validity. |
| `cdr.csv` | One row per call/data/SMS event | Telecom usage events with tower, duration, cost, and dropped-call flag. |
| `complaints.csv` | One row per complaint | Complaint type, tower, status, and resolution time. |
| `payments.csv` | One row per payment | Payment amount, method, status, and plan relationship. |
| `devices.csv` | One row per customer device | Device IMEI, brand, model, operating system, and SIM count. |

## Staging Layer

The staging layer mirrors source structures and adds `load_dts` and `rec_src` metadata. `AUDIT_LOG` records load activity, and `STG_REJECTED_RECORDS` captures rejected rows with a reason.

## Raw Vault Layer

| Object Type | Tables | Purpose |
| --- | --- | --- |
| Hubs | `HUB_CUSTOMER`, `HUB_PLAN`, `HUB_CALL`, `HUB_TOWER`, `HUB_COMPLAINT`, `HUB_PAYMENT`, `HUB_DEVICE` | Store unique business keys. |
| Links | `LINK_CUST_PLAN`, `LINK_CALL_CUST`, `LINK_COMPLAINT_TOWER`, `LINK_PAYMENT_CUST`, `LINK_DEVICE_CUST` | Store relationships between hubs. |
| Satellites | `SAT_CUST_DETAILS`, `SAT_PLAN_DETAILS`, `SAT_CALL_METRICS`, `SAT_COMPLAINT_DETAILS`, `SAT_PAYMENT_DETAILS`, `SAT_DEVICE_DETAILS` | Store descriptive and historized attributes. |

Hash keys use 32-character MD5-style values. Satellites include hashdiff columns so changes can be detected without comparing every attribute.

## Business Vault Layer

| Table | Grain | Description |
| --- | --- | --- |
| `PIT_CUSTOMER` | Customer and snapshot date | Resolves the latest customer/device satellite records for monthly snapshots. |
| `BRIDGE_CUST_PLAN_DEVICE` | Customer-plan-device relationship | Simplifies analysis across plan and device relationships. |
| `BSAT_CHURN_SCORE` | Customer and load timestamp | Derived churn-risk attributes and risk flag. |

## Churn Score Logic

`BSAT_CHURN_SCORE` classifies customers as:

- `HIGH` if call drop rate is greater than 25% or failed payments are at least 3.
- `MEDIUM` if call drop rate is greater than 10% or average complaint resolution time is greater than 15 days.
- `LOW` otherwise.

## Information Mart

| Table | Type | Description |
| --- | --- | --- |
| `DIM_DATE` | Dimension | Calendar attributes for date-based analysis. |
| `DIM_CUSTOMER` | Dimension | Customer profile, commercial attributes, risk flag, and Kaggle churn label. |
| `DIM_PLAN` | Dimension | Plan attributes. |
| `DIM_TOWER` | Dimension | Tower and derived region. |
| `FCT_CALLS` | Fact | Usage events and network quality measures. |
| `FCT_COMPLAINTS` | Fact | Complaint activity and resolution time. |
| `FCT_PAYMENTS` | Fact | Payment activity and failure tracking. |
