USE telecom_info_mart;

CREATE TABLE DIM_DATE (
    date_key INT PRIMARY KEY, full_date DATE, year INT, quarter INT,
    month INT, month_name VARCHAR(10), week INT, day_of_week VARCHAR(10)
);

DECLARE @d DATE = '2023-01-01';
WHILE @d <= '2027-12-31'
BEGIN
    INSERT INTO DIM_DATE VALUES (
        CONVERT(INT,CONVERT(VARCHAR,@d,112)), @d,
        YEAR(@d), DATEPART(QUARTER,@d), MONTH(@d),
        DATENAME(MONTH,@d), DATEPART(WEEK,@d), DATENAME(WEEKDAY,@d)
    );
    SET @d = DATEADD(DAY,1,@d);
END;

CREATE TABLE DIM_CUSTOMER (
    customer_key        INT IDENTITY(1,1) PRIMARY KEY,
    customer_hk         CHAR(32),
    customer_id         VARCHAR(20),
    name                VARCHAR(100),
    city                VARCHAR(50),
    segment             VARCHAR(20),
    gender              CHAR(1),
    tenure_months       INT,
    monthly_charges     DECIMAL(10,2),
    churn_risk          VARCHAR(10),
    kaggle_churn_label  VARCHAR(5)   -- YES / NO — real ground truth
);

CREATE TABLE DIM_PLAN (
    plan_key INT IDENTITY(1,1) PRIMARY KEY, plan_hk CHAR(32),
    plan_code VARCHAR(20), plan_name VARCHAR(50),
    monthly_fee DECIMAL(10,2), data_limit_gb INT
);

CREATE TABLE DIM_TOWER (
    tower_key INT IDENTITY(1,1) PRIMARY KEY,
    tower_hk CHAR(32), tower_id VARCHAR(20), region VARCHAR(50)
);

CREATE TABLE FCT_CALLS (
    call_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_key INT, tower_key INT, date_key INT,
    duration_sec INT, cost DECIMAL(10,2), call_type VARCHAR(10), dropped_flag TINYINT
);

CREATE TABLE FCT_COMPLAINTS (
    complaint_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_key INT, tower_key INT, date_key INT,
    complaint_type VARCHAR(50), status VARCHAR(20), resolution_days INT
);

CREATE TABLE FCT_PAYMENTS (
    payment_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_key INT, plan_key INT, date_key INT,
    amount DECIMAL(10,2), payment_method VARCHAR(30), payment_status VARCHAR(20)
);