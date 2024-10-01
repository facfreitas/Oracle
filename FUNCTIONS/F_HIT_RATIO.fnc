CREATE OR REPLACE FUNCTION CLB239950.F_HIT_RATIO RETURN NUMBER IS

-- PL/SQL SPECIFICATION
------------------------------------------------------------------------------------
-- EMPRESA:        COELBA
-- DESENVOLVEDOR:  ANDERSON MELO
-- DATA:           25/03/2004
-- OBJETIVO:       CALCULA E RETORNAR O HIT RATIO DO BANCO.
------------------------------------------------------------------------------------
-- HISTÛRICO DE ATUALIZAÁıES
-- DATA         EMPRESA     IMPLEMENTADOR      DESCRIÁ„O DA ALTERAÁ„O
--
------------------------------------------------------------------------------------

 CONS_GETS NUMBER;
 DB_BLK_GETS NUMBER;
 RESULTADO NUMBER;

BEGIN
       SELECT VALUE INTO CONS_GETS
       FROM V$SYSSTAT
       WHERE name='consistent gets';

       SELECT VALUE INTO DB_BLK_GETS
       FROM V$SYSSTAT
       WHERE name='db block gets';

       SELECT (1- VALUE / (CONS_GETS+ DB_BLK_GETS)) INTO RESULTADO
       FROM V$SYSSTAT
       WHERE NAME IN ('physical reads');


       RETURN Round(RESULTADO,4) ;

end F_HIT_RATIO;
/
