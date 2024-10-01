/* ALTERAR SOMENTE OWNER E OBJETO E A OPÇÃO DE REFRESH. */
DROP MATERIALIZED VIEW OWNER.OBJETO;
CREATE MATERIALIZED VIEW OWNER.OBJETO 
TABLESPACE [CAMPO_NOSSO]
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
NOLOGGING
NOPARALLEL
BUILD IMMEDIATE
USING INDEX
            TABLESPACE [CAMPO_NOSSO]
            PCTFREE    10
            INITRANS   2
            MAXTRANS   255
            STORAGE    (
                        INITIAL          1M
                        NEXT             1M
                        MINEXTENTS       1
                        MAXEXTENTS       UNLIMITED
                        PCTINCREASE      0
                        BUFFER_POOL      DEFAULT
                       )
REFRESH FAST
START WITH TO_DATE('28-out-2009 01:00:00','dd-mon-yyyy hh24:mi:ss')
NEXT TRUNC(SYSDATE)+1+1/24   
WITH PRIMARY KEY
ENABLE QUERY REWRITE
AS 
/* Formatted on 2008/10/15 14:50 (Formatter Plus v4.8.8) */
SELECT [INDICAR_COLUNAS]
  FROM "[OBJETO]"@[INDICAR_DBLINK];
