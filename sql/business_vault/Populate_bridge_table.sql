USE telecom_business_vault;

INSERT INTO BRIDGE_CUST_PLAN_DEVICE
    (bridge_hk, customer_hk, plan_hk, device_hk, effective_date, load_dts)
SELECT
    CONVERT(CHAR(32), HASHBYTES('MD5', lcp.customer_hk + lcp.plan_hk + ldc.device_hk), 2),
    lcp.customer_hk, lcp.plan_hk, ldc.device_hk,
    CAST(GETDATE() AS DATE), GETDATE()
FROM telecom_raw_vault.dbo.LINK_CUST_PLAN lcp
JOIN telecom_raw_vault.dbo.LINK_DEVICE_CUST ldc ON lcp.customer_hk = ldc.customer_hk;

SELECT COUNT(*) AS bridge_rows FROM BRIDGE_CUST_PLAN_DEVICE;