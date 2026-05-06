USE telecom_business_vault;

INSERT INTO PIT_CUSTOMER (customer_hk, snapshot_date,
                           sat_cust_details_load_dts,
                           sat_device_details_load_dts)
SELECT
    h.customer_hk,
    d.snapshot_date,
    (SELECT MAX(sc.load_dts)
     FROM telecom_raw_vault.dbo.SAT_CUST_DETAILS sc
     WHERE sc.customer_hk = h.customer_hk
       AND CAST(sc.load_dts AS DATE) <= d.snapshot_date) AS sat_cust_details_load_dts,
    (SELECT MAX(sd.load_dts)
     FROM telecom_raw_vault.dbo.SAT_DEVICE_DETAILS sd
     WHERE sd.device_hk IN (
         SELECT device_hk FROM telecom_raw_vault.dbo.LINK_DEVICE_CUST
         WHERE customer_hk = h.customer_hk)
     AND CAST(sd.load_dts AS DATE) <= d.snapshot_date) AS sat_device_details_load_dts
FROM telecom_raw_vault.dbo.HUB_CUSTOMER h
CROSS JOIN (
    SELECT CAST(DATEADD(MONTH, -n, EOMONTH(GETDATE())) AS DATE) AS snapshot_date
    FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11)) AS months(n)
) d;

SELECT COUNT(*) AS pit_rows FROM PIT_CUSTOMER;
-- Expected: ~84,516 rows (7,043 customers × 12 months)