#  Telecom Analytics Platform — Data Vault 2.0

##  Overview

This project demonstrates the design and implementation of a **Telecom Data Warehouse** using the **Data Vault 2.0 architecture**.
It integrates multiple telecom data sources and builds scalable ETL pipelines to enable historical tracking, analytics, and business insights.

---

##  Architecture

The solution follows a layered architecture:

```
Sources → Staging (STG) → Data Vault (Hubs, Links, Satellites) → Business Vault → Data Mart → BI
```

###  Data Vault Components

* **Hubs** → Store business keys (Customer, Device, Complaint, etc.)
* **Links** → Represent relationships between entities
* **Satellites** → Store descriptive attributes with full history tracking

---

##  Data Sources

| Source     | Description          |
| ---------- | -------------------- |
| CRM        | Customer information |
| CDR        | Call Detail Records  |
| Payments   | Transactions data    |
| Complaints | Customer complaints  |
| Plans      | Subscription plans   |
| Devices    | Customer devices     |

---

##  Technologies Used

* **Informatica Cloud (IICS)** — ETL Pipelines
* **SQL Server** — Data Warehouse Storage
* **Data Vault 2.0** — Data Modeling
* **Power BI** — Data Visualization
* **Python** — Data generation & preprocessing

---

## ETL Pipeline

### Staging Layer (STG)

* Data ingestion from CSV sources
* Data cleaning and standardization
* Validation rules:

  * Not null checks
  * Deduplication
  * Positive value validation
* Reject handling using Router transformation

---

###  Data Vault Layer

#### Hubs

* `HUB_CUSTOMER`
* `HUB_DEVICE`
* `HUB_COMPLAINT`
* `HUB_PAYMENT`
* `HUB_PLAN`
* `HUB_CALL`
* `HUB_TOWER`

✔ Hash Keys (MD5)
✔ Insert-only pattern
✔ Source tracking (`rec_src`)

---

#### Links

* `LINK_DEVICE_CUSTOMER`
* `LINK_COMPLAINT_TOWER_CUSTOMER`
* `LINK_PAYMENT_CUSTOMER`
* `LINK_CALL_CUSTOMER_TOWER`

✔ Relationship modeling
✔ No descriptive data

---

#### Satellites

* `SAT_CUSTOMER_DETAILS`
* `SAT_DEVICE_DETAILS`
* `SAT_COMPLAINT_DETAILS`
* `SAT_PAYMENT_DETAILS`

✔ Historical tracking
✔ Change detection using **hashdiff**
✔ Insert-only versioning

---

###  Business Vault

* Derived metrics and business logic
* Example:

  * Customer churn indicators
  * Payment behavior metrics
  * Complaint resolution KPIs

---

###  Data Mart Layer

#### Fact Tables

* `FCT_CALLS`
* `FCT_PAYMENTS`
* `FCT_COMPLAINTS`

#### Dimension Tables

* `DIM_CUSTOMER`
* `DIM_DEVICE`
* `DIM_PLAN`
* `DIM_DATE`
* `DIM_TOWER`

---

##  Dashboards (Power BI)

*  Executive Overview
*  Churn Risk Monitor
* Network Health Analysis
*  Revenue & Payments

---

##  Key Features

*  Scalable Data Vault 2.0 architecture
*  End-to-end ETL pipeline using Informatica Cloud
*  Full historical tracking (Slowly Changing Data)
*  Data quality layer with reject handling
*  Multi-source data integration
*  Business-ready analytics

---

##  How to Run

1. Load source CSV files into staging tables
2. Execute ETL pipelines in Informatica Cloud:

   * STG mappings
   * HUB mappings
   * LINK mappings
   * SAT mappings
3. Validate data in SQL Server
4. Connect Power BI to Data Mart

---

##  Project Highlights

* Designed enterprise-grade data warehouse architecture
* Implemented Data Vault best practices (hash keys, hashdiff, insert-only)
* Built scalable pipelines handling multiple telecom datasets
* Delivered analytical insights for business decision-making

---


* GitHub: *(add your link)*

---
