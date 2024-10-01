-- Funcoes de grupo nao podem ser REFRESH FAST

SELECT * FROM USER_REFRESH

SELECT * FROM USER_REFRESH_CHILDREN

SELECT COUNT(*), CLAS_CONS, NIV_TENS FROM CPL_CONSUMIDOR
GROUP BY CLAS_CONS, NIV_TENS
-- Resultados
/*
2775	COM	AT
261719	COM	BT
54	    COM	
2532	IND	AT
21381	IND	BT
10	    IND	
11	    OUT	AT
1016	OUT	
200	    RES	AT
2610376	RES	BT
480	    RES	
*/

CREATE MATERIALIZED VIEW LOG ON CPL_CONSUMIDOR WITH PRIMARY KEY, ROWID

CREATE MATERIALIZED VIEW CPL_TESTE REFRESH FAST ON DEMAND AS
SELECT COUNT(*), CLAS_CONS, NIV_TENS FROM CPL_CONSUMIDOR
GROUP BY CLAS_CONS, NIV_TENS

DROP MATERIALIZED VIEW LOG ON CPL_CONSUMIDOR

DROP MATERIALIZED VIEW CPL_TESTE

select * from cpl_consumidor where clas_cons = 'COM' and niv_tens is null
and COD_CONS = 988375

update cpl_consumidor set niv_tens = 'AT' -- antes era null
where clas_cons = 'COM' and niv_tens is null
and COD_CONS = 988375

update cpl_consumidor set niv_tens = null -- antes era null
where clas_cons = 'COM' and niv_tens = 'AT'
and COD_CONS = 988375

BEGIN DBMS_MVIEW.REFRESH('CPL_TESTE','C'); END;
  --   METHOD
  --     A string that contains a letter for each
  --     of the snapshots in the array according to the following codes:
  --     '?' -- use fast refresh when possible
  --     'F' -- use fast refresh or raise an error if not possible
  --     'C' -- perform a complete refresh, copying the entire snapshot from
  --            the master
  --     The default method for refreshing a snapshot is the method stored for
  --     that snapshot in the data dictionary.

select * from cpl_teste

-- Exemplos

DROP TABLE EQUIPAMENTO_TOTAL

DROP MATERIALIZED VIEW EQUIPAMENTO_TOTAL

CREATE MATERIALIZED VIEW EQUIPAMENTO_TOTAL REFRESH FAST ON DEMAND AS (
SELECT SUBSTR(B.NUM_EQMD,1,2) GRUP_EQMD, B.TPO_CAEM, B.COD_CAEM, B.COD_ATIV, B.COD_MOTV,
       B.NSEQ_SET, B.NSEQ_FORN, B.COD_DEP_RESP, A.COD_MAT, COUNT(*) TOTAL
FROM ESPECIFICACAO_FISICA A, EQUIPAMENTO_MEDICAO B
WHERE A.TPO_CAEM = B.TPO_CAEM
AND   A.COD_CAEM = B.COD_CAEM
GROUP BY SUBSTR(B.NUM_EQMD,1,2), B.TPO_CAEM, B.COD_CAEM, B.COD_ATIV, B.COD_MOTV,
       B.NSEQ_SET, B.NSEQ_FORN, B.COD_DEP_RESP, A.COD_MAT )

DROP MATERIALIZED VIEW LOG ON EQUIPAMENTO_MEDICAO

DROP MATERIALIZED VIEW LOG ON ESPECIFICACAO_FISICA

CREATE MATERIALIZED VIEW LOG ON EQUIPAMENTO_MEDICAO WITH PRIMARY KEY, ROWID

CREATE MATERIALIZED VIEW LOG ON ESPECIFICACAO_FISICA WITH PRIMARY KEY, ROWID

-- Outros exemplos

CREATE MATERIALIZED VIEW all_emps 
   PCTFREE 5 PCTUSED 60 
   TABLESPACE users 
   STORAGE INITIAL 50K NEXT 50K 
   USING INDEX STORAGE (INITIAL 25K NEXT 25K)
   REFRESH START WITH ROUND(SYSDATE + 1) + 11/24 
   NEXT NEXT_DAY(TRUNC(SYSDATE, 'MONDAY') + 15/24 
   AS SELECT * FROM fran.emp@dallas 
         UNION
      SELECT * FROM marco.emp@balt;

