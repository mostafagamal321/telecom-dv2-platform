USE telecom_business_vault;
GO

;WITH call_stats AS (
    SELECT 
        lcc.customer_hk,
        CAST(
            100.0 * SUM(CAST(scm.dropped_flag AS FLOAT))
            / NULLIF(COUNT(*), 0) 
            AS DECIMAL(5,2)
        ) AS call_drop_rate
    FROM telecom_raw_vault.dbo.LINK_CALL_CUST lcc
    JOIN telecom_raw_vault.dbo.SAT_CALL_METRICS scm 
        ON lcc.call_hk = scm.call_hk
    GROUP BY lcc.customer_hk
),
complaint_stats AS (
    SELECT 
        lct.customer_hk,
        CAST(
            AVG(CAST(scd.resolution_days AS FLOAT)) 
            AS DECIMAL(5,1)
        ) AS avg_complaint_resolution_days
    FROM telecom_raw_vault.dbo.LINK_COMPLAINT_TOWER lct
    JOIN telecom_raw_vault.dbo.SAT_COMPLAINT_DETAILS scd 
        ON lct.complaint_hk = scd.complaint_hk
    GROUP BY lct.customer_hk
),
payment_stats AS (
    SELECT 
        lpc.customer_hk,
        SUM(
            CASE 
                WHEN spd.payment_status = 'Failed' THEN 1 
                ELSE 0 
            END
        ) AS payment_failure_count
    FROM telecom_raw_vault.dbo.LINK_PAYMENT_CUST lpc
    JOIN telecom_raw_vault.dbo.SAT_PAYMENT_DETAILS spd 
        ON lpc.payment_hk = spd.payment_hk
    GROUP BY lpc.customer_hk
)
INSERT INTO dbo.BSAT_CHURN_SCORE
(
    customer_hk, 
    load_dts, 
    call_drop_rate,
    avg_complaint_resolution_days, 
    payment_failure_count, 
    churn_risk_flag
)
SELECT
    h.customer_hk,
    GETDATE() AS load_dts,
    COALESCE(cs.call_drop_rate, 0) AS call_drop_rate,
    COALESCE(comp.avg_complaint_resolution_days, 0) AS avg_complaint_resolution_days,
    COALESCE(ps.payment_failure_count, 0) AS payment_failure_count,
    CASE
        WHEN COALESCE(cs.call_drop_rate, 0) > 25
          OR COALESCE(ps.payment_failure_count, 0) >= 3 
            THEN 'HIGH'
        WHEN COALESCE(cs.call_drop_rate, 0) > 10
          OR COALESCE(comp.avg_complaint_resolution_days, 0) > 15 
            THEN 'MEDIUM'
        ELSE 'LOW'
    END AS churn_risk_flag
FROM telecom_raw_vault.dbo.HUB_CUSTOMER h
LEFT JOIN call_stats cs      
    ON h.customer_hk = cs.customer_hk
LEFT JOIN complaint_stats comp 
    ON h.customer_hk = comp.customer_hk
LEFT JOIN payment_stats ps   
    ON h.customer_hk = ps.customer_hk;


SELECT 
    churn_risk_flag, 
    COUNT(*) AS cnt 
FROM dbo.BSAT_CHURN_SCORE 
GROUP BY churn_risk_flag;