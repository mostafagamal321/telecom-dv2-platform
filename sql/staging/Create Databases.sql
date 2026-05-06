CREATE DATABASE telecom_staging;
CREATE DATABASE telecom_raw_vault;
CREATE DATABASE telecom_business_vault;
CREATE DATABASE telecom_info_mart;



CREATE LOGIN test  WITH PASSWORD = '123';

CREATE USER test FOR LOGIN test;
ALTER ROLE db_datareader ADD MEMBER test;
ALTER ROLE db_datawriter ADD MEMBER test;
ALTER SERVER ROLE sysadmin ADD MEMBER test;

SELECT @@SERVICENAME;


SELECT @@SERVERNAME;



