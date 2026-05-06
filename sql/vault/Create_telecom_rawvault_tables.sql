USE telecom_raw_vault;

-- =============================================
--  H U B S
-- =============================================

CREATE TABLE HUB_CUSTOMER (
    customer_hk   CHAR(32)      NOT NULL PRIMARY KEY,
    customer_id   VARCHAR(20)   NOT NULL,
    load_dts      DATETIME      NOT NULL,
    rec_src       VARCHAR(50)   NOT NULL
);

CREATE TABLE HUB_PLAN (
    plan_hk    CHAR(32)     NOT NULL PRIMARY KEY,
    plan_code  VARCHAR(20)  NOT NULL,
    load_dts   DATETIME     NOT NULL,
    rec_src    VARCHAR(50)  NOT NULL
);

CREATE TABLE HUB_CALL (
    call_hk    CHAR(32)     NOT NULL PRIMARY KEY,
    call_id    VARCHAR(20)  NOT NULL,
    load_dts   DATETIME     NOT NULL,
    rec_src    VARCHAR(50)  NOT NULL
);

CREATE TABLE HUB_TOWER (
    tower_hk   CHAR(32)     NOT NULL PRIMARY KEY,
    tower_id   VARCHAR(20)  NOT NULL,
    load_dts   DATETIME     NOT NULL,
    rec_src    VARCHAR(50)  NOT NULL
);

CREATE TABLE HUB_COMPLAINT (
    complaint_hk   CHAR(32)     NOT NULL PRIMARY KEY,
    complaint_id   VARCHAR(20)  NOT NULL,
    load_dts       DATETIME     NOT NULL,
    rec_src        VARCHAR(50)  NOT NULL
);

CREATE TABLE HUB_PAYMENT (
    payment_hk   CHAR(32)     NOT NULL PRIMARY KEY,
    payment_id   VARCHAR(20)  NOT NULL,
    load_dts     DATETIME     NOT NULL,
    rec_src      VARCHAR(50)  NOT NULL
);

CREATE TABLE HUB_DEVICE (
    device_hk    CHAR(32)     NOT NULL PRIMARY KEY,
    device_imei  VARCHAR(30)  NOT NULL,
    load_dts     DATETIME     NOT NULL,
    rec_src      VARCHAR(50)  NOT NULL
);

-- =============================================
--  L I N K S
-- =============================================

CREATE TABLE LINK_CUST_PLAN (
    link_cust_plan_hk   CHAR(32)   NOT NULL PRIMARY KEY,
    customer_hk         CHAR(32)   NOT NULL,
    plan_hk             CHAR(32)   NOT NULL,
    load_dts            DATETIME   NOT NULL,
    rec_src             VARCHAR(50) NOT NULL
);

CREATE TABLE LINK_CALL_CUST (
    link_call_cust_hk   CHAR(32)   NOT NULL PRIMARY KEY,
    call_hk             CHAR(32)   NOT NULL,
    customer_hk         CHAR(32)   NOT NULL,
    tower_hk            CHAR(32)   NOT NULL,
    load_dts            DATETIME   NOT NULL,
    rec_src             VARCHAR(50) NOT NULL
);

CREATE TABLE LINK_COMPLAINT_TOWER (
    link_comp_tower_hk   CHAR(32)   NOT NULL PRIMARY KEY,
    complaint_hk         CHAR(32)   NOT NULL,
    tower_hk             CHAR(32)   NOT NULL,
    customer_hk          CHAR(32)   NOT NULL,
    load_dts             DATETIME   NOT NULL,
    rec_src              VARCHAR(50) NOT NULL
);

CREATE TABLE LINK_PAYMENT_CUST (
    link_pay_cust_hk   CHAR(32)   NOT NULL PRIMARY KEY,
    payment_hk         CHAR(32)   NOT NULL,
    customer_hk        CHAR(32)   NOT NULL,
    plan_hk            CHAR(32)   NOT NULL,
    load_dts           DATETIME   NOT NULL,
    rec_src            VARCHAR(50) NOT NULL
);

CREATE TABLE LINK_DEVICE_CUST (
    link_dev_cust_hk   CHAR(32)   NOT NULL PRIMARY KEY,
    device_hk          CHAR(32)   NOT NULL,
    customer_hk        CHAR(32)   NOT NULL,
    load_dts           DATETIME   NOT NULL,
    rec_src            VARCHAR(50) NOT NULL
);

-- =============================================
--  S A T E L L I T E S
-- =============================================

CREATE TABLE SAT_CUST_DETAILS (
    customer_hk              CHAR(32)      NOT NULL,
    load_dts                 DATETIME      NOT NULL,
    load_end_dts             DATETIME,
    rec_src                  VARCHAR(50)   NOT NULL,
    sat_cust_details_hashdiff CHAR(32)     NOT NULL,
    name                     VARCHAR(100),
    dob                      DATE,
    city                     VARCHAR(50),
    segment                  VARCHAR(20),
    gender                   CHAR(1),
    phone                    VARCHAR(15),
    PRIMARY KEY (customer_hk, load_dts)
);

CREATE TABLE SAT_PLAN_DETAILS (
    plan_hk                   CHAR(32)     NOT NULL,
    load_dts                  DATETIME     NOT NULL,
    load_end_dts              DATETIME,
    rec_src                   VARCHAR(50)  NOT NULL,
    sat_plan_details_hashdiff CHAR(32)     NOT NULL,
    plan_name                 VARCHAR(50),
    monthly_fee               DECIMAL(10,2),
    data_limit_gb             INT,
    validity_days             INT,
    PRIMARY KEY (plan_hk, load_dts)
);

CREATE TABLE SAT_CALL_METRICS (
    call_hk                    CHAR(32)    NOT NULL,
    load_dts                   DATETIME    NOT NULL,
    rec_src                    VARCHAR(50) NOT NULL,
    sat_call_metrics_hashdiff  CHAR(32)    NOT NULL,
    duration_sec               INT,
    call_type                  VARCHAR(10),
    cost                       DECIMAL(10,2),
    dropped_flag               TINYINT,
    call_date                  DATE,
    PRIMARY KEY (call_hk, load_dts)
);

CREATE TABLE SAT_COMPLAINT_DETAILS (
    complaint_hk                    CHAR(32)    NOT NULL,
    load_dts                        DATETIME    NOT NULL,
    load_end_dts                    DATETIME,
    rec_src                         VARCHAR(50) NOT NULL,
    sat_complaint_details_hashdiff  CHAR(32)    NOT NULL,
    complaint_type                  VARCHAR(50),
    status                          VARCHAR(20),
    resolution_days                 INT,
    complaint_date                  DATE,
    PRIMARY KEY (complaint_hk, load_dts)
);

CREATE TABLE SAT_PAYMENT_DETAILS (
    payment_hk                    CHAR(32)     NOT NULL,
    load_dts                      DATETIME     NOT NULL,
    rec_src                       VARCHAR(50)  NOT NULL,
    sat_payment_details_hashdiff  CHAR(32)     NOT NULL,
    amount                        DECIMAL(10,2),
    payment_method                VARCHAR(30),
    payment_status                VARCHAR(20),
    payment_date                  DATE,
    PRIMARY KEY (payment_hk, load_dts)
);

CREATE TABLE SAT_DEVICE_DETAILS (
    device_hk                    CHAR(32)     NOT NULL,
    load_dts                     DATETIME     NOT NULL,
    load_end_dts                 DATETIME,
    rec_src                      VARCHAR(50)  NOT NULL,
    sat_device_details_hashdiff  CHAR(32)     NOT NULL,
    brand                        VARCHAR(30),
    model                        VARCHAR(50),
    os                           VARCHAR(20),
    sim_count                    TINYINT,
    PRIMARY KEY (device_hk, load_dts)
);