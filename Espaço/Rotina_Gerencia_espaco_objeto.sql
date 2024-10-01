-- Criação de rotina para gerenciamento de espaço

DROP USER EEP_TECNOLOGIA

CREATE USER EEP_TECNOLOGIA
  IDENTIFIED BY EEP_TECNOLOGIA123456  
  DEFAULT TABLESPACE TS_EEP_TECNOLOGIA
  TEMPORARY TABLESPACE TEMP;
  
  GRANT CONNECT, RESOURCE TO EEP_TECNOLOGIA;
  
  GRANT SELECT ON DBA_SEGMENTS TO EEP_CM;

_______________________

CREATE TABLESPACE TS_EEP_TECNOLOGIA DATAFILE 
  'C:\APP\ORADATA\EEPDBA\DATA\TS_EEP_TECNOLOGIA01.DBF' SIZE 5M AUTOEXTEND ON NEXT 1280K MAXSIZE UNLIMITED
LOGGING
ONLINE
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

_______________________

CREATE TABLE EEP_CM.T_TAM_OBJ
(
  DT_REGISTRO       DATE,
  NM_OWNER          VARCHAR2(50),
  NM_OBJ            VARCHAR2(50),
  TP_OBJ            VARCHAR2(50),
  TAMANHO           NUMBER(20)
)
TABLESPACE APEX_2087306661483442

_______________________

-- Procedure

CREATE OR REPLACE PROCEDURE EEP_CM.p_tamanho_objeto
IS
-----------------------------------------------------------------------------------------------------------------
-- Desenvolvedor:  Fernando Freitas
-- Data:           28/21/2012
-- Objetivo:       Acompanhar crescimento da instância
-----------------------------------------------------------------------------------------------------------------

   CURSOR c_segment
   IS
      SELECT   TO_DATE (SYSDATE, 'DD/MM/RR') DT_REGISTRO, owner NM_OWNER, SEGMENT_NAME NM_OBJ, segment_type TP_OBJ,
               SUM (BYTES) / 1024 / 1024 TAMANHO
          FROM dba_segments
         WHERE owner not in ('SYS','SYSTEM','CTXSYS','MDSYS','EXFSYS','WMSYS','XDB')
      GROUP BY owner, SEGMENT_NAME, segment_type;
BEGIN

   FOR v_segment_data IN c_segment
   LOOP
      IF c_segment%ROWCOUNT = 0
      THEN
         EXIT;
      END IF;

      INSERT INTO T_TAM_OBJ
           VALUES (v_segment_data.DT_REGISTRO, v_segment_data.NM_OWNER, v_segment_data.NM_OBJ, v_segment_data.TP_OBJ,
                   v_segment_data.TAMANHO);

      COMMIT;
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN OTHERS
   THEN
      RAISE;
END p_tamanho_objeto;
/

_______________________

-- Cria JOB

BEGIN 
  EEP_CM.P_TAMANHO_OBJETO;
  COMMIT; 
END; 


