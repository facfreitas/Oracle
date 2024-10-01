CREATE OR REPLACE PROCEDURE p_tamanho
IS
   CURSOR c_segment
   IS
      SELECT   TO_DATE (SYSDATE, 'DD/MM/RR') dia, SEGMENT_NAME nome, segment_type tipo,
               SUM (BYTES) / 1024 / 1024 tamanho
          FROM dba_segments
         WHERE owner = 'LOGWATCH'
      GROUP BY segment_type, segment_name;
BEGIN

   FOR v_segment_data IN c_segment
   LOOP
      IF c_segment%ROWCOUNT = 0
      THEN
         EXIT;
      END IF;

      INSERT INTO t_crescimento
           VALUES (v_segment_data.dia, v_segment_data.nome, v_segment_data.tipo,
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


