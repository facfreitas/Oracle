-- "Set scan off" turns off substitution variables. 
Set scan off; 

CREATE OR REPLACE PROCEDURE SYS.p_tamanho
IS
-----------------------------------------------------------------------------------------------------------------
-- Empresa:        Sysdesign
-- Desenvolvedor:  Antonio Sant'Ana
-- Data:           02/06/2004
-- Objetivo:       Acompanhar crescimento Logwatch
-----------------------------------------------------------------------------------------------------------------
-- Histórico de Atualizações
-- Data         Empresa     Implementador      Descrição da Alteração
------------------------------------------------------------------------------------------------------------------
  -- tmpvar      NUMBER;
  -- w_enter     VARCHAR2 (2)           := CHR (13) || CHR (10);
  -- w_tab       VARCHAR2 (2)           := CHR (09);


   CURSOR c_segment
   IS
      SELECT   TO_DATE (SYSDATE, 'DD/MM/RR') dia, segment_type tipo,
               SUM (BYTES) / 1024 / 1024 tamanho
          FROM dba_segments
         WHERE owner = 'MERCATTO'
      GROUP BY segment_type;
BEGIN

   FOR v_segment_data IN c_segment
   LOOP
      IF c_segment%ROWCOUNT = 0
      THEN
         EXIT;
      END IF;

      INSERT INTO t_crescimento
           VALUES (v_segment_data.dia, v_segment_data.tipo,
                   v_segment_data.tamanho);

      COMMIT;
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN OTHERS
   THEN
      RAISE;
END p_tamanho;
/


