DROP MATERIALIZED VIEW DBASJCMC.MVPROCESSOSJCMC;
CREATE MATERIALIZED VIEW DBASJCMC.MVPROCESSOSJCMC 
TABLESPACE DBASJCMC_MV_DADOS_01
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          56M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOPARALLEL
BUILD IMMEDIATE
REFRESH COMPLETE
START WITH TO_DATE('02-jul-2008 22:00:00','dd-mon-yyyy hh24:mi:ss')
NEXT TRUNC(SYSDATE)+1+22/24  
WITH PRIMARY KEY
ENABLE QUERY REWRITE
AS 
/* Formatted on 2008/10/15 14:50 (Formatter Plus v4.8.8) */
SELECT "PROCESSO"."SQPROCESSO" "SQPROCESSO",
       "PROCESSO"."AAPROCESSO" "AAPROCESSO",
       "PROCESSO"."DSNUMEROANTIGO" "DSNUMEROANTIGO",
       "PROCESSO"."DSOBSERVACAO" "DSOBSERVACAO",
       "PROCESSO"."DSDOCUMENTO" "DSDOCUMENTO",
       "PROCESSO"."DTABERTURAPROCESSO" "DTABERTURAPROCESSO",
       "PROCESSO"."STTIPOPROCESSO" "STTIPOPROCESSO",
       "PROCESSO"."DTJUNCAO" "DTJUNCAO",
       "PROCESSO"."DTDISJUNCAO" "DTDISJUNCAO",
       "PROCESSO"."SQREQUERENTE" "SQREQUERENTE",
       "PROCESSO"."SQSITUACAO" "SQSITUACAO",
       "PROCESSO"."SQPROCESSOPAI" "SQPROCESSOPAI",
       "PROCESSO"."AAPROCESSOPAI" "AAPROCESSOPAI",
       "PROCESSO"."CDUNIDADE" "CDUNIDADE",
       "PROCESSO"."NUORIGINAL" "NUORIGINAL",
       "PROCESSO"."SQTIPODOCUMENTO" "SQTIPODOCUMENTO",
       "PROCESSO"."SQSUBASSUNTO" "SQSUBASSUNTO",
       "PROCESSO"."SQUSUARIOSETORCADASTRO" "SQUSUARIOSETORCADASTRO",
       "PROCESSO"."SQUSUARIOSETORRESPONSAVEL" "SQUSUARIOSETORRESPONSAVEL",
       "PROCESSO"."SQSETORLOCALIZACAO" "SQSETORLOCALIZACAO",
       "PROCESSO"."CDUNIDADELOCALIZACAO" "CDUNIDADELOCALIZACAO",
       "PROCESSO"."AAUNIDADE" "AAUNIDADE",
       "PROCESSO"."AAUNIDADELOCALIZACAO" "AAUNIDADELOCALIZACAO",
       "PROCESSO"."FLEMTRAMITE" "FLEMTRAMITE",
       "PROCESSO"."NRDOCUMENTO" "NRDOCUMENTO", "PROCESSO"."DSLOTE" "DSLOTE",
       "PROCESSO"."SQSETOREXTERNO" "SQSETOREXTERNO"
  FROM "PROCESSO"@lksipsjcmc "PROCESSO";

COMMENT ON TABLE DBASJCMC.MVPROCESSOSJCMC IS 'snapshot table for snapshot DBASJCMC.MVPROCESSOSJCMC';

GRANT SELECT ON DBASJCMC.MVPROCESSOSJCMC TO RLAD;

GRANT SELECT ON DBASJCMC.MVPROCESSOSJCMC TO RLARRECADACAO;

GRANT SELECT ON DBASJCMC.MVPROCESSOSJCMC TO RLSATDESENVOLVEDOR;

GRANT SELECT ON DBASJCMC.MVPROCESSOSJCMC TO RLSJCMCDESENVOLVEDOR;



