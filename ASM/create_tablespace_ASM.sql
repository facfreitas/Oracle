CREATE TABLESPACE AUXILIAR DATAFILE 
  '+SAT_ASM_GP1' SIZE 120M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE CDC_DBADMS_DADOS01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 100M AUTOEXTEND ON NEXT 50M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE CDC_DBASAT_DADOS01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 400M AUTOEXTEND ON NEXT 50M MAXSIZE 2048M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE CDC_DBASJCMC_DADOS01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 50M AUTOEXTEND ON NEXT 20M MAXSIZE 1024M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE CDC_DBASS_DADOS01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 50M AUTOEXTEND ON NEXT 20M MAXSIZE 1024M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE DBABDT_DADOS_01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 50M AUTOEXTEND ON NEXT 5M MAXSIZE 2048M
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE DBAGEO_DADOS_01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 2415M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 2400M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 1479M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE DBAGEO_INDEX_01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 115M AUTOEXTEND ON NEXT 100M MAXSIZE 3072M,
  '+SAT_ASM_GP1' SIZE 100M AUTOEXTEND ON NEXT 100M MAXSIZE 3072M
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE DBASJCMC_MV_DADOS_01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 600M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE DBASJCMC_MV_INDEX_01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 150M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE DBASS_DADOS_01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 2560M AUTOEXTEND ON NEXT 100M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE DBASS_DADOS_02 DATAFILE 
  '+SAT_ASM_GP1' SIZE 100M AUTOEXTEND ON NEXT 100M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE DBASS_INDEX_01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 1200M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE DBASS_INDEX_02 DATAFILE 
  '+SAT_ASM_GP1' SIZE 700M AUTOEXTEND ON NEXT 50M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE DMS_DADOS DATAFILE 
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 800M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE DMS_INDEX DATAFILE 
  '+SAT_ASM_GP1' SIZE 1229M AUTOEXTEND ON NEXT 100M MAXSIZE 3072M
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXBDT DATAFILE 
  '+SAT_ASM_GP1' SIZE 50M AUTOEXTEND ON NEXT 5M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXCHAT DATAFILE 
  '+SAT_ASM_GP1' SIZE 50M AUTOEXTEND ON NEXT 5M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXCS01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 1024M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE INDXMIG01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 1256M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXRH DATAFILE 
  '+SAT_ASM_GP1' SIZE 250M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXSATAUDITORIA DATAFILE 
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 256M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXSATINFRA DATAFILE 
  '+SAT_ASM_GP1' SIZE 200M AUTOEXTEND ON NEXT 5M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;


CREATE TABLESPACE INDXSAT01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 3122M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 1843M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXSAT02 DATAFILE 
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXSAT03 DATAFILE 
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 512M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXSAT04 DATAFILE 
   '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXSAT05 DATAFILE 
   '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXSAT06 DATAFILE 
  '+SAT_ASM_GP1' SIZE 200M AUTOEXTEND ON NEXT 5M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXSA01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 500M AUTOEXTEND ON NEXT 100M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXSJCMC01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 150M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXSMV01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 50M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE INDXTMP01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 712M AUTOEXTEND ON NEXT 50M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJBDT DATAFILE 
  '+SAT_ASM_GP1' SIZE 50M AUTOEXTEND ON NEXT 5M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJCHAT DATAFILE 
  '+SAT_ASM_GP1' SIZE 75M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJCS01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 1256M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE PRJMIGSJCMC01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 80M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJMIG01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 2048M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJRH DATAFILE 
  '+SAT_ASM_GP1' SIZE 100M AUTOEXTEND ON NEXT 5M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJSATINFRA DATAFILE 
  '+SAT_ASM_GP1' SIZE 90M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJSAT01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 2560M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJSAT02 DATAFILE 
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3379M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 1024M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJSAT03 DATAFILE 
  '+SAT_ASM_GP1' SIZE 1024M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJSAT04 DATAFILE 
  '+SAT_ASM_GP1' SIZE 560M AUTOEXTEND ON NEXT 100M MAXSIZE 1024M,
  '+SAT_ASM_GP1' SIZE 2500M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJSAT05 DATAFILE 
  '+SAT_ASM_GP1' SIZE 2450M AUTOEXTEND ON NEXT 150M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJSAT06 DATAFILE 
  '+SAT_ASM_GP1' SIZE 830M AUTOEXTEND ON NEXT 50M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJSA01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 2048M AUTOEXTEND ON NEXT 100M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJSJCMC01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 350M AUTOEXTEND ON NEXT 150M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJSMV01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 50M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE PRJTMP01 DATAFILE 
  '+SAT_ASM_GP1' SIZE 1900M AUTOEXTEND ON NEXT 100M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SATAUDITORIA DATAFILE 
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF,
  '+SAT_ASM_GP1' SIZE 3072M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SAT_CONTACONTRIBUINTENEWDATA DATAFILE 
  '+SAT_ASM_GP1' SIZE 100M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SAT_CONTACONTRIBUINTENEWIDX DATAFILE 
  '+SAT_ASM_GP1' SIZE 200M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SAT_FINANCLOGERRODATA DATAFILE 
  '+SAT_ASM_GP1' SIZE 5M AUTOEXTEND ON NEXT 5M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SAT_FINANCLOGERROIDX DATAFILE 
  '+SAT_ASM_GP1' SIZE 5M AUTOEXTEND ON NEXT 5M MAXSIZE 3072M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SAT_LANCAMENTOCONTANEWDATA DATAFILE 
  '+SAT_ASM_GP1' SIZE 100M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SAT_LANCAMENTOCONTANEWIDX DATAFILE 
  '+SAT_ASM_GP1' SIZE 70M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SAT_PARCELANEWDATA DATAFILE 
  '+SAT_ASM_GP1' SIZE 50M AUTOEXTEND ON NEXT 10M MAXSIZE 250M
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SAT_PARCELANEWIDX DATAFILE 
  '+SAT_ASM_GP1' SIZE 256M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SAT_RESULCALCIMUISNTDATA DATAFILE 
  '+SAT_ASM_GP1' SIZE 50M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SAT_RESULCALCIMUISNTIDX DATAFILE 
  '+SAT_ASM_GP1' SIZE 50M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SAT_RESULTADOCALCULONEWDATA DATAFILE 
  '+SAT_ASM_GP1' SIZE 250M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;

CREATE TABLESPACE SAT_RESULTADOCALCULONEWIDX DATAFILE 
  '+SAT_ASM_GP1' SIZE 550M AUTOEXTEND OFF
NOLOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL;


