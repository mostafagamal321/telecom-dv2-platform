USE telecom_info_mart;

-- DIM_CUSTOMER — includes Kaggle churn label and real tenure/charges
INSERT INTO DIM_CUSTOMER
    (customer_hk, customer_id, name, city, segment, gender,
     tenure_months, monthly_charges, churn_risk, kaggle_churn_label)
SELECT
    h.customer_hk, h.customer_id,
    s.name, s.city, s.segment, s.gender,
    sc.tenure_months, sc.monthly_charges,
    COALESCE(b.churn_risk_flag, 'LOW'),
    sc.kaggle_churn_label
FROM telecom_raw_vault.dbo.HUB_CUSTOMER h
JOIN telecom_raw_vault.dbo.SAT_CUST_DETAILS s ON h.customer_hk = s.customer_hk AND s.load_end_dts IS NULL
JOIN telecom_staging.dbo.STG_CUSTOMER sc ON h.customer_id = sc.customer_id
LEFT JOIN telecom_business_vault.dbo.BSAT_CHURN_SCORE b ON h.customer_hk = b.customer_hk;

-- DIM_PLAN
INSERT INTO DIM_PLAN (plan_hk, plan_code, plan_name, monthly_fee, data_limit_gb)
SELECT h.plan_hk, h.plan_code, s.plan_name, s.monthly_fee, s.data_limit_gb
FROM telecom_raw_vault.dbo.HUB_PLAN h
JOIN telecom_raw_vault.dbo.SAT_PLAN_DETAILS s ON h.plan_hk = s.plan_hk AND s.load_end_dts IS NULL;

-- DIM_TOWER
INSERT INTO DIM_TOWER (tower_hk, tower_id, region)
SELECT tower_hk, tower_id,
    CASE
        WHEN CAST(REPLACE(tower_id,'TOWER_','') AS INT) BETWEEN 1  AND 10 THEN 'Cairo'
        WHEN CAST(REPLACE(tower_id,'TOWER_','') AS INT) BETWEEN 11 AND 20 THEN 'Alexandria'
        WHEN CAST(REPLACE(tower_id,'TOWER_','') AS INT) BETWEEN 21 AND 30 THEN 'Giza'
        WHEN CAST(REPLACE(tower_id,'TOWER_','') AS INT) BETWEEN 31 AND 40 THEN 'Luxor'
        ELSE 'Aswan'
    END
FROM telecom_raw_vault.dbo.HUB_TOWER;

-- FCT_CALLS
INSERT INTO FCT_CALLS (customer_key, tower_key, date_key, duration_sec, cost, call_type, dropped_flag)
SELECT dc.customer_key, dt.tower_key,
    CONVERT(INT,CONVERT(VARCHAR,scm.call_date,112)),
    scm.duration_sec, scm.cost, scm.call_type, scm.dropped_flag
FROM telecom_raw_vault.dbo.LINK_CALL_CUST lcc
JOIN telecom_raw_vault.dbo.SAT_CALL_METRICS scm ON lcc.call_hk = scm.call_hk
JOIN DIM_CUSTOMER dc ON lcc.customer_hk = dc.customer_hk
JOIN DIM_TOWER    dt ON lcc.tower_hk    = dt.tower_hk;

-- FCT_COMPLAINTS
INSERT INTO FCT_COMPLAINTS (customer_key, tower_key, date_key, complaint_type, status, resolution_days)
SELECT dc.customer_key, dt.tower_key,
    CONVERT(INT,CONVERT(VARCHAR,scd.complaint_date,112)),
    scd.complaint_type, scd.status, scd.resolution_days
FROM telecom_raw_vault.dbo.LINK_COMPLAINT_TOWER lct
JOIN telecom_raw_vault.dbo.SAT_COMPLAINT_DETAILS scd ON lct.complaint_hk = scd.complaint_hk
JOIN DIM_CUSTOMER dc ON lct.customer_hk = dc.customer_hk
JOIN DIM_TOWER    dt ON lct.tower_hk    = dt.tower_hk;

-- FCT_PAYMENTS
INSERT INTO FCT_PAYMENTS (customer_key, plan_key, date_key, amount, payment_method, payment_status)
SELECT dc.customer_key, dp.plan_key,
    CONVERT(INT,CONVERT(VARCHAR,spd.payment_date,112)),
    spd.amount, spd.payment_method, spd.payment_status
FROM telecom_raw_vault.dbo.LINK_PAYMENT_CUST lpc
JOIN telecom_raw_vault.dbo.SAT_PAYMENT_DETAILS spd ON lpc.payment_hk = spd.payment_hk
JOIN DIM_CUSTOMER dc ON lpc.customer_hk = dc.customer_hk
JOIN DIM_PLAN     dp ON lpc.plan_hk     = dp.plan_hk;

-- Verify
SELECT 'DIM_CUSTOMER'    AS t, COUNT(*) FROM DIM_CUSTOMER
UNION ALL SELECT 'DIM_PLAN',       COUNT(*) FROM DIM_PLAN
UNION ALL SELECT 'DIM_TOWER',      COUNT(*) FROM DIM_TOWER
UNION ALL SELECT 'FCT_CALLS',      COUNT(*) FROM FCT_CALLS
UNION ALL SELECT 'FCT_COMPLAINTS', COUNT(*) FROM FCT_COMPLAINTS
UNION ALL SELECT 'FCT_PAYMENTS',   COUNT(*) FROM FCT_PAYMENTS;



