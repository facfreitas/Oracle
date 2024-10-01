
CREATE TABLE DBAUDITESTE.SATAUDITORIA
(
  SQSASATAUDITORIA  NUMBER(18)                  NOT NULL,
  CDSISTEMA         NUMBER(10),
  CDFORM            NUMBER(10),
  CDFUNCAO          NUMBER(10),
  DSLOGIN           VARCHAR2(50 BYTE),
  DTLOGAUDIT        DATE                        NOT NULL,
  IDOPERACAO        CHAR(1 BYTE)                NOT NULL,
  DBLOGIN           VARCHAR2(30 BYTE),
  OSLOGIN           VARCHAR2(30 BYTE),
  DSPROGRAMA        VARCHAR2(64 BYTE),
  DSMAQUINA         VARCHAR2(64 BYTE),
  IDTABELAAUDITADA  NUMBER(5)
)
TABLESPACE ts1mdl_aud_dwh
PCTUSED    80
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
           )
LOGGING
PARTITION BY RANGE (DTLOGAUDIT) 
(  
  PARTITION P2000 VALUES LESS THAN (TO_DATE('31-12-2000', 'DD-MM-YYYY'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_P2000
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION P2001 VALUES LESS THAN (TO_DATE('31-12-2001', 'DD-MM-YYYY'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_P2001
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),   
  PARTITION P2002 VALUES LESS THAN (TO_DATE('31-12-2002', 'DD-MM-YYYY'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_P2002
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),   
  PARTITION P2003 VALUES LESS THAN (TO_DATE('31-12-2003', 'DD-MM-YYYY'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_P2003
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION P2004 VALUES LESS THAN (TO_DATE('31-12-2004', 'DD-MM-YYYY'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_P2004
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION P2005 VALUES LESS THAN (TO_DATE('31-12-2005', 'DD-MM-YYYY'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_P2005
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),   
  PARTITION P2006 VALUES LESS THAN (TO_DATE('31-12-2006', 'DD-MM-YYYY'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_P2006
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION P2007 VALUES LESS THAN (TO_DATE('31-12-2007', 'DD-MM-YYYY'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_P2007
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),   
  PARTITION P2008 VALUES LESS THAN (TO_DATE('31-12-2008', 'DD-MM-YYYY'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_P2008
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),   
  PARTITION P2009 VALUES LESS THAN (TO_DATE('31-12-2009', 'DD-MM-YYYY'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_P2009
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               )
)
CACHE
NOPARALLEL;

CREATE UNIQUE INDEX DBAUDITESTE.PKSAAUDITORIA ON SATAUDITORIA
(SQSASATAUDITORIA)
  TABLESPACE ts1mil_aud_dwh
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              INITIAL          1M
              NEXT             1M
              MINEXTENTS       1
              MAXEXTENTS       2147483645
              PCTINCREASE      0
             )
LOCAL (  
  PARTITION P2000
    LOGGING
    TABLESPACE ts1mil_aud_dwh_P2000
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION P2001
    LOGGING
    TABLESPACE ts1mil_aud_dwh_P2001
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION P2002
    LOGGING
    TABLESPACE ts1mil_aud_dwh_P2002
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),   
  PARTITION P2003
    LOGGING
    TABLESPACE ts1mil_aud_dwh_P2003
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION P2004
    LOGGING
    TABLESPACE ts1mil_aud_dwh_P2004
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),   
  PARTITION P2005
    LOGGING
    TABLESPACE ts1mil_aud_dwh_P2005
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),   
  PARTITION P2006
    LOGGING
    TABLESPACE ts1mil_aud_dwh_P2006
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION P2007
    LOGGING
    TABLESPACE ts1mil_aud_dwh_P2007
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION P2008
    LOGGING
    TABLESPACE ts1mil_aud_dwh_P2008
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION P2009
    LOGGING
    TABLESPACE ts1mil_aud_dwh_P2009
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               )
)
NOPARALLEL;

COMMENT ON TABLE DBAUDITESTE.SAAUDITORIA IS 'Tabela que armazena informações das auditorias do sistema SAT-AUDITOR.';

COMMENT ON COLUMN DBAUDITESTE.SAAUDITORIA.IDTABELAAUDITADA IS 'Código que identifica a tabela que está sendo auditada. Será NULL pois a tabela já estava com registros quando este atributo foi adicionado.';

COMMENT ON COLUMN DBAUDITESTE.SAAUDITORIA.SQSASATAUDITORIA IS 'Sequencial que identifica unicamente a auditoria que está sendo registrada.';

COMMENT ON COLUMN DBAUDITESTE.SAAUDITORIA.CDSISTEMA IS 'Código do Sistema onde ocorreu a alteração auditada.';

COMMENT ON COLUMN DBAUDITESTE.SAAUDITORIA.DSLOGIN IS 'Login do Usuário que estava logado no Sistema que executou a alteração que está sendo auditada.';

COMMENT ON COLUMN DBAUDITESTE.SAAUDITORIA.DTLOGAUDIT IS 'Data e Hora do registro desta auditoria.';

COMMENT ON COLUMN DBAUDITESTE.SAAUDITORIA.IDOPERACAO IS 'Identificador da Operação que foi executada.';

COMMENT ON COLUMN DBAUDITESTE.SAAUDITORIA.DBLOGIN IS 'Login do Usuário do Banco de Dados utilizado na conexão que fará a alteração que está sendo auditada.';

COMMENT ON COLUMN DBAUDITESTE.SAAUDITORIA.OSLOGIN IS 'Login do Usuário de Rede logado no Sistema no momento da alteração que está sendo auditada.';

COMMENT ON COLUMN DBAUDITESTE.SAAUDITORIA.DSPROGRAMA IS 'Nome do Programa (Processo) que está sendo utilizado pelo Usuário para executar a alteração que está sendo auditada.';

COMMENT ON COLUMN DBAUDITESTE.SAAUDITORIA.DSMAQUINA IS 'Nome de Rede da Máquina de onde o usuário está executando a alteração auditada.';


