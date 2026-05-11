#  Telecom Analytics Platform — Data Vault 2.0

##  Overview

This project demonstrates the design and implementation of a **Telecom Data Warehouse** using the **Data Vault 2.0 architecture** with **IICS (Informatica Intelligent Cloud Services)** .
It integrates multiple telecom data sources and builds scalable ETL pipelines to enable historical tracking, analytics, and business insights Using Informatica.

---

## dashboard 
<img width="2075" height="1200" alt="Telecom Data Analytics DashBoard_page-0001" src="https://github.com/user-attachments/assets/6730b8cf-e13d-4c73-9cc1-f4a8ff9f3b99" />

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

Hash Keys (MD5)
Insert-only pattern
Source tracking (`rec_src`)

<img width="1734" height="495" alt="hup_plan" src="https://github.com/user-attachments/assets/e5682f15-f4a2-48dd-af7e-d59be2fe1fb1" />
<img width="1727" height="495" alt="hup_payment" src="https://github.com/user-attachments/assets/0f7b1885-67c2-45df-ba11-0113b1de1abe" />
<img width="1727" height="495" alt="hup_payment" src="https://github.com/user-attachments/assets/82273151-c1e9-45f6-96d8-a15f87147ea1" />



---

#### Links

* `LINK_DEVICE_CUSTOMER`
* `LINK_COMPLAINT_TOWER_CUSTOMER`
* `LINK_PAYMENT_CUSTOMER`
* `LINK_CALL_CUSTOMER_TOWER`

 Relationship modeling
No descriptive data
<img width="1734" height="498" alt="link_call_cust" src="https://github.com/user-attachments/assets/7988bc3d-ab5a-4eed-b226-34500024ac78" />
<img width="1736" height="507" alt="link_pay_cust" src="https://github.com/user-attachments/assets/a33329fe-45f1-427c-8e11-c86685b5f78c" />



---

#### Satellites

* `SAT_CUSTOMER_DETAILS`
* `SAT_DEVICE_DETAILS`
* `SAT_COMPLAINT_DETAILS`
* `SAT_PAYMENT_DETAILS`

 Historical tracking
 Change detection using **hashdiff**
 Insert-only versioning
 <img width="1731" height="498" alt="sat_plan" src="https://github.com/user-attachments/assets/1cee3118-d812-4f2d-b558-6d9ccd41985e" />
 <img width="1732" height="494" alt="sat_paym" src="https://github.com/user-attachments/assets/ece6e37e-933b-4360-b21d-c01b5a095a6e" />


 

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
## Workflows - job scheduling : 
<img width="1195" height="316" alt="workflow" src="https://github.com/user-attachments/assets/c7741638-045c-4185-b309-624bee893a4c" />

<img width="1048" height="503" alt="workflow_2" src="https://github.com/user-attachments/assets/42a53bc3-8145-4f64-b9bc-ea6a895dac53" />
<img width="924" height="424" alt="workflow_01" src="https://github.com/user-attachments/assets/fc990883-2b27-4b0e-9e31-af006ef3e165" />



---
