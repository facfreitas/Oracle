CREATE TABLESPACE TS_DATA_EEP_FINANCE_TCG_HML DATAFILE 
  'E:\APP\ORADATA\EEP\DF_TS_DATA_EEP_FINANCE_TCG_HML01.DBF' SIZE 50M AUTOEXTEND ON NEXT 10M MAXSIZE 300M
LOGGING
ONLINE
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;


CREATE TABLESPACE TS_INDX_EEP_FINANCE_TCG_HML DATAFILE 
  'E:\APP\ORADATA\EEP\DF_TS_INDX_EEP_FINANCE_TCG_HML01.DBF' SIZE 50M AUTOEXTEND ON NEXT 10M MAXSIZE 300M
LOGGING
ONLINE
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;



CREATE USER EEP_FINANCE_TCG_HML
  IDENTIFIED BY "homologacao_tcg_eep"
  DEFAULT TABLESPACE TS_DATA_EEP_FINANCE_TCG_HML
  TEMPORARY TABLESPACE TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK;

  GRANT CONNECT TO EEP_FINANCE_TCG_HML;
  GRANT RESOURCE TO EEP_FINANCE_TCG_HML;
  ALTER USER EEP_FINANCE_TCG_HML DEFAULT ROLE ALL;
  ALTER USER EEP_FINANCE_TCG_HML QUOTA UNLIMITED ON TS_DATA_EEP_FINANCE_TCG_HML;


-- Immporta

CREATE USER USR_EEP_FINANCE_TCG_HML
  IDENTIFIED BY "usr_eep_finance_tcg_hml@eep"
  DEFAULT TABLESPACE TS_DATA_EEP_FINANCE_TCG_HML
  TEMPORARY TABLESPACE TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK;

  GRANT CONNECT TO USR_EEP_FINANCE_TCG_HML;
  
  
  CREATE ROLE RLQUERY_EEP_FINANCE_TCG;
  
  CREATE ROLE RLMANIPULATE_EEP_FINANCE_TCG;
  
  CREATE ROLE RLEXECUTE_EEP_FINANCE_TCG;
  
  
  grant RLMANIPULATE_EEP_FINANCE_TCG to USR_EEP_FINANCE_TCG_HML;