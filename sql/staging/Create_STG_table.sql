USE telecom_staging;

CREATE TABLE AUDIT_LOG (
    audit_id        INT IDENTITY(1,1) PRIMARY KEY,
    mapping_name    VARCHAR(100),
    source_file     VARCHAR(200),
    rows_read       INT,
    rows_inserted   INT,
    rows_rejected   INT,
    run_start_time  DATETIME,
    run_end_time    DATETIME,
    status          VARCHAR(20)
);


USE telecom_staging;

CREATE TABLE STG_CUSTOMER (
    customer_id       VARCHAR(20),
    name              VARCHAR(100),
    dob               DATE,
    city              VARCHAR(50),
    segment           VARCHAR(20),
    gender            CHAR(1),
    phone             VARCHAR(15),
    plan_code         VARCHAR(20),
    tenure_months     INT,
    monthly_charges   DECIMAL(10,2),
    kaggle_churn_label VARCHAR(5),   -- YES / NO from Kaggle — keep for validation!
    load_dts          DATETIME DEFAULT GETDATE(),
    rec_src           VARCHAR(50) DEFAULT 'KAGGLE_TELCO'
);

CREATE TABLE STG_PLAN (
    plan_code       VARCHAR(20),
    plan_name       VARCHAR(50),
    monthly_fee     DECIMAL(10,2),
    data_limit_gb   INT,
    validity_days   INT,
    load_dts        DATETIME DEFAULT GETDATE(),
    rec_src         VARCHAR(50) DEFAULT 'KAGGLE_TELCO'
);

CREATE TABLE STG_CDR (
    call_id        VARCHAR(20),
    customer_id    VARCHAR(20),
    tower_id       VARCHAR(20),
    call_type      VARCHAR(10),
    duration_sec   INT,
    cost           DECIMAL(10,2),
    dropped_flag   TINYINT,
    call_date      DATE,
    load_dts       DATETIME DEFAULT GETDATE(),
    rec_src        VARCHAR(50) DEFAULT 'CDR_FILE'
);

CREATE TABLE STG_COMPLAINT (
    complaint_id       VARCHAR(20),
    customer_id        VARCHAR(20),
    tower_id           VARCHAR(20),
    complaint_type     VARCHAR(50),
    status             VARCHAR(20),
    resolution_days    INT,
    complaint_date     DATE,
    load_dts           DATETIME DEFAULT GETDATE(),
    rec_src            VARCHAR(50) DEFAULT 'COMPLAINTS_FILE'
);

CREATE TABLE STG_PAYMENT (
    payment_id       VARCHAR(20),
    customer_id      VARCHAR(20),
    plan_code        VARCHAR(20),
    amount           DECIMAL(10,2),
    payment_method   VARCHAR(30),
    payment_status   VARCHAR(20),
    payment_date     DATE,
    load_dts         DATETIME DEFAULT GETDATE(),
    rec_src          VARCHAR(50) DEFAULT 'PAYMENTS_FILE'
);

CREATE TABLE STG_DEVICE (
    device_imei    VARCHAR(30),
    customer_id    VARCHAR(20),
    brand          VARCHAR(30),
    model          VARCHAR(50),
    os             VARCHAR(20),
    sim_count      TINYINT,
    load_dts       DATETIME DEFAULT GETDATE(),
    rec_src        VARCHAR(50) DEFAULT 'DEVICES_FILE'
);

CREATE TABLE STG_REJECTED_RECORDS (
    reject_id      INT IDENTITY(1,1) PRIMARY KEY,
    source_table   VARCHAR(50),
    raw_data       VARCHAR(MAX),
    reject_reason  VARCHAR(200),
    load_dts       DATETIME DEFAULT GETDATE()
);



SELECT
    t.TABLE_SCHEMA AS SchemaName,
    t.TABLE_NAME AS TableName,
    c.ORDINAL_POSITION AS ColumnOrder,
    c.COLUMN_NAME AS ColumnName,
    c.DATA_TYPE AS DataType,
    c.CHARACTER_MAXIMUM_LENGTH AS MaxLength,
    c.IS_NULLABLE AS IsNullable
FROM INFORMATION_SCHEMA.TABLES t
JOIN INFORMATION_SCHEMA.COLUMNS c
    ON t.TABLE_SCHEMA = c.TABLE_SCHEMA
   AND t.TABLE_NAME = c.TABLE_NAME
WHERE t.TABLE_TYPE = 'BASE TABLE'
ORDER BY t.TABLE_SCHEMA, t.TABLE_NAME, c.ORDINAL_POSITION;