BEGIN
   DBMS_REFRESH.MAKE(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '',
     next_date => TO_DATE('14/01/2002 19:00:00','DD/MM/YYYY HH24:MI:SS'),
     interval => '/*24:Hr*/ sysdate + 24/24',
     implicit_destroy => TRUE,
     lax => FALSE,
     job => 0,
     rollback_seg => NULL,
     push_deferred_rpc => FALSE,
     refresh_after_errors => TRUE,
     purge_option => NULL,
     parallelism => NULL,
     heap_size => NULL);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_CESU_MES_REF"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_CESU_MES"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_CESU_ACUM_ANO"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_GECO_MES_REF"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GECO_MES"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GECO_ACUM_ANO"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GECO_ACUM_12"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GECO_MES_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GECO_ACUM_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_PSU_MES_REF"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_PSU_MES"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_PSU_ACUM_ANO"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_PSU_ACUM_12"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_PSU_MES_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_PSU_ACUM_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_CESU_ACUM_12"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_CESU_MES_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_CESU_ACUM_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GECO_ACUM_12_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GECO_ACUMULADO"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_PSU_ACUM_12_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_PSU_ACUMULADO"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_CESU_ACUM_12_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_CESU_ACUMULADO"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_GRCO_MES_REF"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GRCO_MES"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GRCO_ACUM_ANO"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_CLASSE_MERCADO_MES_REF"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_MERCADO_MES"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_MERCADO_ACUM_ANO"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GRCO_ACUM_12"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GRCO_MES_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GRCO_ACUM_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GRCO_ACUM_12_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_GRCO_ACUMULADO"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_MERCADO_ACUM_12"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_MERCADO_MES_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_MERCADO_ACUM_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_MERCADO_ACUM_12_ANOANT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_MERCADO_ACUMULADO"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_BSE_LOCAL"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_PSU_LOCAL"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."V_HIST_MUNI_MERCADO_A"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."VM_TMP_HMGB"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."VM_TMP_GRCO"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."VM_TMP_LOC"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.ADD(
     name => '"MCH"."SNAP_GROUP_MCH"',
     list => '"MCH"."VM_TMP_MUNI"',
     lax => TRUE);
END;
/
