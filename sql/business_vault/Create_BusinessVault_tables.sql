USE telecom_business_vault;

-- Point-in-Time table
CREATE TABLE PIT_CUSTOMER (
    customer_hk                  CHAR(32)   NOT NULL,
    snapshot_date                DATE       NOT NULL,
    sat_cust_details_load_dts    DATETIME,
    sat_device_details_load_dts  DATETIME,
    PRIMARY KEY (customer_hk, snapshot_date)
);

-- Bridge table
CREATE TABLE BRIDGE_CUST_PLAN_DEVICE (
    bridge_hk      CHAR(32)   NOT NULL PRIMARY KEY,
    customer_hk    CHAR(32)   NOT NULL,
    plan_hk        CHAR(32)   NOT NULL,
    device_hk      CHAR(32)   NOT NULL,
    effective_date DATE       NOT NULL,
    load_dts       DATETIME   NOT NULL
);

-- Business Satellite — derived churn scoring
CREATE TABLE BSAT_CHURN_SCORE (
    customer_hk                      CHAR(32)      NOT NULL,
    load_dts                         DATETIME      NOT NULL,
    rec_src                          VARCHAR(50)   NOT NULL DEFAULT 'DERIVED',
    call_drop_rate                   DECIMAL(5,2),
    avg_complaint_resolution_days    DECIMAL(5,1),
    payment_failure_count            INT,
    churn_risk_flag                  VARCHAR(10),  -- HIGH / MEDIUM / LOW
    PRIMARY KEY (customer_hk, load_dts)
);