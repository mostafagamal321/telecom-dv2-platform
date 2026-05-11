USE telecom_info_mart;
GO

-- 1. Churn risk by customer segment
SELECT
    segment,
    churn_risk,
    COUNT(*) AS customer_count,
    CAST(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY segment) AS DECIMAL(5,2)) AS pct_within_segment
FROM dbo.DIM_CUSTOMER
GROUP BY segment, churn_risk
ORDER BY segment, customer_count DESC;

-- 2. Dropped-call rate by region
SELECT
    t.region,
    COUNT(*) AS total_events,
    SUM(CASE WHEN c.dropped_flag = 1 THEN 1 ELSE 0 END) AS dropped_events,
    CAST(100.0 * SUM(CASE WHEN c.dropped_flag = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS DECIMAL(5,2)) AS dropped_call_rate_pct
FROM dbo.FCT_CALLS c
JOIN dbo.DIM_TOWER t ON c.tower_key = t.tower_key
GROUP BY t.region
ORDER BY dropped_call_rate_pct DESC;

-- 3. Failed payments by plan
SELECT
    p.plan_name,
    COUNT(*) AS payment_count,
    SUM(CASE WHEN f.payment_status = 'Failed' THEN 1 ELSE 0 END) AS failed_payment_count,
    CAST(100.0 * SUM(CASE WHEN f.payment_status = 'Failed' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS DECIMAL(5,2)) AS failed_payment_rate_pct
FROM dbo.FCT_PAYMENTS f
JOIN dbo.DIM_PLAN p ON f.plan_key = p.plan_key
GROUP BY p.plan_name
ORDER BY failed_payment_rate_pct DESC;

-- 4. Complaint resolution performance by complaint type
SELECT
    complaint_type,
    COUNT(*) AS complaint_count,
    CAST(AVG(CAST(resolution_days AS FLOAT)) AS DECIMAL(6,2)) AS avg_resolution_days
FROM dbo.FCT_COMPLAINTS
GROUP BY complaint_type
ORDER BY avg_resolution_days DESC;

-- 5. Compare engineered churn risk with Kaggle churn label
SELECT
    churn_risk,
    kaggle_churn_label,
    COUNT(*) AS customer_count
FROM dbo.DIM_CUSTOMER
GROUP BY churn_risk, kaggle_churn_label
ORDER BY churn_risk, kaggle_churn_label;
