CREATE OR REPLACE PACKAGE BODY Carga
IS
--
-- Purpose: CORPO DO PACORTE DE CARGA MCH/SIC

   PROCEDURE parametros (w_param OUT parametros_carga%ROWTYPE)
   IS
   BEGIN
      SELECT *
        INTO w_param
        FROM parametros_carga
       WHERE num_seq = 0;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RAISE_APPLICATION_ERROR (-20000,
                                  'PARAMETROS DA CARGA ATUAL INEXISTENTE'
                                 );
   END parametros;

   PROCEDURE dados_job (nome_job IN VARCHAR2, w_job OUT jobs_carga%ROWTYPE)
   IS
   BEGIN
      SELECT *
        INTO w_job
        FROM jobs_carga
       WHERE job = nome_job;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RAISE_APPLICATION_ERROR (-20000,
                                  'JOB: [ ' || nome_job || ' ] INEXISTENTE'
                                 );
   END dados_job;

   PROCEDURE inicializa_mensagem (
      w_job   IN       jobs_carga%ROWTYPE,
      w_msg   OUT      jobs_mensagens%ROWTYPE
   )
   IS
   BEGIN
      w_msg.job := w_job.job;
      w_msg.dat_ref := w_job.ult_dat_ref;
      w_msg.num_jub := w_job.ult_num_jub;
      w_msg.num_linha := 0;
   END inicializa_mensagem;

   PROCEDURE finaliza_job
   IS
      numjob   BINARY_INTEGER;
   BEGIN
      UPDATE jobs_carga
         SET ult_dat_fim = SYSDATE,
             ind_proc = 'F'
       WHERE job = g_job.job;

      IF SQL%NOTFOUND
      THEN
         RAISE_APPLICATION_ERROR (-20000, 'JOB INEXISTENTE :' || g_job.job);
      END IF;

      COMMIT;

      IF g_job.job_pos IS NOT NULL
      THEN
         executa_job (g_param.dat_ref_atu, g_job.job_pos, numjob);
      END IF;

      Carga.gravalog (   ' NUMERO DO JOB '
                      || g_job.job_pos
                      || ' STARTADO .... '
                      || numjob
                     );
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE_APPLICATION_ERROR (-20000,
                                     'JOB: [ '
                                  || g_job.job
                                  || ' ] NAO FOI FINALIZADO'
                                 );
   END finaliza_job;

   PROCEDURE executa_job (
      data_ref   IN       DATE,
      nome_job   IN       VARCHAR2,
      numjob     IN OUT   BINARY_INTEGER
   )
   IS
      w_job       jobs_carga%ROWTYPE;
      w_job_ant   jobs_carga%ROWTYPE;
   BEGIN
      dados_job (nome_job, w_job);
      parametros (g_param);

      --- VERIFICA PROCESSO
      IF g_param.dat_ref_atu IS NULL
      THEN
         RAISE_APPLICATION_ERROR (-20000,
                                  'DATA DE REFERENCIA PARAMETRO NULA '
                                 );
      END IF;

      IF data_ref <> g_param.dat_ref_atu
      THEN
         RAISE_APPLICATION_ERROR (-20000,
                                  'DATA DE REFERENCIA DIFERENTE DO PARAMETRO'
                                 );
      END IF;

      IF w_job.ult_dat_ref = data_ref AND w_job.ind_proc = 'F'
      THEN
         RAISE_APPLICATION_ERROR (-20000,
                                  'JOB JÁ TERMINOU OK PARA ESTA DATA');
      END IF;

      IF w_job.job_ant IS NOT NULL
      THEN
         BEGIN
            SELECT *
              INTO w_job_ant
              FROM jobs_carga
             WHERE job = w_job.job_ant
               AND ult_dat_ref = data_ref
               AND ind_proc = 'F';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RAISE_APPLICATION_ERROR (-20000,
                                           'JOB ANTERIOR [ '
                                        || w_job.job_ant
                                        || ' ] NAO TERMINOU CORRENTAMENTE'
                                       );
         END;
      END IF;

      IF SQL%NOTFOUND
      THEN
         RAISE_APPLICATION_ERROR (-20000, 'JOB INEXISTENTE');
      END IF;

      DBMS_JOB.SUBMIT (numjob,
                          TRIM (w_job.proc)
                       || '(TO_DATE('
                       || ''''
                       || TO_CHAR (data_ref, 'YYYY-MM-DD')
                       || ''''
                       || ',''YYYY-MM-DD''),'
                       || ''''
                       || nome_job
                       || ''''
                       || ');',
                       SYSDATE,
                       NULL
                      );

      --- INICIALIZA PROCESSO
      BEGIN
         UPDATE jobs_carga
            SET ult_dat_ref = data_ref,
                ult_dat_proc = SYSDATE,
                ind_proc = 'I',
                ult_num_jub = numjob
          WHERE job = nome_job;
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE_APPLICATION_ERROR
                       (-20000,
                           'NAO FOI POSSIVEL INICIALIZAR PROCEDURE DO JOB;[ '
                        || nome_job
                        || ' ]'
                       );
      END;

      IF SQL%NOTFOUND
      THEN
         RAISE_APPLICATION_ERROR (-20000,
                                  'JOB: [ ' || nome_job || ' ] INEXISTENTE'
                                 );
      END IF;

      /*IF NOME_JOB    = 'GMCH0001' THEN
                  DBMS_JOB.SUBMIT( NUMJOB , 'MCH.CARGA.CARGA_INICIAL(TO_DATE(' || '''' || TO_CHAR(DATA_REF,'YYYY-MM-DD' ) || '''' || ',''YYYY-MM-DD''));' ,
                                 SYSDATE , null );

        ELSIF NOME_JOB = 'GMCH0002' THEN
                DBMS_JOB.SUBMIT( NUMJOB , 'MCH.CARGA.CRIA_INDICES(TO_DATE(' || '''' || TO_CHAR(DATA_REF,'YYYY-MM-DD' ) || ''''  || ',''YYYY-MM-DD''));',
                                 SYSDATE  , null );

        ELSIF NOME_JOB = 'GMCH0003' THEN
              DBMS_JOB.SUBMIT( NUMJOB , 'MCH.CARGA.ATUALIZA_VIEWS(TO_DATE(' || '''' || TO_CHAR(DATA_REF,'YYYY-MM-DD' ) || ''''  || ',''YYYY-MM-DD''));',
                               SYSDATE , null );

        ELSIF NOME_JOB = 'GMCH0004' THEN
              DBMS_JOB.SUBMIT( NUMJOB , 'MCH.CARGA.CARGA_HIST_MUNICIPIO(TO_DATE(' || '''' || TO_CHAR(DATA_REF,'YYYY-MM-DD' ) || ''''  || ',''YYYY-MM-DD''));',
                               SYSDATE , null );

        ELSIF NOME_JOB = 'GMCH0005' THEN
              DBMS_JOB.SUBMIT( NUMJOB , 'MCH.CARGA.CARGA_HIST_LOCALIDADE(TO_DATE(' || '''' || TO_CHAR(DATA_REF,'YYYY-MM-DD' ) || ''''  || ',''YYYY-MM-DD''));',
                               SYSDATE , null );

        ELSIF NOME_JOB = 'GMCH0006' THEN
              DBMS_JOB.SUBMIT( NUMJOB , 'MCH.CARGA.CARGA_HIST_MERCADO(TO_DATE(' || '''' || TO_CHAR(DATA_REF,'YYYY-MM-DD' ) || ''''  || ',''YYYY-MM-DD''));',
                               SYSDATE , null );

        ELSIF NOME_JOB = 'GMCH0007' THEN
              DBMS_JOB.SUBMIT( NUMJOB , 'MCH.CARGA.CARGA_HIST_GRCO(TO_DATE(' || '''' || TO_CHAR(DATA_REF,'YYYY-MM-DD' ) || ''''  || ',''YYYY-MM-DD''));',
                               SYSDATE , null );

        ELSE
             NUMJOB := 0 ;
        END IF; */
      COMMIT;
   END executa_job;

   PROCEDURE inicializa_area
   IS
      nao_existe_ind   EXCEPTION;
      PRAGMA EXCEPTION_INIT (nao_existe_ind, -01418);
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'DROP INDEX IN1_TMP_GRCO   ';
      EXCEPTION
         WHEN nao_existe_ind
         THEN
            Carga.gravalog
               ('*** ---- INDICE PARA GRANDES CONSUMIDORES NAO EXISTE ----*** '
               );
      END;

      BEGIN
         EXECUTE IMMEDIATE 'DROP INDEX IN1_TMP_LOC    ';
      EXCEPTION
         WHEN nao_existe_ind
         THEN
            Carga.gravalog
                      ('*** ---- INDICE PARA LOCALIDADES NAO EXISTE ----*** ');
      END;

      BEGIN
         EXECUTE IMMEDIATE 'DROP INDEX IN1_TMP_MGB    ';
      EXCEPTION
         WHEN nao_existe_ind
         THEN
            Carga.gravalog
                   ('*** ---- INDICE PARA MERCADO GLOBAL NAO EXISTE ----*** ');
      END;

      EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_REG_MCH';
   END inicializa_area;

   PROCEDURE grava_area (w_reg IN tmp_reg_mch%ROWTYPE)
   IS
   BEGIN
      INSERT INTO tmp_reg_mch
                  (dat_ref, tip_fat, cod_grco,
                   cod_muni, cod_loc, cod_bair,
                   cod_atec, cod_fxa, cod_grp_tsta,
                   cod_gclm, con_pta, dem_pta,
                   con_fpta, dem_fpta, imp_dem,
                   imp_con, val_ece, val_iuee,
                   pot_insd, dem_ctda_pta, dem_ctda_fpta,
                   ind_grco, ind_cont, dem_lda_pta,
                   dem_lda_fpta, dem_ult_pta,
                   dem_ult_fpta, dem_forn, con_resv,
                   dat_ini_ctr, dat_fatura, tpo_can
                  )
           VALUES (w_reg.dat_ref, w_reg.tip_fat, w_reg.cod_grco,
                   w_reg.cod_muni, w_reg.cod_loc, w_reg.cod_bair,
                   w_reg.cod_atec, w_reg.cod_fxa, w_reg.cod_grp_tsta,
                   w_reg.cod_gclm, w_reg.con_pta, w_reg.dem_pta,
                   w_reg.con_fpta, w_reg.dem_fpta, w_reg.imp_dem,
                   w_reg.imp_con, w_reg.val_ece, w_reg.val_iuee,
                   w_reg.pot_insd, w_reg.dem_ctda_pta, w_reg.dem_ctda_fpta,
                   w_reg.ind_grco, w_reg.ind_cont, w_reg.dem_lda_pta,
                   w_reg.dem_lda_fpta, w_reg.dem_ult_pta,
                   w_reg.dem_ult_fpta, w_reg.dem_forn, w_reg.con_resv,
                   w_reg.dat_ini_ctr, w_reg.dat_fatura, w_reg.tpo_can
                  );

      g_reg_grav := g_reg_grav + 1;
      g_reg_held := g_reg_held + 1;

      IF g_reg_held >= g_qtd_held
      THEN
         COMMIT;
         g_reg_held := 0;
         Carga.gravalog (   ' QUANT. DE REG. GRAVADOS ATE O MOMENTO.... '
                         || TO_CHAR (g_reg_grav, '9999,999,999')
                        );
      END IF;
   END grava_area;

   PROCEDURE finaliza_area
   IS
   BEGIN
      COMMIT;
   END finaliza_area;

   PROCEDURE carrega_faixas (w_tb_fxa IN OUT t_fxa)
   IS
      f   mch.faixas_consumo%ROWTYPE;
      i   BINARY_INTEGER               := 0;
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('-- CARREGA TABELAS DE FAIXAS DE CONSUMO --');

      FOR f IN (SELECT *
                  FROM mch.faixas_consumo
                 WHERE cod_fxa <> 0)
      LOOP
         i := i + 1;
         w_tb_fxa (i) := f;
      END LOOP;

      FOR i IN 1 .. w_tb_fxa.COUNT
      LOOP
         DBMS_OUTPUT.PUT_LINE (   ' COD '
                               || TO_CHAR (w_tb_fxa (i).cod_fxa, '99')
                               || ' DE '
                               || TO_CHAR (w_tb_fxa (i).con_fxa_de, '999999')
                               || ' ATE '
                               || TO_CHAR (w_tb_fxa (i).con_fxa_ate, '999999')
                              );
      END LOOP;

      DBMS_OUTPUT.PUT_LINE ('-- FINAL CARREGA TABELAS DE FAIXAS DE CONSUMO --');
   END carrega_faixas;

   --- mch2etp - inicio
   PROCEDURE carrega_faixas_grte (w_tb_fxa_grte IN OUT t_fxa_grte)
   IS
      f   mch.faixas_trf_grte%ROWTYPE;
      i   BINARY_INTEGER                := 0;
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('-- CARREGA TABELAS DE FAIXAS GRUPOS TENSAO --');

      FOR f IN (SELECT *
                  FROM mch.faixas_trf_grte)
      LOOP
         i := i + 1;
         w_tb_fxa_grte (i) := f;
      END LOOP;

      FOR i IN 1 .. w_tb_fxa_grte.COUNT
      LOOP
         DBMS_OUTPUT.PUT_LINE (   ' COD '
                               || w_tb_fxa_grte (i).cod_tptr
                               || ' DE '
                               || TO_CHAR (w_tb_fxa_grte (i).cod_grp_ini,
                                           '99')
                               || ' ATE '
                               || TO_CHAR (w_tb_fxa_grte (i).cod_grp_fim,
                                           '99')
                              );
      END LOOP;

      DBMS_OUTPUT.PUT_LINE
                        ('-- FINAL CARREGA TABELAS DE FAIXAS GRUPOS TENSAO --');
   END carrega_faixas_grte;

   --- mch2etp - fim
   PROCEDURE transforma (
      w_ret   IN OUT   VARCHAR2,                         -- 91198806 9928 3036
      w_reg   IN       VARCHAR2,
      w_sic   OUT      t_reg_sic,
      w_con   OUT      t_con
   )
   IS
      i      BINARY_INTEGER;
      j      BINARY_INTEGER;
      pulo   NUMBER (5);
   BEGIN
      w_sic := NULL;
      w_con.DELETE;
      w_ret := '  ';
      w_sic.tip_rectif := SUBSTR (w_reg, 0001, 02);
      w_sic.cod_contrato := SUBSTR (w_reg, 0003, 10);
      w_sic.tip_est_contrato := SUBSTR (w_reg, 0013, 02);
      w_sic.cod_cliente := SUBSTR (w_reg, 0015, 08);
      w_sic.num_factura := SUBSTR (w_reg, 0023, 26);
      w_sic.tip_factura := SUBSTR (w_reg, 0049, 03);
      w_sic.tip_factrn_nor := SUBSTR (w_reg, 0052, 02);
      w_sic.p_sumi.cod_provincia :=
                                   TO_NUMBER (SUBSTR (w_reg, 0054, 02), '99');
      w_sic.p_sumi.cod_pob.cod_mun :=
                                  TO_NUMBER (SUBSTR (w_reg, 0056, 03), '999');
      w_sic.p_sumi.cod_pob.cod_loc :=
                                   TO_NUMBER (SUBSTR (w_reg, 0059, 02), '99');
      w_sic.p_sumi.cod_pob.bairro :=
                                  TO_NUMBER (SUBSTR (w_reg, 0061, 03), '999');
      w_sic.p_sumi.cod_calle := TO_NUMBER (SUBSTR (w_reg, 0064, 05), '99999');
      w_sic.p_sumi.cod_finca := TO_NUMBER (SUBSTR (w_reg, 0069, 04), '9999');
      w_sic.p_sumi.cod_punto_sumin :=
                                  TO_NUMBER (SUBSTR (w_reg, 0073, 03), '999');
      w_sic.cod_org_inter_of := TO_NUMBER (SUBSTR (w_reg, 0076, 03), '999');
      w_sic.cod_org_inter_ut := TO_NUMBER (SUBSTR (w_reg, 0079, 03), '999');
      w_sic.cod_org_inter_uo := TO_NUMBER (SUBSTR (w_reg, 0082, 03), '999');
      w_sic.cod_org_inter_ur := TO_NUMBER (SUBSTR (w_reg, 0085, 03), '999');
      w_sic.cod_cnae.cla.cod_classe := SUBSTR (w_reg, 0088, 01);
      w_sic.cod_cnae.cla.cod_subcla := SUBSTR (w_reg, 0089, 01);
      w_sic.cod_cnae.ramo.cod_ramo := SUBSTR (w_reg, 0090, 02);
      w_sic.cod_cnae.ramo.cod_subramo := SUBSTR (w_reg, 0092, 02);
      -- Devido a alteração do cod_cnae de 7 para 9 digitos
      -- teve que aumentar para mais duas casas os campos abaixo ex. 0095 para 0097
      w_sic.cod_tarifa := SUBSTR (w_reg, 0097, 04);
      w_sic.cod_tarifa_dou := SUBSTR (w_reg, 0101, 03);
      w_sic.carga_instal :=
                      TO_NUMBER (SUBSTR (w_reg, 0104, 09), '999999999')
                      / 1000;
      w_sic.perda_transf :=
                         TO_NUMBER (SUBSTR (w_reg, 0113, 05), '99999')
                         / 10000;
      w_sic.cod_tension := SUBSTR (w_reg, 0118, 02);
      w_sic.data_leitura_de :=
                             TO_DATE (SUBSTR (w_reg, 0120, 10), 'YYYY-MM-DD');
      w_sic.data_leitura_ate :=
                             TO_DATE (SUBSTR (w_reg, 0130, 10), 'YYYY-MM-DD');

      ---  mch2etp - inicio
      BEGIN
         w_sic.data_inicio_fat :=
                             TO_DATE (SUBSTR (w_reg, 0140, 10), 'YYYY-MM-DD');
      EXCEPTION
         WHEN OTHERS
         THEN
            w_sic.data_inicio_fat := NULL;
      END;

      BEGIN
         w_sic.data_fat := TO_DATE (SUBSTR (w_reg, 0150, 10), 'YYYY-MM-DD');
      EXCEPTION
         WHEN OTHERS
         THEN
            w_sic.data_fat := NULL;
      END;

      BEGIN
         w_sic.dem_ctda_pta :=
                            TO_NUMBER (SUBSTR (w_reg, 0160, 09), '999999999') / 1000;
         w_sic.dem_ctda_fpta :=
                            TO_NUMBER (SUBSTR (w_reg, 0169, 09), '999999999') / 1000;
      EXCEPTION
         WHEN OTHERS
         THEN
            w_sic.dem_ctda_pta := 0;
            w_sic.dem_ctda_fpta := 0;
      END;

      w_sic.tip_mot_can := SUBSTR (w_reg, 178, 02);
      ---  mch2etp - fim
      i := 1;
      j := 0;

      FOR i IN 1 .. 30
      LOOP
         pulo := 67 * (i - 1);

         IF SUBSTR (w_reg, 0190 + pulo, 03) <> '   '
         THEN
            j := j + 1;
            w_con (j).conceito_energia := SUBSTR (w_reg, 0190 + pulo, 03);
            w_con (j).con_lido :=
                 TO_NUMBER (SUBSTR (w_reg, 0193 + pulo, 12), 'S99999999999')
               / 100;
            w_con (j).con_fat :=
                 TO_NUMBER (SUBSTR (w_reg, 0205 + pulo, 12), 'S99999999999')
               / 100;
            w_con (j).val_ajuste :=
                 TO_NUMBER (SUBSTR (w_reg, 0217 + pulo, 12), 'S99999999999')
               / 100;
            w_con (j).imp_conceito :=
                 TO_NUMBER (SUBSTR (w_reg, 0229 + pulo, 14), 'S9999999999999')
               / 100;
            w_con (j).imp_base_icms :=
                 TO_NUMBER (SUBSTR (w_reg, 0243 + pulo, 14), 'S9999999999999')
               / 100;
         END IF;
      END LOOP;

      w_ret := 'OK';
   EXCEPTION
      WHEN OTHERS
      THEN
         w_ret := 'NO';
   END transforma;

   FUNCTION calcfaixa_grte (w_grp IN mch.faixas_trf_grte.cod_grp_ini%TYPE)
      RETURN mch.faixas_trf_grte.cod_tptr%TYPE
   --  BUSCA FAIXA NA TABELA DE FAIXA
   IS
      i   BINARY_INTEGER := 0;
   BEGIN
      FOR i IN 1 .. g_fxa_grte.COUNT
      LOOP
         IF w_grp BETWEEN g_fxa_grte (i).cod_grp_ini
                      AND g_fxa_grte (i).cod_grp_fim
         THEN
            RETURN g_fxa_grte (i).cod_tptr;
         END IF;
      END LOOP;

      RETURN '999';
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN '999';
   END calcfaixa_grte;

   FUNCTION calcfaixa (w_con IN NUMBER)
      RETURN NUMBER
   --  BUSCA FAIXA NA TABELA DE FAIXA
   IS
      i   BINARY_INTEGER := 0;
   BEGIN
      FOR i IN 1 .. g_fxa.COUNT
      LOOP
         IF w_con BETWEEN g_fxa (i).con_fxa_de AND g_fxa (i).con_fxa_ate
         THEN
            RETURN g_fxa (i).cod_fxa;
         END IF;
      END LOOP;

      RETURN 00;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 99;
   END calcfaixa;

   PROCEDURE calctarifa (
      w_ret    IN OUT   VARCHAR2,
      tar      IN       VARCHAR2,
      w_calc   IN OUT   NUMBER
   )
   IS
   BEGIN
      w_calc := 00;

      IF SUBSTR (tar, 1, 2) = '61'
      THEN
         IF SUBSTR (tar, 3, 1) = '1'
         THEN
            w_calc := 10;
         ELSIF SUBSTR (tar, 3, 1) = '2'
         THEN
            w_calc := 11;
         ELSIF SUBSTR (tar, 3, 1) = '3'
         THEN
            w_calc := 12;
         ELSIF SUBSTR (tar, 3, 2) = '41'
         THEN
            w_calc := 15;
         ELSIF SUBSTR (tar, 3, 2) = '42'
         THEN
            w_calc := 13;
         ELSIF SUBSTR (tar, 3, 2) = '43'
         THEN
            w_calc := 16;
         ELSIF SUBSTR (tar, 3, 1) = '5'
         THEN
            w_calc := TO_NUMBER (SUBSTR (tar, 3, 2), '99') - 11;
         END IF;
      ELSIF SUBSTR (tar, 1, 2) = '62'
      THEN
         IF SUBSTR (tar, 3, 1) = '1'
         THEN
            w_calc := 01;
         ELSIF SUBSTR (tar, 3, 1) = '2'
         THEN
            w_calc := 02;
         ELSIF SUBSTR (tar, 3, 1) = '3'
         THEN
            w_calc := TO_NUMBER (SUBSTR (tar, 3, 2), '99') + 15;
         END IF;
      ELSIF SUBSTR (tar, 1, 2) = '63'
      THEN
         IF SUBSTR (tar, 3, 1) = '1'
         THEN
            w_calc := 30;
         ELSIF SUBSTR (tar, 3, 1) = '2'
         THEN
            w_calc := 31;
         ELSIF SUBSTR (tar, 3, 1) = '3'
         THEN
            w_calc := 32;
         ELSIF SUBSTR (tar, 3, 2) = '41'
         THEN
            w_calc := 50;
         END IF;
      ELSIF SUBSTR (tar, 1, 2) = '64'
      THEN
         IF SUBSTR (tar, 3, 1) = '1'
         THEN
            w_calc := 20;
         ELSIF SUBSTR (tar, 3, 1) = '2'
         THEN
            w_calc := 21;
         ELSIF SUBSTR (tar, 3, 1) = '3'
         THEN
            w_calc := 22;
         ELSIF SUBSTR (tar, 3, 1) = '4'
         THEN
            w_calc := 23;
         ELSIF SUBSTR (tar, 3, 1) = '5'
         THEN
            w_calc := 24;
         ELSIF SUBSTR (tar, 3, 1) = '6'
         THEN
            w_calc := 25;
         ELSIF SUBSTR (tar, 3, 2) = '71'
         THEN
            w_calc := 51;
         END IF;
      ELSIF SUBSTR (tar, 1, 2) IN ('91', '92')
      THEN
         w_calc := TO_NUMBER (SUBSTR (tar, 3, 2), '99');
      END IF;

      IF w_calc = 00
      THEN
         w_ret := '05';
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         w_ret := '12';
   END calctarifa;

   FUNCTION classe_mercado (classe IN CHAR, subcla IN CHAR)
      RETURN VARCHAR2
   IS
      w_cla    VARCHAR2 (01) := NULL;
      w_scla   VARCHAR2 (01) := NULL;
   BEGIN
      w_cla := classe;

      IF classe IN ('B', 'L', 'O')
      THEN
         w_scla := 'A';
      ELSIF classe IN ('C', 'M') AND subcla = 'K'
      THEN
         w_scla := 'K';
      ELSIF classe = 'M' AND subcla = 'S'
      THEN
         w_scla := 'S';
      ELSIF classe = 'N' AND subcla = 'I'
      THEN
         w_scla := 'I';
      ELSIF classe IN ('A', 'D', 'E', 'C', 'M', 'N')
      THEN
         w_scla := 'Z';
      ELSE
         RETURN NULL;
      END IF;

      RETURN w_cla || w_scla;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END classe_mercado;

   PROCEDURE dadosmch (
      dt_ref   IN       DATE,
      w_ret    IN OUT   VARCHAR2,
      w_sic    IN       t_reg_sic,
      w_con    IN       t_con,
      w_mch    OUT      tmp_reg_mch%ROWTYPE
   )
   IS
      i                 BINARY_INTEGER;
      w_perda           NUMBER (7, 4);
      -- mch2etp - inicio
      w_tp_tar          mch.faixas_trf_grte.cod_tptr%TYPE;
      w_dem_conv        NUMBER (13, 2)                      := 0;
      w_dem_forn_pta    NUMBER (13, 2)                      := 0;
      w_dem_forn_fpta   NUMBER (13, 2)                      := 0;
   -- mch2etp - fim
      L_BAIXA_RENDA     BOOLEAN := FALSE; /* MCH1BXR */

   BEGIN
      w_mch := NULL;
      w_ret := 'OK';

      IF w_sic.tip_rectif = '  '
      THEN
         w_mch.tip_fat := 'FAT';
      ELSIF w_sic.tip_rectif IN ('DA', 'RR')
      THEN
         w_mch.tip_fat := 'CAN';
      ELSIF w_sic.tip_rectif = 'RA'
      THEN
         w_mch.tip_fat := 'REF';
      ELSE
         w_mch.tip_fat := 'OUT';
      END IF;

      w_mch.cod_grco := w_sic.cod_contrato;

      -- VERIFICA SE INDICADOR DE CONTAGEM DE FATURA
      IF w_mch.tip_fat = 'FAT'
      THEN
         w_mch.ind_cont := 0;

         IF g_param.des_empresa = 'COSERN'
         THEN
            /*
               DATA DA ALTERAÇÃO: 01/11/2002
               Solicitação feita por Elaine(Cosern) e Helms(Coelba) para colocar mais um filtro
               referente à data de leitura ate.
            */
            IF     g_cod_grco_ant <> w_mch.cod_grco
               AND w_sic.tip_factura IN ('NOR', 'NBA', 'NMO', 'TBA', 'TNO')
               AND TO_CHAR (w_sic.data_leitura_ate, 'MM/YYYY') =
                                        TO_CHAR (dt_ref, 'MM/YYYY')
                                                                   -- INSERIDO
            THEN
               w_mch.ind_cont := 1;
               g_cod_grco_ant := w_mch.cod_grco;
               g_qtd_cons := g_qtd_cons + 1;
            END IF;
         ELSE                                                  -- COELBA CELPE
            IF     g_cod_grco_ant <> w_mch.cod_grco
               AND w_sic.tip_factura IN ('NOR', 'NBA', 'NMO', 'TBA', 'TNO')
            THEN
               w_mch.ind_cont := 1;
               g_cod_grco_ant := w_mch.cod_grco;
               g_qtd_cons := g_qtd_cons + 1;
            END IF;
         END IF;
      ELSE
         w_mch.ind_cont := 0;
      END IF;

      w_mch.cod_muni := w_sic.p_sumi.cod_pob.cod_mun;
      w_mch.cod_loc := w_sic.p_sumi.cod_pob.cod_loc;
      w_mch.cod_bair := w_sic.p_sumi.cod_pob.bairro;

      --- VERIFICA TARIFA
      BEGIN
         calctarifa (w_ret, w_sic.cod_tarifa, w_mch.cod_grp_tsta);
      EXCEPTION
         WHEN OTHERS
         THEN
            w_ret := '16';
      END;

      --- VERIFICA TIPO TARIFA/GRUPO TENSAO
      w_tp_tar := '   ';

      BEGIN
         w_tp_tar := calcfaixa_grte (w_mch.cod_grp_tsta);

         IF w_tp_tar = '999'
         THEN
            w_ret := '22';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            w_ret := '23';
      END;

      IF w_tp_tar = 'CON'
      THEN
         g_tar_con := g_tar_con + 1;
      ELSIF w_tp_tar = 'HZA'
      THEN
         g_tar_hza := g_tar_hza + 1;
      ELSIF w_tp_tar = 'HZV'
      THEN
         g_tar_hzv := g_tar_hzv + 1;
      ELSE
         g_tar_out := g_tar_out + 1;
      END IF;

      -- VARRE CONCEITOS
      i := 1;
      w_mch.con_pta := 0;
      w_mch.dem_pta := 0;
      w_mch.con_fpta := 0;
      w_mch.dem_fpta := 0;
      w_mch.imp_dem := 0;
      w_mch.imp_con := 0;
      w_mch.val_ece := 0;
      w_mch.val_iuee := 0;
      --- mch2etp - inicio
      w_mch.con_resv := 0;
      w_mch.dem_lda_pta := 0;
      w_mch.dem_lda_fpta := 0;
      w_mch.dem_ult_pta := 0;
      w_mch.dem_ult_fpta := 0;
      w_mch.dem_forn := 0;
      w_dem_conv := 0;
      w_dem_forn_pta := 0;
      w_dem_forn_fpta := 0;

      --- mch2etp - fim
	  
      L_BAIXA_RENDA            := FALSE; /* MCH1BXR */

      BEGIN
         FOR i IN 1 .. w_con.COUNT
         LOOP
               --IF     W_CON(I).CONCEITO_ENERGIA = '021' THEN
            /*
            Conforme decidido na reunião do dia 29/07/2002 onde estvam presentes:
                     » Carlos Dias          - SGS
                     » Alisson Barbosa      - SGS
                     » Helms Carvalho    - SIMP/SIN
                     » Renato Araújo     - SIMP/SIN (Stefanini)
                     » Lise Rastelli     - GOS
                     » Geraldo Ramos     - TIE
                     » Demizes Santana      - CGM
                     » Laucides Almeida     - CGM
                     » Henrique
            que para:
               ¢ Consumo Ativo na Ponta será considerado também o conceito 022;
               ¢ Consumo Ativo Fora de Ponta será considerado também os conceitos 024, 026 e 422, e os tipos
                 de Faturas COM e FRA;
               ¢ Demanda Fora de Ponta será considerado também o conceito 410.
            */
            IF w_con (i).conceito_energia IN ('021', '022')
            THEN
               --- CONSUMO ATIVO NA PONTA
               BEGIN
                  w_mch.val_iuee :=
                       w_mch.val_iuee
                     + w_con (i).imp_conceito
                     - w_con (i).imp_base_icms;
                  w_mch.imp_con := w_mch.imp_con + w_con (i).imp_base_icms;

                  IF    w_sic.tip_factura IN
                           ('TNO',                          -- ESTIMADO-NORMAL
                            'FRA',                                   -- FRAUDE
                            'COM',                              -- COMPLEMENTO
                            'TBA',                        -- ESTIMADO-DESATIVA
                            'EMA',
                            'EMM',
                            'EMR',                          -- EVENTUAL-MEDIDO
                            'ETA',
                            'ETM',
                            'ETR'
                           )                              -- EVENTUAL-ESTIMADO
                     OR w_sic.tip_factrn_nor = '04'          -- ESTIMADO-IRREG
                  -- tirado apartir do Forum
                  -- Renato - 25/11/2002
                       --                        OR
                       --( SUBSTR(W_SIC.COD_TARIFA,1,2) IN ('62' , '63' , '64' ) AND
                       --  W_SIC.PERDA_TRANSF  <> 0 )
                       --                        OR
                       --( SUBSTR(W_SIC.COD_TARIFA,1,2) IN ( '91' , '92' ) AND
                       --  SUBSTR(W_SIC.COD_TARIFA,3,2) =  '11'  )
                  THEN
                     w_mch.con_pta :=
                                    w_mch.con_pta + TRUNC (w_con (i).con_fat);
                  ELSE
                     w_mch.con_pta :=
                          w_mch.con_pta
                        + TRUNC (w_con (i).con_lido)
                        + TRUNC (w_con (i).val_ajuste);
                  END IF;
               END;
            ELSIF w_con (i).conceito_energia IN
                    ('020',
                     '023',
                     '027',
                     '051',
                     '030',
                     '040',
                     '050',
                     '055',
                     '058',
                     '059',
                     '060',
                     '061',
                     '062',
                     '063',
                     '064',
                     '065',
                     '066',
                     '067',
                     '068',
                     '069',
                     '070',
                     '071',
                     '072',
                     '073',
                     '074',
                     '075',
                     '076',
                     '077',
                     '078',
                     '024',
                     '422'
                    )
            -- Alteração    : Foi inserido o conceito 078
            -- Alterado por : Renato
            -- Data         : 28/01/2002
            -- Alteração    : Foi inserido os conceitos '024' , '026' , '422'
            -- Alterado por : Renato (Apartir da decisão da reuniao)
            -- Data         : 29/07/2002
            -- mch2etp - inicio
               -- foi separados os conceitos '025' e '026' para o Consumo Reservado
            --- mch2etp - fim
            -- Alteração    : Foi inserido o conceito 051
            -- Alterado por : Renato
            -- Data         : 25/11/2002
            THEN
               --- CONSUMO ATIVO FORA DE PONTA
               BEGIN
			   --- TRATAMENTO DA cLASSE RESIDENCIAL DE BAIXA RENDA
			   --- ALTERAÇÃO MCH1BXR
				   
			      IF W_CON(I).CONCEITO_ENERGIA = '030' THEN          /* MCH1BXR-inicio */
			         L_BAIXA_RENDA            := TRUE; 
				  END IF;                                            /* MCH1BXR-fim */
			   
                  w_mch.val_iuee :=
                       w_mch.val_iuee
                     + w_con (i).imp_conceito
                     - w_con (i).imp_base_icms;
                  w_mch.imp_con := w_mch.imp_con + w_con (i).imp_base_icms;

                  IF    w_sic.tip_factura IN
                           ('TNO',                          -- ESTIMADO-NORMAL
                            'TBA',                        -- ESTIMADO-DESATIVA
                            'FRA',                                   -- FRAUDE
                            'COM',                              -- COMPLEMENTO
                            'EMA',
                            'EMM',
                            'EMR',                          -- EVENTUAL-MEDIDO
                            'ETA',
                            'ETM',
                            'ETR'
                           )                              -- EVENTUAL-ESTIMADO
                     OR w_sic.tip_factrn_nor = '04'          -- ESTIMADO-IRREG
                  -- Tirado apartir da decisão do Forum
                  -- Renato - 25/11/2002
                       --                        OR
                       --( SUBSTR(W_SIC.COD_TARIFA,1,2) IN ('62' , '63' , '64' ) AND
                       --  W_SIC.PERDA_TRANSF  <> 0 )
                       --                        OR
                       --( SUBSTR(W_SIC.COD_TARIFA,1,2) IN ( '91' , '92' ) AND
                       --  SUBSTR(W_SIC.COD_TARIFA,3,2) =  '11'  )
                  THEN
                     w_mch.con_fpta :=
                                   w_mch.con_fpta + TRUNC (w_con (i).con_fat);
                  ELSE
                     w_mch.con_fpta :=
                          w_mch.con_fpta
                        + TRUNC (w_con (i).con_lido)
                        + TRUNC (w_con (i).val_ajuste);
                  END IF;
               END;
            --- mch2etp - inicio
            ELSIF w_con (i).conceito_energia IN ('025', '026')
            THEN
               --- CONSUMO RESERVADO
               BEGIN
                  w_mch.val_iuee :=
                       w_mch.val_iuee
                     + w_con (i).imp_conceito
                     - w_con (i).imp_base_icms;
                  w_mch.imp_con := w_mch.imp_con + w_con (i).imp_base_icms;

                  IF    w_sic.tip_factura IN
                           ('TNO',                          -- ESTIMADO-NORMAL
                            'TBA',                        -- ESTIMADO-DESATIVA
                            'FRA',                                   -- FRAUDE
                            'COM',                              -- COMPLEMENTO
                            'EMA',
                            'EMM',
                            'EMR',                          -- EVENTUAL-MEDIDO
                            'ETA',
                            'ETM',
                            'ETR'
                           )                              -- EVENTUAL-ESTIMADO
                     OR w_sic.tip_factrn_nor = '04'          -- ESTIMADO-IRREG
                       -- Tirado apartir da decisão do forum
                  -- Renato - 25/11/2002
                  --                        OR
                       --( SUBSTR(W_SIC.COD_TARIFA,1,2) IN ('62' , '63' , '64' ) AND
                       --  W_SIC.PERDA_TRANSF  <> 0 )
                       --                        OR
                       --( SUBSTR(W_SIC.COD_TARIFA,1,2) IN ( '91' , '92' ) AND
                       --  SUBSTR(W_SIC.COD_TARIFA,3,2) =  '11'  )
                  THEN
                     w_mch.con_resv :=
                                   w_mch.con_resv + TRUNC (w_con (i).con_fat);
                  ELSE
                     w_mch.con_resv :=
                          w_mch.con_resv
                        + TRUNC (w_con (i).con_lido)
                        + TRUNC (w_con (i).val_ajuste);
                  END IF;
               END;
            --- mch2etp -fim
            ELSIF w_con (i).conceito_energia = '011'
            THEN
               --- DEMANDA NA PONTA
               BEGIN
                  w_mch.val_iuee :=
                       w_mch.val_iuee
                     + w_con (i).imp_conceito
                     - w_con (i).imp_base_icms;
                  w_mch.imp_dem := w_mch.imp_dem + w_con (i).imp_base_icms;
                  w_mch.dem_pta := w_mch.dem_pta + TRUNC (w_con (i).con_fat);
                  --- mch2etp - inicio
                  w_mch.dem_lda_pta :=
                                w_mch.dem_lda_pta + TRUNC (w_con (i).con_lido);
                  w_dem_forn_pta :=
                     w_dem_forn_pta + --- para calculo da demanda fornecimento
                                     TRUNC (w_con (i).con_fat);
               --- mch2etp -fim
               END;
            --ELSIF  W_CON(I).CONCEITO_ENERGIA IN (  '010' , '012' ,  '017'  )
            ELSIF w_con (i).conceito_energia IN ('010', '012', '017', '410')
            THEN
               --- DEMANDA FORA DE PONTA
               BEGIN
                  w_mch.val_iuee :=
                       w_mch.val_iuee
                     + w_con (i).imp_conceito
                     - w_con (i).imp_base_icms;
                  w_mch.imp_dem := w_mch.imp_dem + w_con (i).imp_base_icms;
                  w_mch.dem_fpta := w_mch.dem_fpta + TRUNC (w_con (i).con_fat);
                  --- mch2etp - inicio
                  w_mch.dem_lda_fpta :=
                               w_mch.dem_lda_fpta + TRUNC (w_con (i).con_lido);

                  IF w_con (i).conceito_energia = '010'
                  THEN                --- para calculo da demanda fornecimento
                     w_dem_conv := w_dem_conv + TRUNC (w_con (i).con_fat);
                  ELSIF w_con (i).conceito_energia = '017'
                  THEN
                     BEGIN
                        w_dem_conv := w_dem_conv + TRUNC (w_con (i).con_fat);

                        IF w_tp_tar = 'HZV'
                        THEN
                        --- Horo_verde (Fornecimento Fora de Ponta 012 + 017)
                           w_dem_forn_fpta :=
                                  w_dem_forn_fpta + TRUNC (w_con (i).con_fat);
                        END IF;
                     END;
                  ELSIF w_con (i).conceito_energia = '012'
                  THEN
                     w_dem_forn_fpta :=
                                  w_dem_forn_fpta + TRUNC (w_con (i).con_fat);
                  END IF;
               --- mch2etp -fim
               END;
            ELSIF w_con (i).conceito_energia = '018'
            THEN
               --- demanda ultrapassagem na ponta
               BEGIN
                  w_mch.val_iuee :=
                       w_mch.val_iuee
                     + w_con (i).imp_conceito
                     - w_con (i).imp_base_icms;
                  w_mch.imp_dem := w_mch.imp_dem + w_con (i).imp_base_icms;
                  --- mch2etp - inicio
                  w_mch.dem_ult_pta :=
                                 w_mch.dem_ult_pta + TRUNC (w_con (i).con_fat);
                  w_dem_forn_pta :=
                     w_dem_forn_pta + --- para calculo da demanda fornecimento
                                     TRUNC (w_con (i).con_fat);
               --- mch2etp -fim
               END;
            ELSIF w_con (i).conceito_energia = '019'
            THEN
               --- demanda ultrapassagem fora de ponta
               BEGIN
                  w_mch.val_iuee :=
                       w_mch.val_iuee
                     + w_con (i).imp_conceito
                     - w_con (i).imp_base_icms;
                  w_mch.imp_dem := w_mch.imp_dem + w_con (i).imp_base_icms;
                  --- mch2etp - inicio
                  w_mch.dem_ult_fpta :=
                                w_mch.dem_ult_fpta + TRUNC (w_con (i).con_fat);

                  IF w_tp_tar = 'HZA'
                  THEN    --- Horo_Azul (Fornecimento Fora de Ponta 012 + 019)
                     w_dem_forn_fpta :=
                                  w_dem_forn_fpta + TRUNC (w_con (i).con_fat);
                  END IF;
               --- mch2etp -fim
               END;
            END IF;
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            w_ret := '15';
      END;

      --- mch2etp - inicio
      --- Calculo da demanda de Foenecimento
      --- Demanda Fornecimento = dem_010 + dem_017 +
      ---                        maior valor de ( dem_012 + ( dem_019 para Horo-Azul ou
      ---                                                     dem_017 para Horo-Verde ) ** Total Fora de ponta
      ---                                     e ( dem_011 + dem_018 )                   ** Total na Ponta
      ---
      IF w_dem_forn_pta >= w_dem_forn_fpta
      THEN
         w_mch.dem_forn := w_dem_conv + w_dem_forn_pta;
      ELSE
         w_mch.dem_forn := w_dem_conv + w_dem_forn_fpta;
      END IF;

      --- mch2etp - fim

      --- VALIDA DATA REFERENCIA
      IF    TRUNC (w_sic.data_leitura_ate, 'MM') > dt_ref
         OR (    w_mch.tip_fat = 'FAT'
             AND TRUNC (w_sic.data_leitura_ate, 'MM') < dt_ref
            )
      THEN
         w_mch.dat_ref := dt_ref;
      ELSE
         w_mch.dat_ref := TRUNC (w_sic.data_leitura_ate, 'MM');
      END IF;

      /*
      Alterado por : Renato Jr
      Data         : 19/04/2002
      Foi retirado, pois segundo a sra. Le informou que os
      valores já estao com a perda de transformação
      */--- PERDAS
        --IF W_SIC.PERDA_TRANSF  <> 0 THEN
        --   BEGIN
        --     W_PERDA        :=  W_SIC.PERDA_TRANSF / 100 ;
        --      W_PERDA        :=  W_PERDA + 1 ;
        --      W_MCH.CON_FPTA :=  TRUNC(W_MCH.CON_FPTA * W_PERDA) ;
        --      W_MCH.CON_PTA  :=  TRUNC(W_MCH.CON_PTA  * W_PERDA) ;
        --   END;
        --END IF ;

      --- VERIFICA GRANDE CONSUMIDOR
      w_mch.ind_grco := ' ';

      IF    SUBSTR (w_sic.cod_tarifa, 1, 2) IN ('63', '64')     -- HOROSAZONAL
         OR (    w_sic.carga_instal > 199
             AND SUBSTR (w_sic.cod_tarifa, 1, 2) IN ('62', '92')
             AND                                                    -- GRUPO-A
                 (   w_mch.con_fpta + w_mch.con_pta > 0
                  OR w_mch.dem_fpta > 0
                  OR w_mch.dem_fpta > 0
                 )
            )
      THEN
         w_mch.ind_grco := 'S';
      END IF;

      w_mch.cod_atec :=
            w_sic.cod_cnae.cla.cod_classe
         || w_sic.cod_cnae.cla.cod_subcla
         || w_sic.cod_cnae.ramo.cod_ramo
         || w_sic.cod_cnae.ramo.cod_subramo;
      w_mch.cod_fxa := 00;

      --- ANALISE DA CLASSE RESIDENCIAL
      IF w_sic.cod_cnae.cla.cod_classe = 'B'
      THEN                                               -- CLASSE RESIDENCIAL
         BEGIN
            w_mch.cod_atec :=
                  w_sic.cod_cnae.cla.cod_classe
               || w_sic.cod_cnae.cla.cod_subcla
               || '99';

		    IF L_BAIXA_RENDA THEN    /* MCH1BXR-inicio */
			   W_MCH.COD_GRP_TSTA := 10;
			   W_MCH.COD_ATEC     := W_MCH.COD_ATEC || '05'; 
			   --- CHAMADA ROTINA DE CALCULO DE FAIXAS
			   BEGIN
                  W_MCH.COD_FXA := CALCFAIXA(W_MCH.CON_FPTA + W_MCH.CON_PTA);
                  IF W_MCH.COD_FXA = 99 THEN
                     W_RET := '13' ;
                  END IF;
               EXCEPTION
               WHEN OTHERS THEN
                 W_RET := '17' ;
               END;
			ELSE                     /* MCH1BXR-fim    */   
               IF SUBSTR (w_sic.cod_tarifa, 1, 2) IN ('61', '92')
               THEN                                                    -- GRUPO-A
                  w_mch.cod_grp_tsta := 10;

                  --- CHAMADA ROTINA DE CALCULO DE FAIXAS
                  BEGIN
                     w_mch.cod_fxa := calcfaixa (w_mch.con_fpta + w_mch.con_pta);

                     IF w_mch.cod_fxa = 99
                     THEN
                        w_ret := '13';
                     END IF;
                  EXCEPTION
                  WHEN OTHERS
                  THEN
                     w_ret := '17';
                  END;
			   END IF;
            END IF; /* MCH1BXR */
         END;
      END IF;

      --- CHAMADA A ROTINA DE GRUPO CLASSE MERCADO
      BEGIN
         w_mch.cod_gclm :=
            classe_mercado (w_sic.cod_cnae.cla.cod_classe,
                            w_sic.cod_cnae.cla.cod_subcla
                           );

         IF w_mch.cod_gclm IS NULL
         THEN
            w_ret := '03';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            w_ret := '18';
      END;

      BEGIN
         w_mch.pot_insd := w_sic.carga_instal;
      EXCEPTION
         WHEN OTHERS
         THEN
            w_ret := '19';
      END;

--- mch2etp - inicio
--        W_MCH.DEM_CTDA_PTA    := 0 ;
--        W_MCH.DEM_CTDA_FPTA   := 0 ;
      BEGIN
         w_mch.dem_ctda_pta := w_sic.dem_ctda_pta;
      EXCEPTION
         WHEN OTHERS
         THEN
            w_ret := '20';
      END;

      BEGIN
         w_mch.dem_ctda_fpta := w_sic.dem_ctda_fpta;
      EXCEPTION
         WHEN OTHERS
         THEN
            w_ret := '21';
      END;

      w_mch.dat_ini_ctr := w_sic.data_inicio_fat;
      w_mch.dat_fatura := w_sic.data_fat;
      w_mch.tpo_can := w_sic.tip_mot_can;

--- mch2etp - fim

      --- ACUMULA TOTAIS
      IF w_mch.tip_fat = 'FAT'
      THEN
         g_con_tot_fat := g_con_tot_fat + w_mch.con_pta + w_mch.con_fpta;
         g_dem_tot_fat := g_dem_tot_fat + w_mch.dem_pta + w_mch.dem_fpta;
         g_dem_lda_tot_fat :=
                   g_dem_lda_tot_fat + w_mch.dem_lda_pta + w_mch.dem_lda_fpta;
         g_dem_ult_tot_fat :=
                   g_dem_ult_tot_fat + w_mch.dem_ult_pta + w_mch.dem_ult_fpta;
         g_dem_forn_tot_fat := g_dem_forn_tot_fat + w_mch.dem_forn;
         g_con_resv_tot_fat := g_con_resv_tot_fat + w_mch.con_resv;
      ELSIF w_mch.tip_fat = 'REF'
      THEN
         g_con_tot_ref := g_con_tot_ref + w_mch.con_pta + w_mch.con_fpta;
         g_dem_tot_ref := g_dem_tot_ref + w_mch.dem_pta + w_mch.dem_fpta;
         g_dem_lda_tot_ref :=
                   g_dem_lda_tot_ref + w_mch.dem_lda_pta + w_mch.dem_lda_fpta;
         g_dem_ult_tot_ref :=
                   g_dem_ult_tot_ref + w_mch.dem_ult_pta + w_mch.dem_ult_fpta;
         g_dem_forn_tot_ref := g_dem_forn_tot_ref + w_mch.dem_forn;
         g_con_resv_tot_ref := g_con_resv_tot_ref + w_mch.con_resv;
      ELSIF w_mch.tip_fat = 'CAN'
      THEN
         g_con_tot_can := g_con_tot_can + w_mch.con_pta + w_mch.con_fpta;
         g_dem_tot_can := g_dem_tot_can + w_mch.dem_pta + w_mch.dem_fpta;
         g_dem_lda_tot_can :=
                   g_dem_lda_tot_can + w_mch.dem_lda_pta + w_mch.dem_lda_fpta;
         g_dem_ult_tot_can :=
                   g_dem_ult_tot_can + w_mch.dem_ult_pta + w_mch.dem_ult_fpta;
         g_dem_forn_tot_can := g_dem_forn_tot_can + w_mch.dem_forn;
         g_con_resv_tot_can := g_con_resv_tot_can + w_mch.con_resv;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         w_ret := '14';
   END dadosmch;

   PROCEDURE grava_job_mensagem (texto IN VARCHAR2)
   IS
   BEGIN
      g_job_msg.num_linha := g_job_msg.num_linha + 1;

      INSERT INTO jobs_mensagens
                  (job, dat_ref, num_jub,
                   num_linha, mensagem
                  )
           VALUES (g_job_msg.job, g_job_msg.dat_ref, g_job_msg.num_jub,
                   g_job_msg.num_linha, texto
                  );
   --- UTL_FILE.PUT_LINE(G_LOG, 'JOB ' || G_JOB_MSG.JOB || ' DATA ' || G_JOB_MSG.DAT_REF || ' NUM JOB '  || G_JOB_MSG.NUM_JUB  || ' LINHA ' || G_JOB_MSG.NUM_LINHA );
   END grava_job_mensagem;

   PROCEDURE gravalog (texto IN VARCHAR2)
   IS
      w_dt   DATE := SYSDATE;
   BEGIN
      g_rlog :=
            TO_CHAR (w_dt, 'DD-MM-YYYY.HH24:MI:SS')
         || '--> '
         || SUBSTR (texto, 1, 100);
      UTL_FILE.PUT_LINE (g_log, g_rlog);
      grava_job_mensagem (g_rlog);

      IF LENGTH (texto) > 100
      THEN
         g_rlog :=
               TO_CHAR (w_dt, 'DD-MM-YYYY.HH24:MI:SS')
            || '--> '
            || SUBSTR (texto, 101, LENGTH (texto));
         UTL_FILE.PUT_LINE (g_log, g_rlog);
         grava_job_mensagem (g_rlog);
      END IF;
   END gravalog;

   PROCEDURE mensagem (w_num IN NUMBER, w_ret IN VARCHAR2)
   IS
      w_dt    DATE          := SYSDATE;
      w_msg   VARCHAR2 (80) := ' ';
   BEGIN
      w_dt := SYSDATE;

      IF w_ret = 'NO'
      THEN
         w_msg := 'NO - ERRO NA FORMATACAO DO DADO NO ARQUIVO SIC ';
      ELSIF w_ret = '01'
      THEN
         w_msg := '01 - DATA DIFERENTE DA DATA DE REFERENCIA INFORMADA ';
      ELSIF w_ret = '02'
      THEN
         w_msg := '02 - ERRO NA GRUPO TENSAO E TARIFA  ';
      ELSIF w_ret = '03'
      THEN
         w_msg := '03 - ERRO NO GRUPO DE CLASSE MERCADO ';
      ELSIF w_ret = '10'
      THEN
         w_msg := '10 - ERRO NO TAMANHO DO REGISTRO ';
      ELSIF w_ret = '11'
      THEN
         w_msg := '11 - ERRO NO CHAMADA A ROTINA ';
      ELSIF w_ret IN ('12', '05')
      THEN
         w_msg := '12 - ERRO NO CALCULO DA TARIFA ';
      ELSIF w_ret = '13'
      THEN
         w_msg := '13 - ERRO NO CALCULO DA FAIXA ';
      ELSIF w_ret = '14'
      THEN
         w_msg := '14 - ERRO GERAL NA ROTINA DE/PARA ';
      ELSIF w_ret = '15'
      THEN
         w_msg := '15 - ERRO AO VARRER CONCEITOS ';
      ELSIF w_ret = '16'
      THEN
         w_msg := '16 - ERRO NA CHAMADA DA ROTINA DE TARIFAS';
      ELSIF w_ret = '17'
      THEN
         w_msg := '17 - ERRO NA CHAMADA DA ROTINA DE FAIXAS ';
      ELSIF w_ret = '18'
      THEN
         w_msg := '18 - ERRO NA CHAMADA DA ROTINA DE GRUPO CLASSE MERCADO ';
      ELSIF w_ret = '19'
      THEN
         w_msg := '19 - ERRO NO VALOR DA CARGA INSTAL  ';
      --- mch2etp - inicio
      ELSIF w_ret = '20'
      THEN
         w_msg := '20 - ERRO NO VALOR DA DEMANDA CONTRATADA NA PONTA  ';
      ELSIF w_ret = '21'
      THEN
         w_msg := '21 - RRO NO VALOR DA DEMANDA CONTRATADA FORA PONTA  ';
      ELSIF w_ret = '22'
      THEN
         w_msg := '22 - ERRO NO CALCULO DO TIPO TARIFA ';
      ELSIF w_ret = '23'
      THEN
         w_msg := '23 - ERRO NO CHAMADA DA ROT. CALCULO DO TIPO TARIFA ';
      --- mch2etp - fim
      ELSE
         w_msg := w_ret || ' - ERRO NAO DESCONHECIDO ';
      END IF;

      g_rmsg :=
            TO_CHAR (w_dt, 'DD/MM/YYYY.HH24:MI:SS')
         || '-c:'
         || SUBSTR (g_rsic, 0003, 10)
         || '-N:'
         || SUBSTR (g_rsic, 0023, 26)
         || '('
         || TO_CHAR (w_num, '00000009')
         || ')=> '
         || w_msg;
      UTL_FILE.PUT_LINE (g_msg, g_rmsg);
   END mensagem;

   PROCEDURE disp2 (w_reg IN tmp_reg_mch%ROWTYPE)
   IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE (' W_REG.DAT_REF              ' || w_reg.dat_ref);
      DBMS_OUTPUT.PUT_LINE (' W_REG.TIP_FAT              ' || w_reg.tip_fat);
      DBMS_OUTPUT.PUT_LINE (' W_REG.COD_GRCO             ' || w_reg.cod_grco);
      DBMS_OUTPUT.PUT_LINE (' W_REG.COD_MUNI             ' || w_reg.cod_muni);
      DBMS_OUTPUT.PUT_LINE (' W_REG.COD_LOC              ' || w_reg.cod_loc);
      DBMS_OUTPUT.PUT_LINE (' W_REG.COD_BAIR             ' || w_reg.cod_bair);
      DBMS_OUTPUT.PUT_LINE (' W_REG.COD_ATEC             ' || w_reg.cod_atec);
      DBMS_OUTPUT.PUT_LINE (' W_REG.COD_FXA              ' || w_reg.cod_fxa);
      DBMS_OUTPUT.PUT_LINE (   ' W_REG.COD_GRP_TSTA         '
                            || w_reg.cod_grp_tsta
                           );
      DBMS_OUTPUT.PUT_LINE (' W_REG.COD_GCLM             ' || w_reg.cod_gclm);
      DBMS_OUTPUT.PUT_LINE (' W_REG.CON_PTA              ' || w_reg.con_pta);
      DBMS_OUTPUT.PUT_LINE (' W_REG.DEM_PTA              ' || w_reg.dem_pta);
      DBMS_OUTPUT.PUT_LINE (' W_REG.CON_FPTA             ' || w_reg.con_fpta);
      DBMS_OUTPUT.PUT_LINE (' W_REG.DEM_FPTA             ' || w_reg.dem_fpta);
      DBMS_OUTPUT.PUT_LINE (' W_REG.IMP_DEM              ' || w_reg.imp_dem);
      DBMS_OUTPUT.PUT_LINE (' W_REG.IMP_CON              ' || w_reg.imp_con);
      DBMS_OUTPUT.PUT_LINE (   ' W_REG.VAL_ECE              '
                            || TO_CHAR (w_reg.val_ece, '9999999999999.99')
                           );
      DBMS_OUTPUT.PUT_LINE (   ' W_REG.VAL_IUEE             '
                            || TO_CHAR (w_reg.val_iuee, '9999999999999.99')
                           );
      DBMS_OUTPUT.PUT_LINE (   ' W_REG.POT_INSD             '
                            || TO_CHAR (w_reg.pot_insd, '999999999')
                           );
      DBMS_OUTPUT.PUT_LINE (   ' W_REG.DEM_CTDA_PTA         '
                            || TO_CHAR (w_reg.dem_ctda_pta, '9999999')
                           );
      DBMS_OUTPUT.PUT_LINE (   ' W_REG.DEM_CTDA_FPTA        '
                            || TO_CHAR (w_reg.dem_ctda_fpta, '9999999')
                           );
   --    dbms_output.PUT_LINE( ' W_REG.IND_GRCO             ' ||  W_REG.IND_GRCO                );
   END disp2;

   PROCEDURE disp (w_reg IN VARCHAR2)
   IS
      i         BINARY_INTEGER;
      pulo      NUMBER (5);
      pordata   EXCEPTION;
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('W_SIC.TIP_RECTIF :' || SUBSTR (w_reg, 0001, 02));
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.TIP_RECTIF                    := '
                            || SUBSTR (w_reg, 0001, 02)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_CONTRATO                  := '
                            || SUBSTR (w_reg, 0003, 10)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.TIP_EST_CONTRATO              := '
                            || SUBSTR (w_reg, 0013, 02)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_CLIENTE                   := '
                            || SUBSTR (w_reg, 0015, 08)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.NUM_FACTURA                   := '
                            || SUBSTR (w_reg, 0023, 26)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.TIP_FACTURA                   := '
                            || SUBSTR (w_reg, 0049, 03)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.TIP_FACTRN_NOR                := '
                            || SUBSTR (w_reg, 0052, 02)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.P_SUMI.COD_PROVINCIA          := '
                            || SUBSTR (w_reg, 0054, 02)
                            || ' 99'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.P_SUMI.COD_POB.COD_MUN        := '
                            || SUBSTR (w_reg, 0056, 03)
                            || ' 999'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.P_SUMI.COD_POB.COD_LOC        := '
                            || SUBSTR (w_reg, 0059, 02)
                            || ' 99'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.P_SUMI.COD_POB.BAIRRO         := '
                            || SUBSTR (w_reg, 0061, 03)
                            || ' 999'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.P_SUMI.COD_CALLE              := '
                            || SUBSTR (w_reg, 0064, 05)
                            || ' 99999'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.P_SUMI.COD_FINCA              := '
                            || SUBSTR (w_reg, 0069, 04)
                            || ' 9999'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.P_SUMI.COD_PUNTO_SUMIN        := '
                            || SUBSTR (w_reg, 0073, 03)
                            || ' 999'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_ORG_INTER_OF              := '
                            || SUBSTR (w_reg, 0076, 03)
                            || ' 999'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_ORG_INTER_UT              := '
                            || SUBSTR (w_reg, 0079, 03)
                            || ' 999'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_ORG_INTER_UO              := '
                            || SUBSTR (w_reg, 0082, 03)
                            || ' 999'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_ORG_INTER_UR              := '
                            || SUBSTR (w_reg, 0085, 03)
                            || ' 999'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_CNAE.CLA.COD_CLASSE       := '
                            || SUBSTR (w_reg, 0088, 01)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_CNAE.CLA.COD_SUBCLA       := '
                            || SUBSTR (w_reg, 0089, 01)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_CNAE.RAMO.COD_RAMO        := '
                            || SUBSTR (w_reg, 0090, 02)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_CNAE.RAMO.COD_SUBRAMO     := '
                            || SUBSTR (w_reg, 0092, 02)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_TARIFA                    := '
                            || SUBSTR (w_reg, 0095, 04)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_TARIFA_DOU                := '
                            || SUBSTR (w_reg, 0099, 03)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.CARGA_INSTAL                  := '
                            || SUBSTR (w_reg, 0102, 09)
                            || ' 999999999'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.PERDA_TRANSF                  := '
                            || SUBSTR (w_reg, 0111, 05)
                            || ' 99999'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.COD_TENSION                   := '
                            || SUBSTR (w_reg, 0116, 02)
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.DATA_LEITURA_DE               := '
                            || SUBSTR (w_reg, 0118, 10)
                            || ' YYYY-MM-DD'
                           );
      DBMS_OUTPUT.PUT_LINE (   'W_SIC.DATA_LEITURA_ATE              := '
                            || SUBSTR (w_reg, 0128, 10)
                            || ' YYYY-MM-DD'
                           );
      i := 1;

      FOR i IN 1 .. 30
      LOOP
         pulo := 67 * (i - 1);
         DBMS_OUTPUT.PUT_LINE (   'W_CON(I).CONCEITO_ENERGIA    := '
                               || SUBSTR (w_reg, 0188 + pulo, 03)
                              );
         DBMS_OUTPUT.PUT_LINE (   'W_CON(I).CON_LIDO            := '
                               || SUBSTR (w_reg, 0191 + pulo, 12)
                               || ' S99999999999'
                              );
         DBMS_OUTPUT.PUT_LINE (   'W_CON(I).CON_FAT             := '
                               || SUBSTR (w_reg, 0203 + pulo, 12)
                               || ' S99999999999'
                              );
         DBMS_OUTPUT.PUT_LINE (   'W_CON(I).VAL_AJUSTE          := '
                               || SUBSTR (w_reg, 0215 + pulo, 12)
                               || ' S99999999999'
                              );
         DBMS_OUTPUT.PUT_LINE (   'W_CON(I).IMP_CONCEITO        := '
                               || SUBSTR (w_reg, 0227 + pulo, 14)
                               || ' S9999999999999'
                              );
         DBMS_OUTPUT.PUT_LINE (   'W_CON(I).IMP_BASE_ICMS       := '
                               || SUBSTR (w_reg, 0241 + pulo, 14)
                               || ' S9999999999999'
                              );
      END LOOP;
   END disp;

   PROCEDURE imprime_totais
   IS
   BEGIN
      Carga.gravalog (   ' QUANTIDADE DE REGISTROS LIDOS.... '
                      || TO_CHAR (g_reg_lidos, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANTIDADE DE REG. REJEITADOS.... '
                      || TO_CHAR (g_reg_rej, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANTIDADE DE REG. REJ. CONVERSAO '
                      || TO_CHAR (g_rej_conv, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE REG. GRAVADOS ......... '
                      || TO_CHAR (g_reg_grav, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. CONSUMIDORES FATURADOS ... '
                      || TO_CHAR (g_qtd_cons, '9999,999,999')
                     );
      Carga.gravalog (   ' CONSUMO TOTAL FATURADO .......... '
                      || TO_CHAR (g_con_tot_fat, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEMANDA TOTAL FATURADA .......... '
                      || TO_CHAR (g_dem_tot_fat, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' CONSUMO TOTAL CANCELADA ......... '
                      || TO_CHAR (g_con_tot_can, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEMANDA TOTAL CANCELADA ......... '
                      || TO_CHAR (g_dem_tot_can, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' CONSUMO TOTAL REFATURADO ........ '
                      || TO_CHAR (g_con_tot_ref, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEMANDA TOTAL REFATURADO ........ '
                      || TO_CHAR (g_dem_tot_ref, '999,999,999,999,999')
                     );
      --- mch2etp - inicio
      Carga.gravalog (   ' QTDE DE REG. TAR CONVENCIONAL ... '
                      || TO_CHAR (g_tar_con, '9999,999,999')
                     );
      Carga.gravalog (   ' QTDE DE REG. TAR HORO-AZUL    ... '
                      || TO_CHAR (g_tar_hza, '9999,999,999')
                     );
      Carga.gravalog (   ' QTDE DE REG. TAR HORO-VERDE   ... '
                      || TO_CHAR (g_tar_hzv, '9999,999,999')
                     );
      Carga.gravalog (   ' DEM LIDA   TOTAL FATURADA ....... '
                      || TO_CHAR (g_dem_lda_tot_fat, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEM ULTRA  TOTAL FATURADA ....... '
                      || TO_CHAR (g_dem_ult_tot_fat, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEM FORN   TOTAL FATURADA ....... '
                      || TO_CHAR (g_dem_forn_tot_fat, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' CON RESERV TOTAL FATURADA ....... '
                      || TO_CHAR (g_con_resv_tot_fat, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEM LIDA   TOTAL CANCELADA ...... '
                      || TO_CHAR (g_dem_lda_tot_can, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEM ULTRA  TOTAL CANCELADA ...... '
                      || TO_CHAR (g_dem_ult_tot_can, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEM FORN   TOTAL CANCELADA ...... '
                      || TO_CHAR (g_dem_forn_tot_can, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' CON RESERV TOTAL CANCELADA ...... '
                      || TO_CHAR (g_con_resv_tot_can, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEM LIDA   TOTAL REFATURADA ..... '
                      || TO_CHAR (g_dem_lda_tot_ref, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEM ULTRA  TOTAL REFATURADA ..... '
                      || TO_CHAR (g_dem_ult_tot_ref, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEM FORN   TOTAL REFATURADA ..... '
                      || TO_CHAR (g_dem_forn_tot_ref, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' CON RESERV TOTAL REFATURADA ..... '
                      || TO_CHAR (g_con_resv_tot_ref, '999,999,999,999,999')
                     );
   END imprime_totais;

   PROCEDURE carga_inicial (data_ref IN DATE, nome_job IN VARCHAR2)
   IS
      -- VARIAVEIS
      dt_ref    DATE;
      i         BINARY_INTEGER;
      w_sic     t_reg_sic;
      w_con     t_con;
      w_mch     tmp_reg_mch%ROWTYPE;
      w_ret     VARCHAR2 (02)         := '  ';
      exdata    EXCEPTION;
      mes_ref   VARCHAR2 (7);
      numjob    BINARY_INTEGER;
   BEGIN
      -- PARAMETROS DO SISTEMA
      parametros (g_param);
      dados_job (nome_job, g_job);
      inicializa_mensagem (g_job, g_job_msg);
      dt_ref := data_ref;
      mes_ref := TO_CHAR (data_ref, 'MONYYYY');
      g_reg_lidos := 0;
      g_reg_rej := 0;
      g_rej_conv := 0;
      g_reg_held := 0;
      g_reg_grav := 0;
      g_rej_data := 0;
      g_qtd_cons := 0;
      g_con_tot_fat := 0;
      g_dem_tot_fat := 0;
      g_con_tot_can := 0;
      g_dem_tot_can := 0;
      g_con_tot_ref := 0;
      g_dem_tot_ref := 0;
      --- mch2etp - inicio
      g_dem_lda_tot_fat := 0;
      g_dem_ult_tot_fat := 0;
      g_dem_forn_tot_fat := 0;
      g_con_resv_tot_fat := 0;
      g_dem_lda_tot_ref := 0;
      g_dem_ult_tot_ref := 0;
      g_dem_forn_tot_ref := 0;
      g_con_resv_tot_ref := 0;
      g_dem_lda_tot_can := 0;
      g_dem_ult_tot_can := 0;
      g_dem_forn_tot_can := 0;
      g_con_resv_tot_can := 0;
      --- mch2etp - fim
      g_cod_grco_ant := ' ';
      -- FORMATA NOME DOS ARQUIVOS
      g_nome_arq :=
         LOWER (TRIM (g_param.des_empresa)) || '_' || LOWER (mes_ref)
         || '.txt';
      g_nome_log :=
            LOWER (TRIM (g_param.des_empresa))
         || '_'
         || LOWER (mes_ref)
         || '_log.txt';
      g_nome_bad :=
            LOWER (TRIM (g_param.des_empresa))
         || '_'
         || LOWER (mes_ref)
         || '_bad_'
         || TO_CHAR (SYSDATE, 'DDMMYYYY_HHMISS')
         || '.txt';
      g_nome_msg :=
            LOWER (TRIM (g_param.des_empresa))
         || '_'
         || LOWER (mes_ref)
         || '_msg_'
         || TO_CHAR (SYSDATE, 'DDMMYYYY_HHMISS')
         || '.txt';

      -- ABERTURA DO ARQUIVO DO SIC
      BEGIN
         g_arq := UTL_FILE.FOPEN (g_dir_ent, g_nome_arq, 'r', g_tam_sic);
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO ABRIR O ARQUIVO DO SIC');
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.PUT_LINE (g_dir_ent || g_nome_arq);
            RAISE_APPLICATION_ERROR
                          (-20000,
                              'ERRO DESCONHECIDO AO ABRIR O ARQUIVO DO SIC :'
                           || g_dir_ent
                           || g_nome_arq
                          );
      END;

      -- ABERTURA DO ARQUIVO DE LOG
      BEGIN
         g_log := UTL_FILE.FOPEN (g_dir_sai, g_nome_log, 'a');
         g_bad := UTL_FILE.FOPEN (g_dir_sai, g_nome_bad, 'a', g_tam_sic);
         g_msg := UTL_FILE.FOPEN (g_dir_sai, g_nome_msg, 'a');
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO ABRIR O ARQUIVO DE LOG');
      END;

      Carga.gravalog
                  ('*** ---------------- INICIO DA CARGA ----------------*** ');
      inicializa_area;
      Carga.gravalog ('***   C A R G A    C O M   O   T R U N C A T E   ***');
      --CARGA.GRAVALOG('***   C A R G A    S E M   O   T R U N C A T E   ***');

      -- CARREGA RTABELA DE FAIXAS
      carrega_faixas (g_fxa);
      -- CARREGA TABELA DE FAIXAS DE TENSAO/TARIFA
      carrega_faixas_grte (g_fxa_grte);

      -- Primeira leitura
      BEGIN
         UTL_FILE.GET_LINE (g_arq, g_rsic);
      EXCEPTION
         WHEN UTL_FILE.READ_ERROR
         THEN
            UTL_FILE.FCLOSE_ALL;
            RAISE_APPLICATION_ERROR (-20000, 'ERRO AO LER O ARQUIVO DO SIC');
         WHEN NO_DATA_FOUND
         THEN
            UTL_FILE.FCLOSE_ALL;
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO LER O ARQUIVO DO SIC(vazio)'
                                    );
         WHEN VALUE_ERROR
         THEN
            UTL_FILE.FCLOSE_ALL;
            RAISE_APPLICATION_ERROR
                              (-20000,
                               'ERRO AO LER O ARQUIVO DO SIC(VALOR INVALIDO)'
                              );
      END;

      g_reg_lidos := g_reg_lidos + 1;
      -- LOOP DE LEITURA DO SIC
      g_fim_sic := FALSE;

      WHILE NOT g_fim_sic
      LOOP
         --   DISP(  G_RSIC ) ;
         IF LENGTH (g_rsic) = 2199
         THEN
            -- TRANSFORMA STRING EM RECORD (SIC)
            BEGIN
               w_sic := NULL;
               w_con.DELETE;
               transforma (w_ret, g_rsic, w_sic, w_con);
            EXCEPTION
               WHEN OTHERS
               THEN
                  UTL_FILE.FCLOSE_ALL;
                  RAISE_APPLICATION_ERROR
                           (-20000,
                            'ERRO AO TRATAR O ARQUIVO DO SIC(VALOR INVALIDO)'
                           );
            END;

            IF w_ret <> 'OK'
            THEN
               UTL_FILE.PUT_LINE (g_bad, g_rsic);
               g_reg_rej := g_reg_rej + 1;
               mensagem (g_reg_lidos, w_ret);
            ELSE
               --- DE/PARA SIC ==> MERCADO
               BEGIN
                  w_mch := NULL;
                  dadosmch (dt_ref, w_ret, w_sic, w_con, w_mch);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     UTL_FILE.FCLOSE_ALL;
                     RAISE_APPLICATION_ERROR
                                  (-20000,
                                   'ERRO AO TRATAR O ARQUIVO DO SIC(DE/PARA)'
                                  );
               END;

               IF w_ret <> 'OK'
               THEN
                  IF w_ret = '01'
                  THEN                                        -- ERRO DE DATA
                     g_rej_data := g_rej_data + 1;

                     IF g_rej_data > 2000
                     THEN
                        RAISE exdata;
                     END IF;
                  END IF;

                  UTL_FILE.PUT_LINE (g_bad, g_rsic);
                  g_reg_rej := g_reg_rej + 1;
                  g_rej_conv := g_rej_conv + 1;
                  mensagem (g_reg_lidos, w_ret);
               ELSE
                  -- DISP2(W_MCH);
                  grava_area (w_mch);
               END IF;
            END IF;
         ELSE                                           -- REJEITA POR TAMANHO
            UTL_FILE.PUT_LINE (g_bad, g_rsic);
            g_reg_rej := g_reg_rej + 1;
            mensagem (g_reg_lidos, '10');
         END IF;

         BEGIN
            UTL_FILE.GET_LINE (g_arq, g_rsic);
            g_reg_lidos := g_reg_lidos + 1;
         EXCEPTION
            WHEN UTL_FILE.READ_ERROR
            THEN
               UTL_FILE.FCLOSE_ALL;
               RAISE_APPLICATION_ERROR (-20000,
                                        'ERRO AO LER O ARQUIVO DO SIC'
                                       );
            WHEN NO_DATA_FOUND
            THEN
               g_fim_sic := TRUE;
            WHEN VALUE_ERROR
            THEN
               UTL_FILE.FCLOSE_ALL;
               RAISE_APPLICATION_ERROR
                              (-20000,
                               'ERRO AO LER O ARQUIVO DO SIC(VALOR INVALIDO)'
                              );
            WHEN OTHERS
            THEN
               UTL_FILE.FCLOSE_ALL;
               RAISE_APPLICATION_ERROR
                  (-20000,
                   'ERRO DESCONHECIDO AO LER O ARQUIVO DO SIC(VALOR INVALIDO)'
                  );
         END;
      END LOOP;

      finaliza_area;
      finaliza_job;
      imprime_totais;
      Carga.gravalog
                   ('*** ---------------- FINAL DA CARGA ----------------*** ');
      UTL_FILE.FCLOSE (g_arq);
      UTL_FILE.FCLOSE (g_log);
      UTL_FILE.FCLOSE (g_bad);
      UTL_FILE.FCLOSE (g_msg);
   EXCEPTION
      WHEN exdata
      THEN
         imprime_totais;
         Carga.gravalog
                  ('*** ------ ARQUIVO DEVE SER PARA OUTO MES REF  -----*** ');
         Carga.gravalog
                  ('*** ---------------- ERRO NA  CARGA ----------------*** ');
         UTL_FILE.FCLOSE_ALL;
   /*   WHEN others  THEN
        dbms_output.PUT_LINE( SQLERRM  );
        CARGA.GRAVALOG(' QUANTIDADE DE REGISTROS LIDOS.... ' || TO_CHAR(G_REG_LIDOS,'9999,999,999')) ;
        CARGA.GRAVALOG(' QUANTIDADE DE REG. REJEITADOS.... ' || TO_CHAR(G_REG_REJ,'9999,999,999')) ;
        CARGA.GRAVALOG(' QUANTIDADE DE REG. REJ. CONVERSAO ' || TO_CHAR(G_REJ_CONV,'9999,999,999')) ;
        CARGA.GRAVALOG(' QUANT. DE REG. GRAV ATE O MOMENTO ' || TO_CHAR(G_REG_GRAV,'9999,999,999')) ;
        CARGA.GRAVALOG(' QUANT. CONSUMIDORES FATURADOS ... ' || TO_CHAR(G_QTD_CONS,'9999,999,999')) ;
        CARGA.GRAVALOG(' CONSUMO TOTAL FATURADO .......... ' || TO_CHAR(G_CON_TOT_FAT,'999,999,999,999,999'));
        CARGA.GRAVALOG(' DEMANDA TOTAL FATURADA .......... ' || TO_CHAR(G_DEM_TOT_FAT,'999,999,999,999,999'));
        CARGA.GRAVALOG(' CONSUMO TOTAL CANCELADA ......... ' || TO_CHAR(G_CON_TOT_CAN,'999,999,999,999,999'));
        CARGA.GRAVALOG(' DEMANDA TOTAL CANCELADA ......... ' || TO_CHAR(G_DEM_TOT_CAN,'999,999,999,999,999'));
        CARGA.GRAVALOG(' CONSUMO TOTAL REFATURADO ........ ' || TO_CHAR(G_CON_TOT_REF,'999,999,999,999,999'));
        CARGA.GRAVALOG(' DEMANDA TOTAL REFATURADO ........ ' || TO_CHAR(G_DEM_TOT_REF,'999,999,999,999,999'));

        CARGA.GRAVALOG(' erro : ' || SQLERRM ) ;
        DISP(  G_RSIC );
        DISP2(W_MCH);
        CARGA.GRAVALOG('*** ---------------- ERRO NA  CARGA ----------------*** ' ) ;
        UTL_FILE.fclose_all;       */
   END carga_inicial;

   PROCEDURE cria_indices (data_ref IN DATE, nome_job IN VARCHAR2)
   IS
      numjob          BINARY_INTEGER;
      ja_existe_ind   EXCEPTION;
      PRAGMA EXCEPTION_INIT (ja_existe_ind, -00955);
   BEGIN
      -- PARAMETROS DO SISTEMA
      parametros (g_param);
      dados_job (nome_job, g_job);
      inicializa_mensagem (g_job, g_job_msg);
      g_nome_log :=
            LOWER (TRIM (g_param.des_empresa))
         || '_'
         || LOWER (TO_CHAR (data_ref, 'MONYYYY'))
         || '_log_CRIA_INDICES.txt';

      -- ABERTURA DO ARQUIVO DE LOG
      BEGIN
         g_log := UTL_FILE.FOPEN (g_dir_sai, g_nome_log, 'a');
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO ABRIR O ARQUIVO DE LOG');
      END;

      Carga.gravalog
                 ('*** ---------- INICIO DA CRIACAO DE INDICES ----------*** ');
      Carga.gravalog
          ('*** ---------- CRIA INDICE PARA GRANDES CONSUMIDORES --------*** ');

      BEGIN
         /*
         -- Alterado por : Renato Pires
         -- Data         : 05/09/2003
         -- Motivo       : Por solicitação do DBA ( Antonio ), o banco já faz
         --                o gerenciamento do INITIAL e do NEXT
         EXECUTE IMMEDIATE  'CREATE INDEX IN1_TMP_GRCO ON '                   ||
                         'TMP_REG_MCH(IND_GRCO , TIP_FAT, DAT_REF, COD_GRCO ) ' ||
                         'TABLESPACE MCHTS01I PCTFREE 10 '                      ||
                         'STORAGE(INITIAL 10240K NEXT 8192K PCTINCREASE 0 ) ' ;
         */
         EXECUTE IMMEDIATE    'CREATE INDEX IN1_TMP_GRCO ON '
                           || 'TMP_REG_MCH(IND_GRCO , TIP_FAT, DAT_REF, COD_GRCO ) '
                           || 'TABLESPACE MCHTSL01I PCTFREE 10 ';
      EXCEPTION
         WHEN ja_existe_ind
         THEN
            Carga.gravalog
               ('*** ---- INDICE PARA GRANDES CONSUMIDORES JA EXISTE ----*** '
               );
      END;

      Carga.gravalog
           ('*** ---------- CRIA INDICE PARA LOCALIDADE E MUNICIPIO -----*** ');

      BEGIN
         /*
         -- Alterado por : Renato Pires
         -- Data         : 05/09/2003
         -- Motivo       : Por solicitação do DBA ( Antonio ), o banco já faz
         --                o gerenciamento do INITIAL e do NEXT
           EXECUTE IMMEDIATE 'CREATE INDEX IN1_TMP_LOC ON '                                     ||
                        'TMP_REG_MCH(TIP_FAT, DAT_REF, COD_MUNI, COD_LOC, COD_BAIR, COD_GCLM) ' ||
                        'TABLESPACE MCHTS01I PCTFREE 10 '                                       ||
                        'STORAGE(INITIAL 12288K NEXT 12288K PCTINCREASE 0 ) ' ;
         */
         EXECUTE IMMEDIATE    'CREATE INDEX IN1_TMP_LOC ON '
                           || 'TMP_REG_MCH(TIP_FAT, DAT_REF, COD_MUNI, COD_LOC, COD_BAIR, COD_GCLM) '
                           || 'TABLESPACE MCHTSL01I PCTFREE 10 ';
      EXCEPTION
         WHEN ja_existe_ind
         THEN
            Carga.gravalog
               ('*** ---- INDICE PARA LOCALIDADE E MUNICIPIO JA EXISTE ----*** '
               );
      END;

      Carga.gravalog
                  ('*** ---------- CRIA INDICE PARA MERCADO GLOBAL  -----*** ');

      BEGIN
         /*
         -- Alterado por : Renato Pires
         -- Data         : 05/09/2003
         -- Motivo       : Por solicitação do DBA ( Antonio ), o banco já faz
         --                o gerenciamento do INITIAL e do NEXT
           EXECUTE IMMEDIATE 'CREATE INDEX IN1_TMP_MGB ON '                               ||
                        'TMP_REG_MCH(TIP_FAT, DAT_REF, COD_MUNI, COD_ATEC, COD_FXA, COD_GRP_TSTA) ' ||
                        'TABLESPACE MCHTS01I PCTFREE 10 '                                 ||
                        'STORAGE(INITIAL 12288K NEXT 12288K PCTINCREASE 0 )  ' ;
         */
         EXECUTE IMMEDIATE    'CREATE INDEX IN1_TMP_MGB ON '
                           || 'TMP_REG_MCH(TIP_FAT, DAT_REF, COD_MUNI, COD_ATEC, COD_FXA, COD_GRP_TSTA) '
                           || 'TABLESPACE MCHTSL01I PCTFREE 10 ';
      EXCEPTION
         WHEN ja_existe_ind
         THEN
            Carga.gravalog
                    ('*** ---- INDICE PARA MERCADO GLOBAL JA EXISTE ----*** ');
      END;

      finaliza_job;
      Carga.gravalog
                 ('*** ---------- FINAL DA CRIACAO DE INDICES  ----------*** ');
      UTL_FILE.FCLOSE (g_log);
   EXCEPTION
      WHEN OTHERS
      THEN
         Carga.gravalog (' erro : ' || SQLERRM);
         Carga.gravalog
                    ('*** ----------- ERRO NA  CRIACAO DE INDICES  -----*** ');
         UTL_FILE.FCLOSE_ALL;
   END cria_indices;

   PROCEDURE atualiza_views (data_ref IN DATE, nome_job IN VARCHAR2)
   IS
   BEGIN
      -- PARAMETROS DO SISTEMA
      parametros (g_param);
      dados_job (nome_job, g_job);
      inicializa_mensagem (g_job, g_job_msg);
      g_nome_log :=
            LOWER (TRIM (g_param.des_empresa))
         || '_'
         || LOWER (TO_CHAR (data_ref, 'MONYYYY'))
         || '_log_CRIAVIEWS.txt';

      -- ABERTURA DO ARQUIVO DE LOG
      BEGIN
         g_log := UTL_FILE.FOPEN (g_dir_sai, g_nome_log, 'a');
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO ABRIR O ARQUIVO DE LOG');
      END;

      Carga.gravalog
              ('*** ---------- INICIO DA ATUALIZACAO DAS VIEWS ----------*** ');
      Carga.gravalog
             ('*** ---------- ATUALIZACAO DA VIEW VM_TMP_GRCO  ----------*** ');
      DBMS_SNAPSHOT.REFRESH ('MCH.VM_TMP_GRCO');
      Carga.gravalog
             ('*** ---------- ATUALIZACAO DA VIEW VM_TMP_HMGB  ----------*** ');
      DBMS_SNAPSHOT.REFRESH ('MCH.VM_TMP_HMGB');
      Carga.gravalog
              ('*** ---------- ATUALIZACAO DA VIEW VM_TMP_LOC  ----------*** ');
      DBMS_SNAPSHOT.REFRESH ('MCH.VM_TMP_LOC');
      Carga.gravalog
             ('*** ---------- ATUALIZACAO DA VIEW VM_TMP_MUNI  ----------*** ');
      DBMS_SNAPSHOT.REFRESH ('MCH.VM_TMP_MUNI');
      Carga.gravalog
               ('*** ---------- FINAL DA ATUALIZACAO DAS VIEWS ----------*** ');
      finaliza_job;
      UTL_FILE.FCLOSE (g_log);
   EXCEPTION
      WHEN OTHERS
      THEN
         Carga.gravalog (' erro : ' || SQLERRM);
         Carga.gravalog
                   ('*** ----------- ERRO NA  ATULIZACAO DAS VIEWS -----*** ');
         UTL_FILE.FCLOSE_ALL;
   END atualiza_views;

   PROCEDURE carga_hist_mercado (data_ref IN DATE, nome_job IN VARCHAR2)
   IS
      i                  BINARY_INTEGER;
      w_hmgb             vm_tmp_hmgb%ROWTYPE;
      w_cod_muni         vm_tmp_hmgb.cod_muni%TYPE;
      w_cod_atec         vm_tmp_hmgb.cod_atec%TYPE;
      w_cod_fxa          vm_tmp_hmgb.cod_fxa%TYPE;
      w_cod_grp_tsta     vm_tmp_hmgb.cod_grp_tsta%TYPE;
      w_existe_classe    BOOLEAN;
      --- ACUMULADORES
      w_qtd_inc_classe   NUMBER                          := 0;
      w_qtd_reg_lidos    NUMBER                          := 0;
      w_qtd_rej_classe   NUMBER                          := 0;
      w_qtd_exi_classe   NUMBER                          := 0;
      w_qtd_inc_hist     NUMBER                          := 0;
      w_qtd_rej_hist     NUMBER                          := 0;

      --- CURSORES
      CURSOR c_tmp_hmgb
      IS
         SELECT *
           FROM vm_tmp_hmgb;

      --- ROTINAS INTERNAS
      PROCEDURE grava_mensagem (
         erro   IN   VARCHAR,
         code   IN   NUMBER,
         mess   IN   VARCHAR
      )
      IS
      BEGIN
         INSERT INTO tmp_hmgb_bad
                     (cod_muni, cod_atec, cod_fxa,
                      cod_grp_tsta, cod_erro, code, errm
                     )
              VALUES (w_hmgb.cod_muni, w_hmgb.cod_atec, w_hmgb.cod_fxa,
                      w_hmgb.cod_grp_tsta, erro, code, mess
                     );
      END grava_mensagem;
   BEGIN
      -- PARAMETROS DO SISTEMA
      parametros (g_param);
      dados_job (nome_job, g_job);
      inicializa_mensagem (g_job, g_job_msg);
      i := 0;
      g_nome_log :=
            LOWER (TRIM (g_param.des_empresa))
         || '_'
         || LOWER (TO_CHAR (data_ref, 'MONYYYY'))
         || '_log_CARGA_HIST_MERCADO.txt';

      -- ABERTURA DO ARQUIVO DE LOG
      BEGIN
         g_log := UTL_FILE.FOPEN (g_dir_sai, g_nome_log, 'a');
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO ABRIR O ARQUIVO DE LOG');
      END;

      Carga.gravalog
                 ('*** ---------- INICIO DA CARGA HIST MERCADO ----------*** ');
      Carga.gravalog
               ('*** ---------- LIMPA A TABELA DE ERROS  ----------------*** ');

      EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_HMGB_BAD';

      Carga.gravalog
                 ('*** ---------- ATUALIZACAO HISTORICO FATURADO  -------*** ');

      --- CARREGA FATURAMENTO
      FOR r_hmgb IN c_tmp_hmgb
      LOOP
         w_qtd_reg_lidos := w_qtd_reg_lidos + 1;
         w_hmgb := r_hmgb;
         --- VERIFICA CLASSE MERCADO
         w_existe_classe := TRUE;

         BEGIN
            SELECT cod_muni, cod_atec, cod_fxa, cod_grp_tsta
              INTO w_cod_muni, w_cod_atec, w_cod_fxa, w_cod_grp_tsta
              FROM mercado_global_conces
             WHERE cod_muni = r_hmgb.cod_muni
               AND cod_atec = r_hmgb.cod_atec
               AND cod_fxa = r_hmgb.cod_fxa
               AND cod_grp_tsta = r_hmgb.cod_grp_tsta;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         --- INCLUI CLASSE MERCADO
         IF SQL%NOTFOUND
         THEN
            BEGIN
               INSERT INTO mercado_global_conces
                           (cod_muni, cod_atec,
                            cod_fxa, cod_grp_tsta
                           )
                    VALUES (r_hmgb.cod_muni, r_hmgb.cod_atec,
                            r_hmgb.cod_fxa, r_hmgb.cod_grp_tsta
                           );

               w_qtd_inc_classe := w_qtd_inc_classe + 1;
            -- CARGA.GRAVALOG('MUNI: ' || TO_CHAR(R_HMGB.COD_MUNI,'000') || '  CLASSE INCLUIDA ' || R_HMGB.COD_ATEC || TO_CHAR(R_HMGB.COD_FXA,'00')  || TO_CHAR(R_HMGB.COD_GRP_TSTA,'00') ) ;
            EXCEPTION
               WHEN OTHERS
               THEN
                  w_existe_classe := FALSE;
                  w_qtd_rej_classe := w_qtd_rej_classe + 1;
                  grava_mensagem ('GMCH0001', SQLCODE, SQLERRM);
            END;
         ELSE
            w_qtd_exi_classe := w_qtd_exi_classe + 1;
         END IF;

         --- INCLUI HISTORICO MERCADO
         --- mch2etp ( inclusao do novos campos DEM_ULT_PTA , DEM_ULT_FPTA , DEM_FORN )
         IF w_existe_classe
         THEN
            BEGIN
               INSERT INTO hist_mercado_global_conces
                           (cod_muni, cod_atec,
                            cod_fxa, cod_grp_tsta, dat_hmgb,
                            qtd_cons, con_pta, dem_pta,
                            con_fpta, dem_fpta,
                            imp_dem, imp_con, val_ece,
                            val_iuee, dem_ult_pta,
                            dem_ult_fpta, dem_forn
                           )
                    VALUES (r_hmgb.cod_muni, r_hmgb.cod_atec,
                            r_hmgb.cod_fxa, r_hmgb.cod_grp_tsta, data_ref,
                            r_hmgb.qtd_cons, r_hmgb.con_pta, r_hmgb.dem_pta,
                            r_hmgb.con_fpta, r_hmgb.dem_fpta,
                            r_hmgb.imp_dem, r_hmgb.imp_con, r_hmgb.val_ece,
                            r_hmgb.val_iuee, r_hmgb.dem_ult_pta,
                            r_hmgb.dem_ult_fpta, r_hmgb.dem_forn
                           );

               --    CARGA.GRAVALOG(' CLASSE HIST INCLUIDA ' || R_HMGB.COD_ATEC || TO_CHAR(R_HMGB.COD_FXA,'00')  || TO_CHAR(R_HMGB.COD_GRP_TSTA,'00') ) ;
               w_qtd_inc_hist := w_qtd_inc_hist + 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  w_qtd_rej_hist := w_qtd_rej_hist + 1;
                  grava_mensagem ('GMCH0001', SQLCODE, SQLERRM);
            END;
         END IF;
      END LOOP;

      --- FINALIZA ATUALIZACAO DO HISTORICO MERCADO GLOBAL
      IF g_param.atualiza = 'SIM'
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
      END IF;

      finaliza_job;
      ---- FINALIZA PROCESSO
      Carga.gravalog (   ' QUANTIDADE DE REGISTROS LIDOS.... '
                      || TO_CHAR (w_qtd_reg_lidos, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANTIDADE CLASSE MERC INCLUIDAS. '
                      || TO_CHAR (w_qtd_inc_classe, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANTIDADE CLASSE MERC REJEITADOS '
                      || TO_CHAR (w_qtd_rej_classe, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT    CLASSE MERC JA EXISTENTE '
                      || TO_CHAR (w_qtd_exi_classe, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANTIDADE HIST.  MERC INCLUIDAS. '
                      || TO_CHAR (w_qtd_inc_hist, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANTIDADE HIST.  MERC REJEITADOS '
                      || TO_CHAR (w_qtd_rej_hist, '9999,999,999')
                     );

      IF g_param.atualiza = 'SIM'
      THEN
         Carga.gravalog
                  ('*** ---------------- FINAL DA CARGA ----------------*** ');
      ELSE
         Carga.gravalog
                  ('*** -------- FINAL DA CARGA SEM ATUALIZACAO --------*** ');
      END IF;

      UTL_FILE.FCLOSE (g_log);
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         Carga.gravalog
                ('*** -------- ATE O MOMENTO FORAM PROCESSADOS  --------*** ');
         Carga.gravalog (   ' QUANTIDADE DE REGISTROS LIDOS.... '
                         || TO_CHAR (w_qtd_reg_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE CLASSE MERC INCLUIDAS. '
                         || TO_CHAR (w_qtd_inc_classe, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE CLASSE MERC REJEITADOS '
                         || TO_CHAR (w_qtd_rej_classe, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT    CLASSE MERC JA EXISTENTE '
                         || TO_CHAR (w_qtd_exi_classe, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE HIST.  MERC INCLUIDAS. '
                         || TO_CHAR (w_qtd_inc_hist, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE HIST.  MERC REJEITADOS '
                         || TO_CHAR (w_qtd_rej_hist, '9999,999,999')
                        );
         Carga.gravalog (' erro : ' || SQLERRM);
         Carga.gravalog
                    ('*** ---------------- ERRO NA CARGA ----------------*** ');
         UTL_FILE.FCLOSE_ALL;
   END carga_hist_mercado;

   PROCEDURE carga_hist_grco (data_ref IN DATE, nome_job IN VARCHAR2)
   IS
      i                    BINARY_INTEGER;
      --  R_GRCO         VM_TMP_GRCO%ROWTYPE;
      r_grco_atu           grandes_consumidores%ROWTYPE;
      r_ctre_atu           contratos_especiais%ROWTYPE;
      r_escn_atu           escalonamentos%ROWTYPE;
      w_num_ctre           contratos_especiais.num_ctre%TYPE;
      w_cod_grco           vm_tmp_grco.cod_grco%TYPE;
      w_existe_grco        BOOLEAN;
      w_existe_ctre        BOOLEAN;
      w_existe_escn        BOOLEAN;
      --- ACUMULADORES
      w_qtd_inc            NUMBER                              := 0;
      w_qtd_alt            NUMBER                              := 0;
      w_qtd_fat_lidos      NUMBER                              := 0;
      w_qtd_can_lidos      NUMBER                              := 0;
      w_qtd_ref_lidos      NUMBER                              := 0;
      w_qtd_ctre_inc       NUMBER                              := 0;
      w_qtd_ctre_exi       NUMBER                              := 0;
      w_qtd_escn_exi       NUMBER                              := 0;
      w_qtd_escn_inc       NUMBER                              := 0;
      w_qtd_escn_alt       NUMBER                              := 0;
      w_qtd_ctre_rej       NUMBER                              := 0;
      w_qtd_escn_rej_inc   NUMBER                              := 0;
      w_qtd_escn_rej_alt   NUMBER                              := 0;
      w_qtd_rej_fat        NUMBER                              := 0;
      w_qtd_inc_hist_fat   NUMBER                              := 0;
      w_qtd_rej_hist_fat   NUMBER                              := 0;
      w_qtd_alt_hist_fat   NUMBER                              := 0;
      w_qtd_inc_hist_ref   NUMBER                              := 0;
      w_qtd_rej_hist_ref   NUMBER                              := 0;
      w_qtd_inc_hist_can   NUMBER                              := 0;
      w_qtd_rej_hist_can   NUMBER                              := 0;

      --- CURSORES
      CURSOR c_grco_fat
      IS
         SELECT *
           FROM vm_tmp_grco
          WHERE tip_fat = 'FAT';

      CURSOR c_grco_ref
      IS
         SELECT *
           FROM vm_tmp_grco
          WHERE tip_fat = 'REF';

      CURSOR c_grco_can
      IS
         SELECT *
           FROM vm_tmp_grco
          WHERE tip_fat = 'CAN';

      --- ROTINAS INTERNAS
      PROCEDURE grava_mensagem (
         r_grco   IN   vm_tmp_grco%ROWTYPE,
         erro     IN   VARCHAR,
         cod      IN   NUMBER,
         mess     IN   VARCHAR
      )
      IS
      BEGIN
         INSERT INTO tmp_grco_bad
                     (tip_fat, dat_ref, cod_grco, cod_erro,
                      code, errm
                     )
              VALUES (r_grco.tip_fat, r_grco.dat_ref, r_grco.cod_grco, erro,
                      cod, mess
                     );
      END grava_mensagem;

      PROCEDURE trata_contrato_especial (r_grco IN vm_tmp_grco%ROWTYPE)
      IS
      BEGIN
         w_existe_ctre := TRUE;

         BEGIN
            SELECT *
              INTO r_ctre_atu
              FROM contratos_especiais
             WHERE cod_grco = r_grco.cod_grco;

            w_qtd_ctre_exi := w_qtd_ctre_exi + 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               w_existe_ctre := FALSE;
         END;

         --- INCLUSÃO DO CONTRATO ESPECIAL
         IF NOT w_existe_ctre
         THEN
            BEGIN
               w_num_ctre := w_num_ctre + 1;

               BEGIN
                  r_ctre_atu.cod_grco := r_grco.cod_grco;
                  r_ctre_atu.num_ctre := w_num_ctre;

                  INSERT INTO contratos_especiais
                              (cod_grco, num_ctre
                              )
                       VALUES (r_ctre_atu.cod_grco, r_ctre_atu.num_ctre
                              );

                  w_qtd_ctre_inc := w_qtd_ctre_inc + 1;
                  w_existe_ctre := TRUE;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     w_qtd_ctre_rej := w_qtd_ctre_rej + 1;
                     grava_mensagem (r_grco, 'GMCH0008', SQLCODE, SQLERRM);
                     --   CARGA.GRAVALOG(' CONTRATO ESPECIAL REJEITADO_FAT ' || R_GRCO.COD_GRCO || ' NUM ' || R_CTRE_ATU.NUM_CTRE ) ;
                     w_num_ctre := w_num_ctre - 1;
               END;
            END;
         END IF;

         --- INCLUSAO DO ESCALONAMENTO
         IF w_existe_ctre
         THEN
            BEGIN
               w_existe_escn := TRUE;

               BEGIN
                  SELECT *
                    INTO r_escn_atu
                    FROM escalonamentos
                   WHERE num_contr_ces = r_ctre_atu.num_ctre
                     AND dat_inic = r_grco.dat_ini_ctr;

                  w_qtd_escn_exi := w_qtd_escn_exi + 1;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     w_existe_escn := FALSE;
               END;

               IF NOT w_existe_escn
               THEN
                  --- INSERE NOVO ESCALONAMENTO
                  BEGIN
                     r_escn_atu.dat_inic := r_grco.dat_ini_ctr;
                     r_escn_atu.num_contr_ces := r_ctre_atu.num_ctre;
                     r_escn_atu.dem_pta := r_grco.dem_ctda_pta;
                     r_escn_atu.dem_fpta := r_grco.dem_ctda_fpta;

                     /*
                          INSERT INTO ESCALONAMENTOS
                                    ( NUM_CONTR_CES , DAT_INIC ,
                                      DEM_PTA       , DEM_FPTA )
                             VALUES ( R_ESCN_ATU.NUM_CONTR_CES , R_ESCN_ATU.DAT_INIC ,
                                      R_ESCN_ATU.DEM_PTA       , R_ESCN_ATU.DEM_FPTA   );

                     -- ALTERADO POR : RENATO JR
                     -- SOLICITADO POR CARLOS DIAS
                     -- DATA : 26/12/2002 -> 18:00H
                     -- AS DEMANDAS DEVEM ESTAR EM MW
                     */
                     INSERT INTO escalonamentos
                                 (num_contr_ces,
                                  dat_inic,
                                  dem_pta,
                                  dem_fpta
                                 )
                          VALUES (r_escn_atu.num_contr_ces,
                                  r_escn_atu.dat_inic,
                                  r_escn_atu.dem_pta / 1000,
                                  r_escn_atu.dem_fpta / 1000
                                 );

                     w_qtd_escn_inc := w_qtd_escn_inc + 1;
                     w_existe_escn := TRUE;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        w_qtd_escn_rej_inc := w_qtd_escn_rej_inc + 1;
                        grava_mensagem (r_grco, 'GMCH0009', SQLCODE, SQLERRM);
                  --   CARGA.GRAVALOG(' ESCALONAMENTO INCLUSAO REJEITADO_FAT ' || R_GRCO.COD_GRCO || ' ' || R_ESCN_ATU.NUM_CONTR_CES || ' ' || R_ESCN_ATU.DAT_INIC   ) ;
                  --   CARGA.GRAVALOG(SQLCODE) ;
                  --   CARGA.GRAVALOG(SQLERRM) ;
                  END;
               ELSE
                  --- ATUALIZA OS DADOS
                  IF    r_escn_atu.dem_pta <> r_grco.dem_ctda_pta
                     OR r_escn_atu.dem_fpta <> r_grco.dem_ctda_fpta
                  THEN
                     BEGIN
                        r_escn_atu.dem_pta := r_grco.dem_ctda_pta;
                        r_escn_atu.dem_fpta := r_grco.dem_ctda_fpta;

                        UPDATE escalonamentos
                           SET dem_pta = r_escn_atu.dem_pta,
                               dem_fpta = r_escn_atu.dem_fpta
                         WHERE num_contr_ces = r_ctre_atu.num_ctre
                           AND dat_inic = r_grco.dat_ini_ctr;

                        w_qtd_escn_alt := w_qtd_escn_alt + 1;
                        w_existe_escn := TRUE;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           w_qtd_escn_rej_alt := w_qtd_escn_rej_alt + 1;
                           grava_mensagem (r_grco,
                                           'GMCH0010',
                                           SQLCODE,
                                           SQLERRM
                                          );
                     -- CARGA.GRAVALOG(' ESCALONAMENTO ALTERACAO REJEITADO_FAT ' || R_GRCO.COD_GRCO ) ;
                     END;
                  END IF;
               END IF;
            END;
         END IF;
      END trata_contrato_especial;
   BEGIN
      -- PARAMETROS DO SISTEMA
      parametros (g_param);
      dados_job (nome_job, g_job);
      inicializa_mensagem (g_job, g_job_msg);
      i := 0;
      g_nome_log :=
            LOWER (TRIM (g_param.des_empresa))
         || '_'
         || LOWER (TO_CHAR (data_ref, 'MONYYYY'))
         || '_log_CARGA_HIST_GRCO.txt';

      -- ULTIMO CONTRATO GERADO
      SELECT MAX (num_ctre)
        INTO w_num_ctre
        FROM contratos_especiais;

      -- ABERTURA DO ARQUIVO DE LOG
      BEGIN
         g_log := UTL_FILE.FOPEN (g_dir_sai, g_nome_log, 'a');
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            Carga.gravalog ('ERRO AO ABRIR O ARQUIVO DE LOG');
      --RAISE_APPLICATION_ERROR(-20000,'ERRO AO ABRIR O ARQUIVO DE LOG');
      END;

      Carga.gravalog
                  ('*** ---------- INICIO DA CARGA_HIST_GRCO ------------*** ');
      Carga.gravalog
                  ('*** ---------- LIMPA A TABELA DE ERROS  -------------*** ');

      EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_GRCO_BAD';

      Carga.gravalog
                 ('*** ---------- ATUALIZACAO HISTORICO FATURADO  -------*** ');

      --- CARREGA FATURAMENTO
      FOR r_grco IN c_grco_fat
      LOOP
         w_qtd_fat_lidos := w_qtd_fat_lidos + 1;
         --- VERIFICA CLASSE MERCADO
         w_existe_grco := TRUE;

         BEGIN
            SELECT *
              INTO r_grco_atu
              FROM grandes_consumidores
             WHERE cod_grco = r_grco.cod_grco;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         --- INCLUI GRANDE CONSUMIDOR
         IF SQL%NOTFOUND
         THEN
            BEGIN
               INSERT INTO grandes_consumidores
                           (cod_grco, cod_muni,
                            cod_loc, cod_bair,
                            cod_grp_tsta, pot_insd,
                            dem_ctda_pta, dem_ctda_fpta,
                            cod_atec, cod_fxa
                           )
                    VALUES (r_grco.cod_grco, r_grco.cod_muni,
                            r_grco.cod_loc, r_grco.cod_bair,
                            r_grco.cod_grp_tsta, r_grco.pot_insd,
                            r_grco.dem_ctda_pta, r_grco.dem_ctda_fpta,
                            r_grco.cod_atec, r_grco.cod_fxa
                           );

               w_qtd_inc := w_qtd_inc + 1;
            --CARGA.GRAVALOG(' GRCO INCLUIDO ' || R_GRCO.COD_GRCO ) ;
            EXCEPTION
               WHEN OTHERS
               THEN
                  w_existe_grco := FALSE;
                  w_qtd_rej_fat := w_qtd_rej_fat + 1;
                  grava_mensagem (r_grco, 'GMCH0002', SQLCODE, SQLERRM);
            -- CARGA.GRAVALOG(' GRCO REJEITADO_FAT ' || R_GRCO.COD_GRCO ) ;
            END;
         ELSIF SQL%FOUND
         THEN
            IF     (   r_grco.cod_muni <> r_grco_atu.cod_muni
                    OR r_grco.cod_loc <> r_grco_atu.cod_loc
                    OR r_grco.cod_bair <> r_grco_atu.cod_bair
                    OR r_grco.cod_grp_tsta <> r_grco_atu.cod_grp_tsta
                    OR r_grco.pot_insd <> r_grco_atu.pot_insd
                    OR r_grco.dem_ctda_pta <> r_grco_atu.dem_ctda_pta
                    OR r_grco.dem_ctda_fpta <> r_grco_atu.dem_ctda_fpta
                    OR r_grco.cod_atec <> r_grco_atu.cod_atec
                    OR r_grco.cod_fxa <> r_grco_atu.cod_fxa
                   )
               AND r_grco.ind_cont = 1
            THEN
               --- ATUALIZA GRANDE CONSUMIDOR
               BEGIN
                  UPDATE grandes_consumidores
                     SET cod_muni = r_grco.cod_muni,
                         cod_loc = r_grco.cod_loc,
                         cod_bair = r_grco.cod_bair,
                         cod_grp_tsta = r_grco.cod_grp_tsta,
                         pot_insd = r_grco.pot_insd,
                         dem_ctda_pta = r_grco.dem_ctda_pta,
                         dem_ctda_fpta = r_grco.dem_ctda_fpta,
                         cod_atec = r_grco.cod_atec,
                         cod_fxa = r_grco.cod_fxa
                   WHERE cod_grco = r_grco.cod_grco;

                  w_qtd_alt := w_qtd_alt + 1;
               --CARGA.GRAVALOG(' GRCO ALRERADO ' || R_GRCO.COD_GRCO ) ;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     w_existe_grco := FALSE;
                     w_qtd_rej_fat := w_qtd_rej_fat + 1;
                     grava_mensagem (r_grco, 'GMCH0003', SQLCODE, SQLERRM);
               -- CARGA.GRAVALOG(' GRCO REJEITADO (ALTERACAO) ' || R_GRCO.COD_GRCO ) ;
               END;
            END IF;
         ELSE
            w_existe_grco := FALSE;
            w_qtd_rej_fat := w_qtd_rej_fat + 1;
            grava_mensagem (r_grco, 'GMCH0004', SQLCODE, SQLERRM);
         -- CARGA.GRAVALOG(' GRCO NAO EXISTE ' || R_GRCO.COD_GRCO ) ;
         END IF;

         IF w_existe_grco
         THEN
            --- INCLUI CONTRATO ESPECIAL E ESCALONAMENTO
            IF     r_grco.ind_cont = 1
               AND r_grco.dat_ini_ctr IS NOT NULL
               AND (r_grco.dem_ctda_pta <> 0 OR r_grco.dem_ctda_fpta <> 0)
            THEN
               BEGIN
                  trata_contrato_especial (r_grco);
               END;
            END IF;

            --- INCLUI HISTORICO GRANDES CONSUMIDORES
            BEGIN
               SELECT cod_grco
                 INTO r_grco_atu.cod_grco
                 FROM hist_grandes_consumidores
                WHERE dat_hgrc = r_grco.dat_ref AND cod_grco = r_grco.cod_grco;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            --- mch2etp ( inclusao dos novos campos :
            ---           DEM_LDA_PTA , DEM_LDA_FPTA , DEM_ULT_PTA , DEM_ULT_FPTA , CON_RESV
            ---
            IF SQL%NOTFOUND
            THEN
               BEGIN
                  INSERT INTO hist_grandes_consumidores
                              (dat_hgrc, con_lido_pta,
                               con_lido_fpta, dem_fat_pta,
                               dem_fat_fpta, cod_grco,
                               dem_lda_pta, dem_lda_fpta,
                               dem_ult_pta, dem_ult_fpta,
                               con_resv , DAT_FAT_HGRC
                              )
                       VALUES (r_grco.dat_ref, r_grco.con_pta,
                               r_grco.con_fpta, r_grco.dem_pta,
                               r_grco.dem_fpta, r_grco.cod_grco,
                               r_grco.dem_lda_pta, r_grco.dem_lda_fpta,
                               r_grco.dem_ult_pta, r_grco.dem_ult_fpta,
                               r_grco.con_resv, R_GRCO.DAT_FATURA
                              );

                  w_qtd_inc_hist_fat := w_qtd_inc_hist_fat + 1;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     w_qtd_rej_hist_fat := w_qtd_rej_hist_fat + 1;
                     grava_mensagem (r_grco, 'GMCH0004', SQLCODE, SQLERRM);
               --CARGA.GRAVALOG(' GRCO REJEITADO (HIST) ' || R_GRCO.COD_GRCO ) ;
               END;
            ELSIF SQL%FOUND
            THEN
               BEGIN
                  UPDATE hist_grandes_consumidores
                     SET con_lido_pta = con_lido_pta + r_grco.con_pta,
                         con_lido_fpta = con_lido_fpta + r_grco.con_fpta,
                         dem_fat_pta = dem_fat_pta + r_grco.dem_pta,
                         dem_fat_fpta = dem_fat_fpta + r_grco.dem_fpta,
                         dem_lda_pta = dem_lda_pta + r_grco.dem_lda_pta,
                         dem_lda_fpta = dem_lda_fpta + r_grco.dem_lda_fpta,
                         dem_ult_pta = dem_ult_pta + r_grco.dem_ult_pta,
                         dem_ult_fpta = dem_ult_fpta + r_grco.dem_ult_fpta,
                         con_resv = con_resv + r_grco.con_resv
                   WHERE dat_hgrc = r_grco.dat_ref
                     AND cod_grco = r_grco.cod_grco;

                  w_qtd_alt_hist_fat := w_qtd_alt_hist_fat + 1;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     w_qtd_rej_hist_fat := w_qtd_rej_hist_fat + 1;
                     grava_mensagem (r_grco, 'GMCH0005', SQLCODE, SQLERRM);
               -- CARGA.GRAVALOG(' GRCO REJEITADO NA ATUALIZACAO ' || R_GRCO.COD_GRCO ) ;
               END;
            ELSE
               w_qtd_rej_hist_fat := w_qtd_rej_hist_fat + 1;
               grava_mensagem (r_grco, 'GMCH0006', SQLCODE, SQLERRM);
            --   CARGA.GRAVALOG(' GRCO NAO EXISTE (HIST) ' || R_GRCO.COD_GRCO ) ;
            END IF;
         END IF;
      END LOOP;

      --- CARREGA REFATURAMENTO
      FOR r_grco IN c_grco_ref
      LOOP
         w_qtd_ref_lidos := w_qtd_ref_lidos + 1;

         BEGIN
            UPDATE hist_grandes_consumidores
               SET con_lido_pta = con_lido_pta + r_grco.con_pta,
                   con_lido_fpta = con_lido_fpta + r_grco.con_fpta,
                   dem_fat_pta = dem_fat_pta + r_grco.dem_pta,
                   dem_fat_fpta = dem_fat_fpta + r_grco.dem_fpta,
                   dem_lda_pta = dem_lda_pta + r_grco.dem_lda_pta,
                   dem_lda_fpta = dem_lda_fpta + r_grco.dem_lda_fpta,
                   dem_ult_pta = dem_ult_pta + r_grco.dem_ult_pta,
                   dem_ult_fpta = dem_ult_fpta + r_grco.dem_ult_fpta,
                   con_resv = con_resv + r_grco.con_resv
             WHERE dat_hgrc = r_grco.dat_ref AND cod_grco = r_grco.cod_grco;

            IF SQL%FOUND
            THEN
               w_qtd_inc_hist_ref := w_qtd_inc_hist_ref + 1;
            --CARGA.GRAVALOG(' GRCO REFATURADO ' || R_GRCO.COD_GRCO ) ;
            ELSE
               w_qtd_rej_hist_ref := w_qtd_rej_hist_ref + 1;
               grava_mensagem (r_grco, 'GMCH0007', SQLCODE, SQLERRM);
            --CARGA.GRAVALOG(' GRCO NAO EXISTE ' || R_GRCO.COD_GRCO ) ;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               w_qtd_rej_hist_ref := w_qtd_rej_hist_ref + 1;
               grava_mensagem (r_grco, 'GMCH0008', SQLCODE, SQLERRM);
         --   CARGA.GRAVALOG(' GRCO REJEITADO (REF) ' || R_GRCO.COD_GRCO ) ;
         END;
      END LOOP;

      --- CARREGA CANCELAMENTO
      FOR r_grco IN c_grco_can
      LOOP
         w_qtd_can_lidos := w_qtd_can_lidos + 1;

         BEGIN
            UPDATE hist_grandes_consumidores
               SET con_lido_pta = con_lido_pta - r_grco.con_pta,
                   con_lido_fpta = con_lido_fpta - r_grco.con_fpta,
                   dem_fat_pta = dem_fat_pta - r_grco.dem_pta,
                   dem_fat_fpta = dem_fat_fpta - r_grco.dem_fpta,
                   dem_lda_pta = dem_lda_pta - r_grco.dem_lda_pta,
                   dem_lda_fpta = dem_lda_fpta - r_grco.dem_lda_fpta,
                   dem_ult_pta = dem_ult_pta - r_grco.dem_ult_pta,
                   dem_ult_fpta = dem_ult_fpta - r_grco.dem_ult_fpta,
                   con_resv = con_resv - r_grco.con_resv
             WHERE dat_hgrc = r_grco.dat_ref AND cod_grco = r_grco.cod_grco;

            IF SQL%FOUND
            THEN
               w_qtd_inc_hist_can := w_qtd_inc_hist_can + 1;
            ELSE
               w_qtd_rej_hist_can := w_qtd_rej_hist_can + 1;
               grava_mensagem (r_grco, 'GMCH0007', SQLCODE, SQLERRM);
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               w_qtd_rej_hist_can := w_qtd_rej_hist_can + 1;
               grava_mensagem (r_grco, 'GMCH0008', SQLCODE, SQLERRM);
         END;
      END LOOP;

      --- FINALIZA ATUALIZACAO DO HISTORICO MERCADO GLOBAL
      IF g_param.atualiza = 'SIM'
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
      END IF;

      ---- FINALIZA PROCESSO
      finaliza_job;
      Carga.gravalog (   ' QUANT. DE GRCO FAT LIDOS..... '
                      || TO_CHAR (w_qtd_fat_lidos, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE GRCO INCLUIDO ..... '
                      || TO_CHAR (w_qtd_inc, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE GRCO ALTERADOS .... '
                      || TO_CHAR (w_qtd_rej_fat, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. HIST. FAT INCLUIDAS... '
                      || TO_CHAR (w_qtd_inc_hist_fat, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. HIST. FAT ALTERADAS. ..'
                      || TO_CHAR (w_qtd_alt_hist_fat, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. HIST. FAT REJEITADOS ..'
                      || TO_CHAR (w_qtd_rej_hist_fat, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE HIST REF LIDOS..... '
                      || TO_CHAR (w_qtd_ref_lidos, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE HIST REF ATUALIZADO '
                      || TO_CHAR (w_qtd_inc_hist_ref, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE HIST REF REJEITADOS '
                      || TO_CHAR (w_qtd_rej_hist_ref, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE HIST CAN LIDOS..... '
                      || TO_CHAR (w_qtd_can_lidos, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE HIST CAN ATUALIZADO '
                      || TO_CHAR (w_qtd_inc_hist_can, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE HIST CAN REJEITADOS '
                      || TO_CHAR (w_qtd_rej_hist_can, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. CONTR. ESP INCLUIDOS   '
                      || TO_CHAR (w_qtd_ctre_inc, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. CONTR. ESP EXISTENTES  '
                      || TO_CHAR (w_qtd_ctre_exi, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. CONTR. ESP REJEITADOS  '
                      || TO_CHAR (w_qtd_ctre_rej, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. ESCALON.  EXISTENTES  '
                      || TO_CHAR (w_qtd_escn_exi, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. ESCALON.  INCLUIDOS   '
                      || TO_CHAR (w_qtd_escn_inc, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. ESCALON.  ALTERADOS   '
                      || TO_CHAR (w_qtd_escn_alt, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. ESCALON.  REJ.ALTR    '
                      || TO_CHAR (w_qtd_escn_rej_alt, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. ESCALON.  REJ.INCL    '
                      || TO_CHAR (w_qtd_escn_rej_inc, '9999,999,999')
                     );

      IF g_param.atualiza = 'SIM'
      THEN
         Carga.gravalog
                  ('*** ---------------- FINAL DA CARGA ----------------*** ');
      ELSE
         Carga.gravalog
                  ('*** -------- FINAL DA CARGA SEM ATUALIZACAO --------*** ');
      END IF;

      UTL_FILE.FCLOSE (g_log);
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         Carga.gravalog
                ('*** -------- ATE O MOMENTO FORAM PROCESSADOS  --------*** ');
         Carga.gravalog (   ' QUANT. DE GRCO FAT LIDOS..... '
                         || TO_CHAR (w_qtd_fat_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE GRCO INCLUIDO ..... '
                         || TO_CHAR (w_qtd_inc, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE GRCO ALTERADOS .... '
                         || TO_CHAR (w_qtd_rej_fat, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. HIST. FAT INCLUIDAS... '
                         || TO_CHAR (w_qtd_inc_hist_fat, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. HIST. FAT ALTERADAS. ..'
                         || TO_CHAR (w_qtd_alt_hist_fat, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. HIST. FAT REJEITADOS ..'
                         || TO_CHAR (w_qtd_rej_hist_fat, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST REF LIDOS..... '
                         || TO_CHAR (w_qtd_ref_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST REF ATUALIZADO '
                         || TO_CHAR (w_qtd_inc_hist_ref, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST REF REJEITADOS '
                         || TO_CHAR (w_qtd_rej_hist_ref, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST CAN LIDOS..... '
                         || TO_CHAR (w_qtd_can_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST CAN ATUALIZADO '
                         || TO_CHAR (w_qtd_inc_hist_can, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST CAN REJEITADOS '
                         || TO_CHAR (w_qtd_rej_hist_can, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. CONTR. ESP INCLUIDOS   '
                         || TO_CHAR (w_qtd_ctre_inc, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. CONTR. ESP EXISTENTES  '
                         || TO_CHAR (w_qtd_ctre_exi, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. CONTR. ESP REJEITADOS  '
                         || TO_CHAR (w_qtd_ctre_rej, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. ESCALON.  EXISTENTES  '
                         || TO_CHAR (w_qtd_escn_exi, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. ESCALON.  INCLUIDOS   '
                         || TO_CHAR (w_qtd_escn_inc, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. ESCALON.  ALTERADOS   '
                         || TO_CHAR (w_qtd_escn_alt, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. ESCALON.  REJ.ALTR    '
                         || TO_CHAR (w_qtd_escn_rej_alt, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. ESCALON.  REJ.INCL    '
                         || TO_CHAR (w_qtd_escn_rej_inc, '9999,999,999')
                        );
         Carga.gravalog (' erro : ' || SQLERRM);
         Carga.gravalog
                    ('*** ---------------- ERRO NA CARGA ----------------*** ');
         UTL_FILE.FCLOSE_ALL;
   END carga_hist_grco;

   PROCEDURE carga_hist_localidade (data_ref IN DATE, nome_job IN VARCHAR2)
   IS
      --- CURSORES
      CURSOR c_loc_fat
      IS
         SELECT DISTINCT cod_muni, cod_loc, cod_bair
                    FROM vm_tmp_loc
                   WHERE tip_fat = 'FAT';

      CURSOR c_loccl_fat
      IS
         SELECT DISTINCT cod_muni, cod_loc, cod_bair, cod_gclm
                    FROM vm_tmp_loc
                   WHERE tip_fat = 'FAT';

      CURSOR c_hloc_fat
      IS
         SELECT *
           FROM vm_tmp_loc
          WHERE tip_fat = 'FAT';

      CURSOR c_hloc_ref
      IS
         SELECT *
           FROM vm_tmp_loc
          WHERE tip_fat = 'REF';

      CURSOR c_hloc_can
      IS
         SELECT *
           FROM vm_tmp_loc
          WHERE tip_fat = 'CAN';

      --- VARIAVEIS AUXILIARES
      w_hloc                 vm_tmp_loc%ROWTYPE;
      w_loc                  c_loc_fat%ROWTYPE;
      w_loccl                c_loccl_fat%ROWTYPE;
      w_cod_muni             c_localidades.cod_muni%TYPE;
      w_cod_loc              c_localidades.cod_loc%TYPE;
      w_cod_bair             c_localidades.cod_bair%TYPE;
      w_cod_gclm             localidades_classes_mercado.cod_gclm%TYPE;
      --- ACUMULADORES
      w_qtd_inc_loc          NUMBER                                      := 0;
      w_qtd_rej_loc          NUMBER                                      := 0;
      w_qtd_inc_loccl        NUMBER                                      := 0;
      w_qtd_rej_loccl        NUMBER                                      := 0;
      w_qtd_inc_hloc_fat     NUMBER                                      := 0;
      w_qtd_rej_hloc_fat     NUMBER                                      := 0;
      w_qtd_inc_hloc_ref     NUMBER                                      := 0;
      w_qtd_rej_hloc_ref     NUMBER                                      := 0;
      w_qtd_inc_hloc_can     NUMBER                                      := 0;
      w_qtd_rej_hloc_can     NUMBER                                      := 0;
      w_qtd_loc_lidos        NUMBER                                      := 0;
      w_qtd_loccl_lidos      NUMBER                                      := 0;
      w_qtd_hloc_lidos_fat   NUMBER                                      := 0;
      w_qtd_hloc_lidos_ref   NUMBER                                      := 0;
      w_qtd_hloc_lidos_can   NUMBER                                      := 0;

      --- ROTINAS INTERNAS
      PROCEDURE grava_totais
      IS
      BEGIN
         Carga.gravalog (   ' QUANTIDADE DE LOCALIDADES LIDOS...'
                         || TO_CHAR (w_qtd_loc_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE DE LOCALID. REJEITADOS '
                         || TO_CHAR (w_qtd_rej_loc, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE DE LOCALID. INCLUIDAS  '
                         || TO_CHAR (w_qtd_inc_loc, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE LOCAL/CLASSE LIDOS......'
                         || TO_CHAR (w_qtd_loccl_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE LOCAL/CLASSE REJEITADAS.'
                         || TO_CHAR (w_qtd_rej_loccl, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE LOCAL/CLASSE INCLUIDA...'
                         || TO_CHAR (w_qtd_inc_loccl, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST.LOCAL FAT LIDOS......'
                         || TO_CHAR (w_qtd_hloc_lidos_fat, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST.LOCAL FAT REJEITADAS.'
                         || TO_CHAR (w_qtd_rej_hloc_fat, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST.LOCAL FAT INCLUIDA...'
                         || TO_CHAR (w_qtd_inc_hloc_fat, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST.LOCAL REF LIDOS......'
                         || TO_CHAR (w_qtd_hloc_lidos_ref, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST.LOCAL REF REJEITADAS.'
                         || TO_CHAR (w_qtd_rej_hloc_ref, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST.LOCAL REF INCLUIDA...'
                         || TO_CHAR (w_qtd_inc_hloc_ref, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST.LOCAL CAN LIDOS......'
                         || TO_CHAR (w_qtd_hloc_lidos_can, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST.LOCAL CAN REJEITADAS.'
                         || TO_CHAR (w_qtd_rej_hloc_can, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST.LOCAL CAN INCLUIDA...'
                         || TO_CHAR (w_qtd_inc_hloc_can, '9999,999,999')
                        );
      END grava_totais;

      PROCEDURE grava_mensagem (
         ent    IN   VARCHAR2,
         erro   IN   VARCHAR,
         cod    IN   NUMBER,
         mess   IN   VARCHAR
      )
      IS
      BEGIN
         IF ent = 'LOC'
         THEN
            INSERT INTO tmp_loc_bad
                        (tip_fat, dat_ref, cod_muni, cod_loc,
                         cod_bair, cod_gclm, cod_erro, code, errm
                        )
                 VALUES ('FAT', data_ref, w_loc.cod_muni, w_loc.cod_loc,
                         w_loc.cod_bair, NULL, erro, cod, mess
                        );
         ELSIF ent = 'LOCCL'
         THEN
            INSERT INTO tmp_loc_bad
                        (tip_fat, dat_ref, cod_muni, cod_loc,
                         cod_bair, cod_gclm, cod_erro, code, errm
                        )
                 VALUES ('FAT', data_ref, w_loccl.cod_muni, w_loccl.cod_loc,
                         w_loccl.cod_bair, w_loccl.cod_gclm, erro, cod, mess
                        );
         ELSIF ent = 'HLOC'
         THEN
            INSERT INTO tmp_loc_bad
                        (tip_fat, dat_ref, cod_muni,
                         cod_loc, cod_bair, cod_gclm,
                         cod_erro, code, errm
                        )
                 VALUES (w_hloc.tip_fat, w_hloc.dat_ref, w_hloc.cod_muni,
                         w_hloc.cod_loc, w_hloc.cod_bair, w_hloc.cod_gclm,
                         erro, cod, mess
                        );
         END IF;
      END grava_mensagem;
   BEGIN
      -- PARAMETROS DO SISTEMA
      parametros (g_param);
      dados_job (nome_job, g_job);
      inicializa_mensagem (g_job, g_job_msg);
      g_nome_log :=
            LOWER (TRIM (g_param.des_empresa))
         || '_'
         || LOWER (TO_CHAR (data_ref, 'MONYYYY'))
         || '_log_CARGA_HIST_LOCALIDADE.txt';

      -- ABERTURA DO ARQUIVO DE LOG
      BEGIN
         g_log := UTL_FILE.FOPEN (g_dir_sai, g_nome_log, 'a');
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO ABRIR O ARQUIVO DE LOG');
      END;

      Carga.gravalog
              ('*** ---------- INICIO DA CARGA HIST LOCALIDADE ----------*** ');
      Carga.gravalog
               ('*** ---------- LIMPA A TABELA DE ERROS  ----------------*** ');

      EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_LOC_BAD';

      Carga.gravalog
                 ('*** ---------- ATUALIZACAO HISTORICO FATURADO  -------*** ');
      --- CARREGA LOCALIDADES INEXISTENTES
      Carga.gravalog
                ('*** ---------- INCLUI LOCALIDADES INEXISTENTES  -------*** ');

      FOR r_loc IN c_loc_fat
      LOOP
         w_qtd_loc_lidos := w_qtd_loc_lidos + 1;
         w_loc := r_loc;

         --- VERIFICA LOCALIDADE
         BEGIN
            SELECT cod_muni, cod_loc, cod_bair
              INTO w_cod_muni, w_cod_loc, w_cod_bair
              FROM c_localidades
             WHERE cod_muni = r_loc.cod_muni
               AND cod_loc = r_loc.cod_loc
               AND cod_bair = r_loc.cod_bair;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         --- INCLUI LOCALIDADE
         IF SQL%NOTFOUND
         THEN
            BEGIN
               INSERT INTO c_localidades
                           (cod_muni, cod_loc, cod_bair,
                            dat_inic_vgen
                           )
                    VALUES (r_loc.cod_muni, r_loc.cod_loc, r_loc.cod_bair,
                            SYSDATE
                           );

               w_qtd_inc_loc := w_qtd_inc_loc + 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  w_qtd_rej_loc := w_qtd_rej_loc + 1;
                  grava_mensagem ('LOC', 'GMCH0009', SQLCODE, SQLERRM);
            --    CARGA.GRAVALOG(' LOC NAO EXISTE ' || TO_CHAR(R_LOC.COD_MUNI,'000')
            --                                      || TO_CHAR(R_LOC.COD_LOC,'00')
            --                                      || TO_CHAR(R_LOC.COD_BAIR,'000' )) ;
            END;
         END IF;
      END LOOP;

      --- CARREGA LOCALIDADES/CLASSES INEXISTENTES
      Carga.gravalog
           ('*** ------- INCLUI LOCALIDADES/CLASSES INEXISTENTES  -------*** ');

      FOR r_loccl IN c_loccl_fat
      LOOP
         w_qtd_loccl_lidos := w_qtd_loccl_lidos + 1;
         w_loccl := r_loccl;

         --- VERIFICA LOCALIDADE/CLASSE
         BEGIN
            SELECT cod_muni, cod_loc, cod_bair, cod_gclm
              INTO w_cod_muni, w_cod_loc, w_cod_bair, w_cod_gclm
              FROM localidades_classes_mercado
             WHERE cod_muni = r_loccl.cod_muni
               AND cod_loc = r_loccl.cod_loc
               AND cod_bair = r_loccl.cod_bair
               AND cod_gclm = r_loccl.cod_gclm;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         --- INCLUI LOCALIDADE/CLASSE
         IF SQL%NOTFOUND
         THEN
            BEGIN
               INSERT INTO localidades_classes_mercado
                           (cod_muni, cod_loc,
                            cod_bair, cod_gclm
                           )
                    VALUES (r_loccl.cod_muni, r_loccl.cod_loc,
                            r_loccl.cod_bair, r_loccl.cod_gclm
                           );

               w_qtd_inc_loccl := w_qtd_inc_loccl + 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  w_qtd_rej_loccl := w_qtd_rej_loccl + 1;
                  grava_mensagem ('LOCCL', 'GMCH0010', SQLCODE, SQLERRM);
            --  CARGA.GRAVALOG(' LOC NAO EXISTE ' || TO_CHAR(R_LOCCL.COD_MUNI,'000')
            --                                    || TO_CHAR(R_LOCCL.COD_LOC,'00')
            --                                    || TO_CHAR(R_LOCCL.COD_BAIR,'000' )) ;
            END;
         END IF;
      END LOOP;

      --- CARREGA HISTORICO FATURADO
      Carga.gravalog ('*** ------- INCLUI HISTORICO FATURADO  -------*** ');

      FOR r_hloc IN c_hloc_fat
      LOOP
         w_qtd_hloc_lidos_fat := w_qtd_hloc_lidos_fat + 1;
         w_hloc := r_hloc;

         --- INCLUI HISTORICO MERCADO
         BEGIN
            INSERT INTO hist_local_mercado
                        (cod_muni, cod_loc, cod_bair,
                         cod_gclm, dat_hlgc, con_hlgc,
                         qtd_cons
                        )
                 VALUES (r_hloc.cod_muni, r_hloc.cod_loc, r_hloc.cod_bair,
                         r_hloc.cod_gclm, r_hloc.dat_ref, r_hloc.con_tot,
                         r_hloc.qtd_cons
                        );

            w_qtd_inc_hloc_fat := w_qtd_inc_hloc_fat + 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               w_qtd_rej_hloc_fat := w_qtd_rej_hloc_fat + 1;
               grava_mensagem ('HLOC', 'GMCH0011', SQLCODE, SQLERRM);
         --   CARGA.GRAVALOG(' LOC REJEITADA  ' || TO_CHAR(R_HLOC.COD_MUNI,'000')
         --                                     || TO_CHAR(R_HLOC.COD_LOC,'00')
         --                                     || TO_CHAR(R_HLOC.COD_BAIR,'000' )) ;
         END;
      END LOOP;

      --- CARREGA HISTORICO REFATURADO
      Carga.gravalog ('*** ------- INCLUI HISTORICO REFATURADO  -------*** ');

      FOR r_hloc IN c_hloc_ref
      LOOP
         w_qtd_hloc_lidos_ref := w_qtd_hloc_lidos_ref + 1;
         w_hloc := r_hloc;

         --- INCLUI HISTORICO MERCADO
         BEGIN
            UPDATE hist_local_mercado
               SET con_hlgc = con_hlgc + r_hloc.con_tot,
                   qtd_cons = qtd_cons + r_hloc.qtd_cons
             WHERE cod_muni = r_hloc.cod_muni
               AND cod_loc = r_hloc.cod_loc
               AND cod_bair = r_hloc.cod_bair
               AND cod_gclm = r_hloc.cod_gclm
               AND dat_hlgc = r_hloc.dat_ref;

            IF SQL%FOUND
            THEN
               w_qtd_inc_hloc_ref := w_qtd_inc_hloc_ref + 1;
            ELSE
               w_qtd_rej_hloc_ref := w_qtd_rej_hloc_ref + 1;
               grava_mensagem ('HLOC', 'GMCH0012', SQLCODE, SQLERRM);
            --  CARGA.GRAVALOG(' LOC REJEITADA  ' || TO_CHAR(R_HLOC.COD_MUNI,'000')
            --                                    || TO_CHAR(R_HLOC.COD_LOC,'00')
            --                                    || TO_CHAR(R_HLOC.COD_BAIR,'000' )) ;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               w_qtd_rej_hloc_ref := w_qtd_rej_hloc_ref + 1;
               grava_mensagem ('HLOC', 'GMCH0013', SQLCODE, SQLERRM);
         -- CARGA.GRAVALOG(' LOC REJEITADA  ' || TO_CHAR(R_HLOC.COD_MUNI,'000')
         --                                   || TO_CHAR(R_HLOC.COD_LOC,'00')
         --                                   || TO_CHAR(R_HLOC.COD_BAIR,'000' )) ;
         END;
      END LOOP;

      --- CARREGA HISTORICO CANCELADO
      Carga.gravalog ('*** ------- INCLUI HISTORICO CANCELADO  -------*** ');

      FOR r_hloc IN c_hloc_can
      LOOP
         w_qtd_hloc_lidos_can := w_qtd_hloc_lidos_can + 1;
         w_hloc := r_hloc;

         --- INCLUI HISTORICO MERCADO
         BEGIN
            UPDATE hist_local_mercado
               SET con_hlgc = con_hlgc - r_hloc.con_tot,
                   qtd_cons = qtd_cons - r_hloc.qtd_cons
             WHERE cod_muni = r_hloc.cod_muni
               AND cod_loc = r_hloc.cod_loc
               AND cod_bair = r_hloc.cod_bair
               AND cod_gclm = r_hloc.cod_gclm
               AND dat_hlgc = r_hloc.dat_ref;

            IF SQL%FOUND
            THEN
               w_qtd_inc_hloc_can := w_qtd_inc_hloc_can + 1;
            ELSE
               w_qtd_rej_hloc_can := w_qtd_rej_hloc_can + 1;
               grava_mensagem ('HLOC', 'GMCH0014', SQLCODE, SQLERRM);
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               w_qtd_rej_hloc_can := w_qtd_rej_hloc_can + 1;
               grava_mensagem ('HLOC', 'GMCH0015', SQLCODE, SQLERRM);
         END;
      END LOOP;

      --- FINALIZA ATUALIZACAO DO HISTORICO MERCADO GLOBAL
      IF g_param.atualiza = 'SIM'
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
      END IF;

      ---- FINALIZA PROCESSO
      finaliza_job;
      grava_totais;

      IF g_param.atualiza = 'SIM'
      THEN
         Carga.gravalog
                  ('*** ---------------- FINAL DA CARGA ----------------*** ');
      ELSE
         Carga.gravalog
                  ('*** -------- FINAL DA CARGA SEM ATUALIZACAO --------*** ');
      END IF;

      UTL_FILE.FCLOSE (g_log);
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         grava_totais;
         Carga.gravalog (' erro : ' || SQLERRM);
         Carga.gravalog
                   ('*** ---------------- ERRO NA CARGA ----------------*** ');
         UTL_FILE.FCLOSE_ALL;
   END carga_hist_localidade;

   PROCEDURE carga_hist_municipio (data_ref IN DATE, nome_job IN VARCHAR2)
   IS
         --- CURSORES
      /*
       CURSOR         C_MUNI_FAT IS
                      SELECT DISTINCT COD_MUNI
                        FROM VM_TMP_MUNI
                        WHERE TIP_FAT = 'FAT' ;

       CURSOR         C_MUNICL_FAT IS
                      SELECT DISTINCT COD_MUNI , COD_GCLM
                        FROM VM_TMP_MUNI
                        WHERE TIP_FAT = 'FAT' ;


       CURSOR         C_HMUNI_FAT IS
                      SELECT *  FROM VM_TMP_MUNI
                        WHERE TIP_FAT = 'FAT' ;

       CURSOR         C_HMUNI_REF IS
                      SELECT *  FROM VM_TMP_MUNI
                        WHERE TIP_FAT = 'REF' ;

       CURSOR         C_HMUNI_CAN IS
                      SELECT *  FROM VM_TMP_MUNI
                        WHERE TIP_FAT = 'CAN' ;
      */
      CURSOR c_tmp_muni
      IS
         SELECT *
           FROM vm_tmp_muni;

      CURSOR c_tmp_municl
      IS
         SELECT DISTINCT cod_muni, cod_gclm
                    FROM vm_tmp_muni;

      --- VARIAVEIS AUXILIARES
      w_muni               vm_tmp_muni%ROWTYPE;
      w_hmuni              vm_tmp_muni%ROWTYPE;
      /* R_MUNI          C_MUNI_FAT%ROWTYPE; */
      w_municl             c_tmp_municl%ROWTYPE;
      w_cod_muni           c_municipios.cod_muni%TYPE;
      w_cod_gclm           municipios_classes_mercado.cod_gclm%TYPE;
      --- ACUMULADORES
      w_qtd_inc_muni       NUMBER                                     := 0;
      w_qtd_rej_muni       NUMBER                                     := 0;
      w_qtd_inc_municl     NUMBER                                     := 0;
      w_qtd_rej_municl     NUMBER                                     := 0;
      w_qtd_inc_hmuni      NUMBER                                     := 0;
      w_qtd_rej_hmuni      NUMBER                                     := 0;
      /*
       W_QTD_INC_HMUNI_FAT    NUMBER := 0;
       W_QTD_REJ_HMUNI_FAT    NUMBER := 0;
       W_QTD_INC_HMUNI_REF    NUMBER := 0;
       W_QTD_REJ_HMUNI_REF    NUMBER := 0;
       W_QTD_INC_HMUNI_CAN    NUMBER := 0;
       W_QTD_REJ_HMUNI_CAN    NUMBER := 0;
      */
      w_qtd_muni_lidos     NUMBER                                     := 0;
      w_qtd_municl_lidos   NUMBER                                     := 0;
      w_qtd_hmuni_lidos    NUMBER                                     := 0;

      /*
       W_QTD_HMUNI_LIDOS_FAT  NUMBER := 0;
       W_QTD_HMUNI_LIDOS_REF  NUMBER := 0;
       W_QTD_HMUNI_LIDOS_CAN  NUMBER := 0;
      */

      --- ROTINAS INTERNAS
      PROCEDURE grava_totais
      IS
      BEGIN
         Carga.gravalog (   ' QUANTIDADE DE MUNICIPIOS LIDOS...'
                         || TO_CHAR (w_qtd_muni_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE DE MUNICIP. REJEITADOS '
                         || TO_CHAR (w_qtd_rej_muni, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE DE MUNICIP. INCLUIDAS  '
                         || TO_CHAR (w_qtd_inc_muni, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE MUNI/CLASSE LIDOS......'
                         || TO_CHAR (w_qtd_municl_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE MUNI/CLASSE REJEITADAS.'
                         || TO_CHAR (w_qtd_rej_municl, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE MUNI/CLASSE INCLUIDA...'
                         || TO_CHAR (w_qtd_inc_municl, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST.MUNI  LIDOS......'
                         || TO_CHAR (w_qtd_hmuni_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST.MUNI  REJEITADAS.'
                         || TO_CHAR (w_qtd_rej_hmuni, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE HIST.MUNI  INCLUIDA...'
                         || TO_CHAR (w_qtd_inc_hmuni, '9999,999,999')
                        );
      /*
        CARGA.GRAVALOG(' QUANT. DE HIST.MUNI FAT LIDOS......' || TO_CHAR( W_QTD_HMUNI_LIDOS_FAT  ,'9999,999,999')) ;
        CARGA.GRAVALOG(' QUANT. DE HIST.MUNI FAT REJEITADAS.' || TO_CHAR( W_QTD_REJ_HMUNI_FAT    ,'9999,999,999')) ;
        CARGA.GRAVALOG(' QUANT. DE HIST.MUNI FAT INCLUIDA...' || TO_CHAR( W_QTD_INC_HMUNI_FAT    ,'9999,999,999')) ;

        CARGA.GRAVALOG(' QUANT. DE HIST.MUNI REF LIDOS......' || TO_CHAR( W_QTD_HMUNI_LIDOS_REF  ,'9999,999,999')) ;
        CARGA.GRAVALOG(' QUANT. DE HIST.MUNI REF REJEITADAS.' || TO_CHAR( W_QTD_REJ_HMUNI_REF    ,'9999,999,999')) ;
        CARGA.GRAVALOG(' QUANT. DE HIST.MUNI REF INCLUIDA...' || TO_CHAR( W_QTD_INC_HMUNI_REF    ,'9999,999,999')) ;

        CARGA.GRAVALOG(' QUANT. DE HIST.MUNI CAN LIDOS......' || TO_CHAR( W_QTD_HMUNI_LIDOS_CAN  ,'9999,999,999')) ;
        CARGA.GRAVALOG(' QUANT. DE HIST.MUNI CAN REJEITADAS.' || TO_CHAR( W_QTD_REJ_HMUNI_CAN    ,'9999,999,999')) ;
        CARGA.GRAVALOG(' QUANT. DE HIST.MUNI CAN INCLUIDA...' || TO_CHAR( W_QTD_INC_HMUNI_CAN    ,'9999,999,999')) ;
      */
      END grava_totais;

      PROCEDURE grava_mensagem (
         ent    IN   VARCHAR2,
         erro   IN   VARCHAR,
         cod    IN   NUMBER,
         mess   IN   VARCHAR
      )
      IS
      BEGIN
         IF ent = 'MUNI'
         THEN
            INSERT INTO tmp_muni_bad
                        (tip_fat, dat_ref, cod_muni, cod_gclm, cod_erro,
                         code, errm
                        )
                 VALUES ('FAT', data_ref, w_muni.cod_muni, NULL, erro,
                         cod, mess
                        );
         ELSIF ent = 'MUNICL'
         THEN
            INSERT INTO tmp_muni_bad
                        (tip_fat, dat_ref, cod_muni,
                         cod_gclm, cod_erro, code, errm
                        )
                 VALUES ('FAT', data_ref, w_municl.cod_muni,
                         w_municl.cod_gclm, erro, cod, mess
                        );
         ELSIF ent = 'HLOC'
         THEN
            INSERT INTO tmp_muni_bad
                        (tip_fat, dat_ref, cod_muni, cod_gclm,
                         cod_erro, code, errm
                        )
                 VALUES (' ', data_ref, w_hmuni.cod_muni, w_hmuni.cod_gclm,
                         erro, cod, mess
                        );
         END IF;
      END grava_mensagem;
   BEGIN
      -- PARAMETROS DO SISTEMA
      parametros (g_param);
      dados_job (nome_job, g_job);
      inicializa_mensagem (g_job, g_job_msg);
      g_nome_log :=
            LOWER (TRIM (g_param.des_empresa))
         || '_'
         || LOWER (TO_CHAR (data_ref, 'MONYYYY'))
         || '_log_CARGA_HIST_MUNICIPIO.txt';

      -- ABERTURA DO ARQUIVO DE LOG
      BEGIN
         g_log := UTL_FILE.FOPEN (g_dir_sai, g_nome_log, 'a');
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO ABRIR O ARQUIVO DE LOG');
      END;

      Carga.gravalog
               ('*** ---------- INICIO DA CARGA HIST MUNICIPIO ----------*** ');
      Carga.gravalog
               ('*** ---------- LIMPA A TABELA DE ERROS  ----------------*** ');

      EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MUNI_BAD';

      Carga.gravalog
                 ('*** ---------- ATUALIZACAO HISTORICO FATURADO  -------*** ');
      --- CARREGA MUNICIPIOS INEXISTENTES
      Carga.gravalog
                 ('*** ---------- INCLUI MUNICIPIOS INEXISTENTES  -------*** ');

      FOR r_muni IN c_tmp_muni
      LOOP
         w_qtd_muni_lidos := w_qtd_muni_lidos + 1;
         w_muni := r_muni;

         --- VERIFICA MUNICIPIO
         BEGIN
            SELECT cod_muni
              INTO w_cod_muni
              FROM c_municipios
             WHERE cod_muni = r_muni.cod_muni;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         --- INCLUI MUNICIPIO
         IF SQL%NOTFOUND
         THEN
            BEGIN
               INSERT INTO c_municipios
                           (cod_muni
                           )
                    VALUES (r_muni.cod_muni
                           );

               w_qtd_inc_muni := w_qtd_inc_muni + 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  w_qtd_rej_muni := w_qtd_rej_muni + 1;
                  grava_mensagem ('MUNI', 'GMCH0016', SQLCODE, SQLERRM);
            END;
         END IF;
      END LOOP;

      --- CARREGA LOCALIDADES/CLASSES INEXISTENTES
      Carga.gravalog
           ('*** ------- INCLUI LOCALIDADES/CLASSES INEXISTENTES  -------*** ');

      FOR r_municl IN c_tmp_municl
      LOOP
         w_qtd_municl_lidos := w_qtd_municl_lidos + 1;
         w_municl := r_municl;

         --- VERIFICA MUNICIPIO/CLASSE
         BEGIN
            SELECT cod_muni, cod_gclm
              INTO w_cod_muni, w_cod_gclm
              FROM municipios_classes_mercado
             WHERE cod_muni = r_municl.cod_muni
               AND cod_gclm = r_municl.cod_gclm;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         --- INCLUI MUNICIPIO/CLASSE
         IF SQL%NOTFOUND
         THEN
            BEGIN
               INSERT INTO municipios_classes_mercado
                           (cod_muni, cod_gclm
                           )
                    VALUES (r_municl.cod_muni, r_municl.cod_gclm
                           );

               w_qtd_inc_municl := w_qtd_inc_municl + 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  w_qtd_rej_municl := w_qtd_rej_municl + 1;
                  grava_mensagem ('MUNICL', 'GMCH0017', SQLCODE, SQLERRM);
            END;
         END IF;
      END LOOP;

      --- CARREGA HISTORICO
      Carga.gravalog ('*** ------- INCLUI HISTORICO     -------*** ');

      FOR r_hmuni IN c_tmp_muni
      LOOP
         w_qtd_hmuni_lidos := w_qtd_hmuni_lidos + 1;
         w_hmuni := r_hmuni;

         --- INCLUI HISTORICO MERCADO
         BEGIN
            INSERT INTO hist_municipio_mercado
                        (cod_muni, cod_gclm, dat_hmgc,
                         con_hmgc, qtd_cons
                        )
                 VALUES (r_hmuni.cod_muni, r_hmuni.cod_gclm, data_ref,
                         r_hmuni.con_tot, r_hmuni.qtd_cons
                        );

            w_qtd_inc_hmuni := w_qtd_inc_hmuni + 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               w_qtd_rej_hmuni := w_qtd_rej_hmuni + 1;
               grava_mensagem ('HMUNI', 'GMCH0018', SQLCODE, SQLERRM);
         END;
      END LOOP;

      /*
       --- CARREGA HISTORICO REFATURADO

           CARGA.GRAVALOG( '*** ------- INCLUI HISTORICO REFATURADO  -------*** ' ) ;

           FOR R_HMUNI IN C_HMUNI_REF LOOP

                  W_QTD_HMUNI_LIDOS_REF :=  W_QTD_HMUNI_LIDOS_REF + 1 ;

               --- INCLUI HISTORICO MERCADO

                  BEGIN
                        UPDATE HIST_MUNICIPIO_MERCADO
                           SET  CON_HMGC  =  CON_HMGC + R_HMUNI.CON_TOT
                             ,  QTD_CONS  =  QTD_CONS + R_HMUNI.QTD_CONS
                        WHERE COD_MUNI = R_HMUNI.COD_MUNI
                          AND COD_GCLM = R_HMUNI.COD_GCLM
                          AND DAT_HMGC = R_HMUNI.DAT_REF ;
                        IF SQL%FOUND THEN
                            W_QTD_INC_HMUNI_REF := W_QTD_INC_HMUNI_REF + 1;
                        ELSE
                            W_QTD_REJ_HMUNI_REF  := W_QTD_REJ_HMUNI_REF  + 1;
                            GRAVA_MENSAGEM( 'HMUNI' , 'GMCH0019' , SQLCODE , SQLERRM ) ;
                        END IF ;
                  EXCEPTION
                  WHEN OTHERS THEN
                       W_QTD_REJ_HMUNI_REF  := W_QTD_REJ_HMUNI_REF  + 1;
                       GRAVA_MENSAGEM( 'HMUNI' , 'GMCH0020' , SQLCODE , SQLERRM ) ;
                  END;

           END LOOP;


       --- CARREGA HISTORICO CANCELADO

           CARGA.GRAVALOG( '*** ------- INCLUI HISTORICO CANCELADO  -------*** ' ) ;

           FOR R_HMUNI IN C_HMUNI_CAN LOOP

                  W_QTD_HMUNI_LIDOS_CAN :=  W_QTD_HMUNI_LIDOS_CAN + 1 ;

               --- INCLUI HISTORICO MERCADO

                  BEGIN
                        UPDATE HIST_MUNICIPIO_MERCADO
                           SET  CON_HMGC  =  CON_HMGC - R_HMUNI.CON_TOT
                             ,  QTD_CONS  =  QTD_CONS - R_HMUNI.QTD_CONS
                        WHERE COD_MUNI = R_HMUNI.COD_MUNI
                          AND COD_GCLM = R_HMUNI.COD_GCLM
                          AND DAT_HMGC = R_HMUNI.DAT_REF ;
                        IF SQL%FOUND THEN
                            W_QTD_INC_HMUNI_CAN := W_QTD_INC_HMUNI_CAN + 1;
                        ELSE
                            W_QTD_REJ_HMUNI_CAN  := W_QTD_REJ_HMUNI_CAN + 1;
                            GRAVA_MENSAGEM( 'HMUNI' , 'GMCH0021' , SQLCODE , SQLERRM ) ;
                        END IF ;
                  EXCEPTION
                  WHEN OTHERS THEN
                       W_QTD_REJ_HMUNI_CAN  := W_QTD_REJ_HMUNI_CAN  + 1;
                       GRAVA_MENSAGEM( 'HMUNI' , 'GMCH0022' , SQLCODE , SQLERRM ) ;
                  END;

           END LOOP;
         */

      --- FINALIZA ATUALIZACAO DO HISTORICO MERCADO GLOBAL
      IF g_param.atualiza = 'SIM'
      THEN
         COMMIT;
         Carga.gravalog ('*** ---------------- COMMIT ----------------*** ');
      ELSE
         ROLLBACK;
         Carga.gravalog ('*** ---------------- ROLLBACK ----------------*** ');
      END IF;

      ---- FINALIZA PROCESSO
      finaliza_job;
      grava_totais;

      IF g_param.atualiza = 'SIM'
      THEN
         Carga.gravalog
                  ('*** ---------------- FINAL DA CARGA ----------------*** ');
      ELSE
         Carga.gravalog
                  ('*** -------- FINAL DA CARGA SEM ATUALIZACAO --------*** ');
      END IF;

      UTL_FILE.FCLOSE (g_log);
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         grava_totais;
         Carga.gravalog (' erro : ' || SQLERRM);
         Carga.gravalog
                   ('*** ---------------- ERRO NA CARGA ----------------*** ');
         UTL_FILE.FCLOSE_ALL;
   END carga_hist_municipio;

-- INICIO CARGA OTA TMP
   PROCEDURE carga_inicial_ota (w_dat_ref IN DATE, nome_job IN VARCHAR2)
   IS
      -- VARIAVEIS
      dt_ref      DATE;
      i           BINARY_INTEGER;
      w_reg_ota   t_reg_ota;
      w_ota       VARCHAR (80);
      w_ret       VARCHAR2 (02)  := '  ';
      exdata      EXCEPTION;
      mes_ref     VARCHAR2 (7);
      numjob      BINARY_INTEGER;

      -- INICIA PROCEDURES INTERNAS
      PROCEDURE inicializa_area_ota
      IS
         nao_existe_ind   EXCEPTION;
         PRAGMA EXCEPTION_INIT (nao_existe_ind, -01418);
      BEGIN
         Carga.gravalog ('DROP INDEX IN1_TMP_OTA');

         BEGIN
            EXECUTE IMMEDIATE 'DROP INDEX IN1_TMP_OTA   ';
         EXCEPTION
            WHEN nao_existe_ind
            THEN
               Carga.gravalog
                    ('*** ---- INDICE PARA TABELA DO OTA NAO EXISTE ----*** ');
         END;

         Carga.gravalog ('TRUNCATE TABLE TMP_REG_OTA');

         EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_REG_OTA';
      END inicializa_area_ota;

      PROCEDURE grava_area_ota (w_reg IN t_reg_ota)
      IS
      BEGIN
         INSERT INTO tmp_reg_ota
                     (tip_ota, cod_ota, dat_med,
                      con_ota, dem_ota, obs_ota
                     )
              VALUES (w_reg.tip_ota, w_reg.cod_ota, w_reg.dat_med,
                      w_reg.con_ota, w_reg.dem_ota, w_reg.obs_ota
                     );

         g_reg_grav := g_reg_grav + 1;
         g_reg_held := g_reg_held + 1;

         IF g_reg_held >= g_qtd_held
         THEN
            COMMIT;
            g_reg_held := 0;
            Carga.gravalog (   ' QUANT. DE REG. GRAVADOS ATE O MOMENTO.... '
                            || TO_CHAR (g_reg_grav, '9999,999,999')
                           );
         END IF;
      END grava_area_ota;

      PROCEDURE finaliza_area_ota
      IS
         numjob          BINARY_INTEGER;
         ja_existe_ind   EXCEPTION;
         PRAGMA EXCEPTION_INIT (ja_existe_ind, -00955);
      BEGIN
         COMMIT;
         Carga.gravalog
            ('*** ---------- CRIA INDICE PARA GRANDES CONSUMIDORES --------*** '
            );

         BEGIN
             /*
            -- ALTERADO POR RENATO JR
            -- DATA 29/10/2003
            -- TROCA DO NOME DA TABLESPACE MCHTS01I PARA MCHTS01I

              EXECUTE IMMEDIATE  'CREATE INDEX IN1_TMP_OTA ON '                   ||
                                   'TMP_REG_OTA(DAT_MED  ,TIP_OTA , COD_OTA  ) ' ||
                                   'TABLESPACE MCHTS01I PCTFREE 10 '                      ||
                                   'STORAGE(INITIAL 10240K NEXT 8192K PCTINCREASE 0 ) ' ;
            */
            EXECUTE IMMEDIATE    'CREATE INDEX IN1_TMP_OTA ON '
                              || 'TMP_REG_OTA(DAT_MED  ,TIP_OTA , COD_OTA  ) '
                              || 'TABLESPACE MCHTSL01I PCTFREE 10 ';
         EXCEPTION
            WHEN ja_existe_ind
            THEN
               Carga.gravalog
                        ('*** ---- INDICE PARA TABELA OTA JA EXISTE ----*** ');
         END;
      END finaliza_area_ota;

      PROCEDURE mensagem_ota (w_num IN NUMBER, w_ret IN VARCHAR2)
      IS
         w_dt    DATE          := SYSDATE;
         w_msg   VARCHAR2 (80) := ' ';
      BEGIN
         w_dt := SYSDATE;

         IF w_ret = '01'
         THEN
            w_msg := '01 - ERRO NA FORMATACAO DO DADO NO ARQUIVO OTA ';
         ELSIF w_ret = '02'
         THEN
            w_msg := '02 - DATA INVALIDA ';
         ELSIF w_ret = '10'
         THEN
            w_msg := '10 - NO TAMANHHO DO REGISTRO OTA ';
         ELSE
            w_msg := w_ret || ' - ERRO NAO DESCONHECIDO ';
         END IF;

         g_rmsg :=
               '('
            || TO_CHAR (w_dt, 'DD/MM/YYYY.HH24:MI:SS')
            || '   LIN:'
            || TO_CHAR (w_num, '00000009')
            || ') » '
            || w_msg;
         UTL_FILE.PUT_LINE (g_msg, g_rmsg);
      END mensagem_ota;
   -- FINALIZA PROCEDURES INTERNAS
   BEGIN
      -- PARAMETROS DO SISTEMA
      parametros (g_param);
      dados_job (nome_job, g_job);
      inicializa_mensagem (g_job, g_job_msg);
      dt_ref := w_dat_ref;
      mes_ref := TO_CHAR (w_dat_ref, 'MONYYYY');
      g_reg_lidos := 0;
      g_reg_rej := 0;
      g_rej_conv := 0;
      g_reg_held := 0;
      g_reg_grav := 0;
      g_rej_data := 0;
      -- FORMATA NOME DOS ARQUIVOS
      g_nome_arq :=
            LOWER (TRIM (g_param.des_empresa))
         || '_ota_'
         || LOWER (mes_ref)
         || '.txt';
      g_nome_log :=
            LOWER (TRIM (g_param.des_empresa))
         || '_ota_'
         || LOWER (mes_ref)
         || '_log.txt';
      g_nome_bad :=
            LOWER (TRIM (g_param.des_empresa))
         || '_ota_'
         || LOWER (mes_ref)
         || '_bad_'
         || TO_CHAR (SYSDATE, 'DDMMYYYY_HHMISS')
         || '.txt';
      g_nome_msg :=
            LOWER (TRIM (g_param.des_empresa))
         || '_ota_'
         || LOWER (mes_ref)
         || '_msg_'
         || TO_CHAR (SYSDATE, 'DDMMYYYY_HHMISS')
         || '.txt';

      -- ABERTURA DO ARQUIVO DO ota
      BEGIN
         g_arq := UTL_FILE.FOPEN (g_dir_ent, g_nome_arq, 'r');
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            Carga.gravalog ('ERRO AO ABRIR O ARQUIVO DO OTA');
      --RAISE_APPLICATION_ERROR(-20000,'ERRO AO ABRIR O ARQUIVO DO OTA');
      END;

      -- ABERTURA DO ARQUIVO DE LOG
      BEGIN
         g_log := UTL_FILE.FOPEN (g_dir_sai, g_nome_log, 'a');
         g_bad := UTL_FILE.FOPEN (g_dir_sai, g_nome_bad, 'a');
         g_msg := UTL_FILE.FOPEN (g_dir_sai, g_nome_msg, 'a');
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            Carga.gravalog ('ERRO AO ABRIR O ARQUIVO DO OTA');
      --RAISE_APPLICATION_ERROR(-20000,'ERRO AO ABRIR O ARQUIVO DE LOG OTA');
      END;

      Carga.gravalog
                 ('*** ---------------- INICIO DA CARGA OTA -------------*** ');
      inicializa_area_ota;

      --CARGA.GRAVALOG(' DEPOIS DE INICIALIZA AREA ' ) ;

      -- Primeira leitura

      -- CARGA.GRAVALOG(' INICIANDO A PRIMEIRA LEITURA ' ) ;
      BEGIN
         UTL_FILE.GET_LINE (g_arq, w_ota);
      EXCEPTION
         WHEN UTL_FILE.READ_ERROR
         THEN
            UTL_FILE.FCLOSE_ALL;
            Carga.gravalog ('ERRO AO LER O ARQUIVO DO OTA');
            RAISE_APPLICATION_ERROR (-20000, 'ERRO AO LER O ARQUIVO DO OTA');
         WHEN NO_DATA_FOUND
         THEN
            UTL_FILE.FCLOSE_ALL;
            Carga.gravalog ('ERRO AO LER O ARQUIVO DO OTA(vazio)');
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO LER O ARQUIVO DO OTA(vazio)'
                                    );
         WHEN VALUE_ERROR
         THEN
            UTL_FILE.FCLOSE_ALL;
            Carga.gravalog ('ERRO AO LER O ARQUIVO DO OTA (VALOR INVALIDO)');
            RAISE_APPLICATION_ERROR
                             (-20000,
                              'ERRO AO LER O ARQUIVO DO OTA (VALOR INVALIDO)'
                             );
      END;

      -- CARGA.GRAVALOG(' FIM DA PRIMEIRA LEITURA ' ) ;

      -- VALIDA HEADER
      IF SUBSTR (w_ota, 1, 4) <> '****'
      THEN
         UTL_FILE.FCLOSE_ALL;
         Carga.gravalog ('ERRO ARQUIVO DO OTA (SEM HEADER)');
         RAISE_APPLICATION_ERROR (-20000, 'ERRO ARQUIVO DO OTA (SEM HEADER)');
      END IF;

      IF SUBSTR (w_ota, 5, 4) <> TO_CHAR (w_dat_ref, 'MMYY')
      THEN
         UTL_FILE.FCLOSE_ALL;
         Carga.gravalog ('ERRO ARQUIVO DO OTA (DATA INVALIDA)');
         RAISE_APPLICATION_ERROR (-20000,
                                  'ERRO ARQUIVO DO OTA (DATA INVALIDA)'
                                 );
      END IF;

      -- CARGA.GRAVALOG(' FIM DA LEITURA DO HEADER' ) ;

      -- Segunda leitura

      -- CARGA.GRAVALOG(' INICIANDO A SEGUNDA LEITURA ' ) ;
      BEGIN
         UTL_FILE.GET_LINE (g_arq, w_ota);
      EXCEPTION
         WHEN UTL_FILE.READ_ERROR
         THEN
            UTL_FILE.FCLOSE_ALL;
            Carga.gravalog ('ERRO AO LER O ARQUIVO DO OTA (DADOS) ');
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO LER O ARQUIVO DO OTA (DADOS) '
                                    );
         WHEN NO_DATA_FOUND
         THEN
            UTL_FILE.FCLOSE_ALL;
            Carga.gravalog ('ERRO AO LER O ARQUIVO DO OTA(SEM DADOS)');
            RAISE_APPLICATION_ERROR
                                   (-20000,
                                    'ERRO AO LER O ARQUIVO DO OTA(SEM DADOS)'
                                   );
         WHEN VALUE_ERROR
         THEN
            UTL_FILE.FCLOSE_ALL;
            Carga.gravalog ('ERRO AO LER O ARQUIVO DO OTA (DADO INVALIDO)');
            RAISE_APPLICATION_ERROR
                              (-20000,
                               'ERRO AO LER O ARQUIVO DO OTA (DADO INVALIDO)'
                              );
      END;

      -- CARGA.GRAVALOG(' FIM DA SEGUNDA LEITURA' ) ;
      g_reg_lidos := g_reg_lidos + 1;
      -- LOOP DE LEITURA DO OTA
      g_fim_ota := FALSE;
      Carga.gravalog (' INICIO DO LOOP ');

      WHILE NOT g_fim_ota
      LOOP
         IF LENGTH (w_ota) <= 80
         THEN
            -- TRANSFORMA STRING EM RECORD (OTA)
            w_ret := 'OK';

            BEGIN
               IF SUBSTR (w_ota, 1, 1) = '1'
               THEN
                  IF SUBSTR (w_ota, 2, 1) = '9'
                  THEN
                     w_reg_ota.tip_ota := 'G';
                  ELSE
                     w_reg_ota.tip_ota := 'P';
                  END IF;
               ELSIF SUBSTR (w_ota, 1, 1) = '2'
               THEN
                  w_reg_ota.tip_ota := 'B';
               ELSE
                  w_ret := '01';
               END IF;

               w_reg_ota.cod_ota := SUBSTR (w_ota, 2, 3);

               IF SUBSTR (w_ota, 7, 2) >= TO_CHAR (w_dat_ref, 'MM')
               THEN
                  w_reg_ota.dat_med :=
                     TO_DATE (   SUBSTR (w_ota, 5, 4)
                              || TO_CHAR (w_dat_ref, 'YYYY'),
                              'DDMMYYYY'
                             );
               ELSE
                  w_reg_ota.dat_med :=
                     TO_DATE (SUBSTR (w_ota, 5, 4)
                              || TO_CHAR (SYSDATE, 'YYYY'),
                              'DDMMYYYY'
                             );
               END IF;

               w_reg_ota.con_ota :=
                                 TO_NUMBER (SUBSTR (w_ota, 9, 9), '999999999');
               w_reg_ota.dem_ota :=
                                   TO_NUMBER (SUBSTR (w_ota, 18, 6), '999999');
               w_reg_ota.obs_ota := SUBSTR (w_ota, 24, 2);
            EXCEPTION
               WHEN OTHERS
               THEN
                  w_ret := '01';
            END;

            IF w_ret <> 'OK'
            THEN
               UTL_FILE.PUT_LINE (g_bad, w_ota);
               g_reg_rej := g_reg_rej + 1;
               mensagem_ota (g_reg_lidos, w_ret);
               Carga.gravalog (   '  ****  REGISTRO REJEITADO : '
                               || w_ret
                               || '  ****'
                              );
            ELSE
               grava_area_ota (w_reg_ota);
            END IF;
         ELSE                                           -- REJEITA POR TAMANHO
            UTL_FILE.PUT_LINE (g_bad, w_ota);
            g_reg_rej := g_reg_rej + 1;
            Carga.gravalog ('10 - ERROR (TAMANHO DO REGRISTO)');
            mensagem_ota (g_reg_lidos, '10');
         END IF;

         BEGIN
            UTL_FILE.GET_LINE (g_arq, w_ota);
            g_reg_lidos := g_reg_lidos + 1;
         EXCEPTION
            WHEN UTL_FILE.READ_ERROR
            THEN
               UTL_FILE.FCLOSE_ALL;
               Carga.gravalog ('ERRO AO LER O ARQUIVO DO OTA');
               RAISE_APPLICATION_ERROR (-20000,
                                        'ERRO AO LER O ARQUIVO DO OTA'
                                       );
            WHEN NO_DATA_FOUND
            THEN
               g_fim_ota := TRUE;
            WHEN VALUE_ERROR
            THEN
               UTL_FILE.FCLOSE_ALL;
               Carga.gravalog ('ERRO AO LER O ARQUIVO DO OTA(VALOR INVALIDO)');
               RAISE_APPLICATION_ERROR
                              (-20000,
                               'ERRO AO LER O ARQUIVO DO OTA(VALOR INVALIDO)'
                              );
            WHEN OTHERS
            THEN
               UTL_FILE.FCLOSE_ALL;
               Carga.gravalog
                  ('ERRO DESCONHECIDO AO LER O ARQUIVO DO OTA(VALOR INVALIDO)'
                  );
               RAISE_APPLICATION_ERROR
                  (-20000,
                   'ERRO DESCONHECIDO AO LER O ARQUIVO DO OTA(VALOR INVALIDO)'
                  );
         END;
      END LOOP;

      finaliza_area_ota;
      finaliza_job;
      Carga.gravalog (   ' QUANTIDADE DE REGISTROS LIDOS.... '
                      || TO_CHAR (g_reg_lidos, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANTIDADE DE REG. REJEITADOS.... '
                      || TO_CHAR (g_reg_rej, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANTIDADE DE REG. REJ. CONVERSAO '
                      || TO_CHAR (g_rej_conv, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE REG. GRAVADOS ......... '
                      || TO_CHAR (g_reg_grav, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. CONSUMIDORES FATURADOS ... '
                      || TO_CHAR (g_qtd_cons, '9999,999,999')
                     );
      Carga.gravalog (   ' CONSUMO TOTAL FATURADO .......... '
                      || TO_CHAR (g_con_tot_fat, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEMANDA TOTAL FATURADA .......... '
                      || TO_CHAR (g_dem_tot_fat, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' CONSUMO TOTAL CANCELADA ......... '
                      || TO_CHAR (g_con_tot_can, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEMANDA TOTAL CANCELADA ......... '
                      || TO_CHAR (g_dem_tot_can, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' CONSUMO TOTAL REFATURADO ........ '
                      || TO_CHAR (g_con_tot_ref, '999,999,999,999,999')
                     );
      Carga.gravalog (   ' DEMANDA TOTAL REFATURADO ........ '
                      || TO_CHAR (g_dem_tot_ref, '999,999,999,999,999')
                     );
      Carga.gravalog
               ('*** ---------------- FINAL DA CARGA OTA ----------------*** ');
      UTL_FILE.FCLOSE (g_arq);
      UTL_FILE.FCLOSE (g_log);
      UTL_FILE.FCLOSE (g_bad);
      UTL_FILE.FCLOSE (g_msg);
      UTL_FILE.FCLOSE_ALL;
   EXCEPTION
      WHEN OTHERS
      THEN
         Carga.gravalog (   ' QUANTIDADE DE REGISTROS LIDOS.... '
                         || TO_CHAR (g_reg_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE DE REG. REJEITADOS.... '
                         || TO_CHAR (g_reg_rej, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE DE REG. REJ. CONVERSAO '
                         || TO_CHAR (g_rej_conv, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE REG. GRAV ATE O MOMENTO '
                         || TO_CHAR (g_reg_grav, '9999,999,999')
                        );
         Carga.gravalog (' erro : ' || SQLERRM);
         Carga.gravalog
                ('*** ---------------- ERRO NA CARGA OTA ----------------*** ');
         UTL_FILE.FCLOSE_ALL;
   END carga_inicial_ota;

   -- INICIO CARGA OTA TMP

   -- INICIO CARGA OTA PSU
   PROCEDURE carga_psu (w_dat_ref IN DATE, nome_job IN VARCHAR2)
   AS
      --- CURSORES
      CURSOR c_ota_psu
      IS
         SELECT     *
               FROM tmp_reg_ota
              WHERE tip_ota = 'P'
         FOR UPDATE;

      r_psu         c_ota_psu%ROWTYPE;
      w_cod_psu     pontos_suprimento.cod_psu%TYPE;
      --- CONTADORES
      w_qtd_lidos   NUMBER (9)                       := 0;
      w_qtd_rej     NUMBER (9)                       := 0;
      w_qtd_inc     NUMBER (9)                       := 0;
   BEGIN
      -- PARAMETROS DO SISTEMA
      parametros (g_param);
      dados_job (nome_job, g_job);
      inicializa_mensagem (g_job, g_job_msg);
      g_nome_log :=
            LOWER (TRIM (g_param.des_empresa))
         || '_ota_'
         || LOWER (TO_CHAR (w_dat_ref, 'MONYYYY'))
         || '_log_CARGA_PSU.txt';

      -- ABERTURA DO ARQUIVO DE LOG
      BEGIN
         g_log := UTL_FILE.FOPEN (g_dir_sai, g_nome_log, 'a');
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO ABRIR O ARQUIVO DE LOG OTA PSU'
                                    );
      END;

      Carga.gravalog
               ('*** ---------- INICIO DA CARGA HIST PSU       ----------*** ');

      FOR r_psu IN c_ota_psu
      LOOP
         w_qtd_lidos := w_qtd_lidos + 1;

         --- VERIFICA SE EXISTE PSU
         BEGIN
            SELECT cod_psu
              INTO w_cod_psu
              FROM pontos_suprimento
             WHERE cod_psu = r_psu.cod_ota;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         --- DEFINE ERRO
         IF SQL%NOTFOUND
         THEN
            BEGIN
               UPDATE tmp_reg_ota
                  SET cod_erro = 'OTAP0001'
                WHERE CURRENT OF c_ota_psu;

               w_qtd_rej := w_qtd_rej + 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  RAISE_APPLICATION_ERROR
                                    (-20000,
                                     'ERRO AO ABRIR O ARQUIVO DE LOG OTA PSU'
                                    );
            END;
         ELSE
            --- INCLUI HISTORICO PSU
            BEGIN
               INSERT INTO hist_ponto_suprimento
                           (dat_hpsu, ener_atva, dema_atva,
                            cod_psu
                           )
                    VALUES (w_dat_ref, r_psu.con_ota, r_psu.dem_ota,
                            r_psu.cod_ota
                           );

               w_qtd_inc := w_qtd_inc + 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  BEGIN
                     UPDATE tmp_reg_ota
                        SET cod_erro = 'OTAP0002'
                      WHERE CURRENT OF c_ota_psu;

                     w_qtd_rej := w_qtd_rej + 1;
                     Carga.gravalog
                        (   'ERRO AO INCLUIR HISTORICO OTA PSU (DUPLICADO) COD_PSU: '
                         || r_psu.cod_ota
                        );
                  --RAISE_APPLICATION_ERROR(-20000,'ERRO AO INCLUIR HISTORICO OTA PSU (DUPLICADO) COD_PSU: ' || R_PSU.COD_OTA);
                  END;
            END;
         END IF;
      END LOOP;

      --- FINALIZA ATUALIZACAO DO HISTORICO OTA PSU
      IF g_param.atualiza = 'SIM'
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
      END IF;

      ---- FINALIZA PROCESSO
      finaliza_job;
      Carga.gravalog (   ' QUANTIDADE DE REGISTROS LIDOS.... '
                      || TO_CHAR (w_qtd_lidos, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANTIDADE DE REG. REJEITADOS.... '
                      || TO_CHAR (w_qtd_rej, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE REG. HIST INCLUIDOS.... '
                      || TO_CHAR (w_qtd_inc, '9999,999,999')
                     );

      IF g_param.atualiza = 'SIM'
      THEN
         Carga.gravalog
                  ('*** ---------------- FINAL DA CARGA ----------------*** ');
      ELSE
         Carga.gravalog
                  ('*** -------- FINAL DA CARGA SEM ATUALIZACAO --------*** ');
      END IF;

      UTL_FILE.FCLOSE (g_log);
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         Carga.gravalog (   ' QUANTIDADE DE REGISTROS LIDOS.... '
                         || TO_CHAR (w_qtd_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE DE REG. REJEITADOS.... '
                         || TO_CHAR (w_qtd_rej, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE REG. HIST INCLUIDOS.... '
                         || TO_CHAR (w_qtd_inc, '9999,999,999')
                        );
         Carga.gravalog (' erro : ' || SQLERRM);
         Carga.gravalog
                    ('*** ---------------- ERRO NA CARGA ----------------*** ');
         UTL_FILE.FCLOSE_ALL;
   END carga_psu;

   -- FIM CARGA OTA PSU

   -- INICIO CARGA OTA BSE
   PROCEDURE carga_bse (w_dat_ref IN DATE, nome_job IN VARCHAR2)
   AS
      --- CURSORES
      CURSOR c_ota_bse
      IS
         SELECT     *
               FROM tmp_reg_ota
              WHERE tip_ota = 'B'
         FOR UPDATE;

      r_bse         c_ota_bse%ROWTYPE;
      w_cod_bse     barras_subestacoes.cod_bse%TYPE;
      --- CONTADORES
      w_qtd_lidos   NUMBER (9)                        := 0;
      w_qtd_rej     NUMBER (9)                        := 0;
      w_qtd_inc     NUMBER (9)                        := 0;
   BEGIN
      -- PARAMETROS DO SISTEMA
      parametros (g_param);
      dados_job (nome_job, g_job);
      inicializa_mensagem (g_job, g_job_msg);
      g_nome_log :=
            LOWER (TRIM (g_param.des_empresa))
         || '_ota_'
         || LOWER (TO_CHAR (w_dat_ref, 'MONYYYY'))
         || '_log_CARGA_BSE.txt';

      -- ABERTURA DO ARQUIVO DE LOG
      BEGIN
         g_log := UTL_FILE.FOPEN (g_dir_sai, g_nome_log, 'a');
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO ABRIR O ARQUIVO DE LOG OTA BSE'
                                    );
      END;

      Carga.gravalog
           ('*** ---------- INICIO DA CARGA HIST OTA BSE       ----------*** ');

      FOR r_bse IN c_ota_bse
      LOOP
         w_qtd_lidos := w_qtd_lidos + 1;

         --- VERIFICA SE EXISTE BSE
         BEGIN
            SELECT cod_bse
              INTO w_cod_bse
              FROM barras_subestacoes
             WHERE cod_bse = r_bse.cod_ota;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         --- DEFINE ERRO
         IF SQL%NOTFOUND
         THEN
            BEGIN
               UPDATE tmp_reg_ota
                  SET cod_erro = 'OTAB0001'
                WHERE CURRENT OF c_ota_bse;

               w_qtd_rej := w_qtd_rej + 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  Carga.gravalog (   'NAO EXISTE REGISTRO PARA COD_BSE: '
                                  || r_bse.cod_ota
                                 );
                  RAISE_APPLICATION_ERROR
                                      (-20000,
                                          'NAO EXISTE REGISTRO PARA COD_BSE: '
                                       || r_bse.cod_ota
                                      );
            END;
         ELSE
            --- INCLUI HISTORICO BSE
            BEGIN
               INSERT INTO hist_barras_subestacoes
                           (dat_hbse, val_ener_atva, val_dema_atva,
                            cod_bse
                           )
                    VALUES (w_dat_ref, r_bse.con_ota, r_bse.dem_ota,
                            r_bse.cod_ota
                           );

               w_qtd_inc := w_qtd_inc + 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  BEGIN
                     Carga.gravalog
                        (   'ERRO AO INCLUIR HISTORICO OTA BSE (DUPLICADO) COD_BSE: '
                         || r_bse.cod_ota
                        );

                     UPDATE tmp_reg_ota
                        SET cod_erro = 'OTAB0002'
                      WHERE CURRENT OF c_ota_bse;

                     w_qtd_rej := w_qtd_rej + 1;
                  END;
            --RAISE_APPLICATION_ERROR(-20000,'ERRO AO INCLUIR HISTORICO OTA BSE (DUPLICADO) COD_BSE: ' || R_BSE.COD_OTA);
            END;
         END IF;
      END LOOP;

      --- FINALIZA ATUALIZACAO DO HISTORICO OTA BSE
      IF g_param.atualiza = 'SIM'
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
      END IF;

      ---- FINALIZA PROCESSO
      finaliza_job;
      Carga.gravalog (   ' QUANTIDADE DE REGISTROS LIDOS.... '
                      || TO_CHAR (w_qtd_lidos, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANTIDADE DE REG. REJEITADOS.... '
                      || TO_CHAR (w_qtd_rej, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE REG. HIST INCLUIDOS.... '
                      || TO_CHAR (w_qtd_inc, '9999,999,999')
                     );

      IF g_param.atualiza = 'SIM'
      THEN
         Carga.gravalog
                  ('*** ---------------- FINAL DA CARGA ----------------*** ');
      ELSE
         Carga.gravalog
                  ('*** -------- FINAL DA CARGA SEM ATUALIZACAO --------*** ');
      END IF;

      UTL_FILE.FCLOSE (g_log);
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         Carga.gravalog (   ' QUANTIDADE DE REGISTROS LIDOS.... '
                         || TO_CHAR (w_qtd_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE DE REG. REJEITADOS.... '
                         || TO_CHAR (w_qtd_rej, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE REG. HIST INCLUIDOS.... '
                         || TO_CHAR (w_qtd_inc, '9999,999,999')
                        );
         Carga.gravalog (' erro : ' || SQLERRM);
         Carga.gravalog
                    ('*** ---------------- ERRO NA CARGA ----------------*** ');
         UTL_FILE.FCLOSE_ALL;
   END carga_bse;

   -- FIM CARGA OTA BSE

   -- INICIO CARGA OTA GER
   PROCEDURE carga_ger (w_dat_ref IN DATE, nome_job IN VARCHAR2)
   AS
      --- CURSORES
      CURSOR c_ota_ger
      IS
         SELECT     *
               FROM tmp_reg_ota
              WHERE tip_ota = 'G'
         FOR UPDATE;

      r_ger         c_ota_ger%ROWTYPE;
      w_cod_ger     geracoes_conces.cod_geco%TYPE;
      --- CONTADORES
      w_qtd_lidos   NUMBER (9)                      := 0;
      w_qtd_rej     NUMBER (9)                      := 0;
      w_qtd_inc     NUMBER (9)                      := 0;
   BEGIN
      -- PARAMETROS DO SISTEMA
      parametros (g_param);
      dados_job (nome_job, g_job);
      inicializa_mensagem (g_job, g_job_msg);
      g_nome_log :=
            LOWER (TRIM (g_param.des_empresa))
         || '_ota_'
         || LOWER (TO_CHAR (w_dat_ref, 'MONYYYY'))
         || '_log_CARGA_GER.txt';

      -- ABERTURA DO ARQUIVO DE LOG
      BEGIN
         g_log := UTL_FILE.FOPEN (g_dir_sai, g_nome_log, 'a');
      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH
         THEN
            RAISE_APPLICATION_ERROR (-20000,
                                     'ERRO AO ABRIR O ARQUIVO DE LOG OTA GER'
                                    );
      END;

      Carga.gravalog
           ('*** ---------- INICIO DA CARGA HIST OTA GER       ----------*** ');

      FOR r_ger IN c_ota_ger
      LOOP
         w_qtd_lidos := w_qtd_lidos + 1;

         --- VERIFICA SE EXISTE GER
         BEGIN
            SELECT cod_geco
              INTO w_cod_ger
              FROM geracoes_conces
             WHERE cod_geco = r_ger.cod_ota;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         --- DEFINE ERRO
         IF SQL%NOTFOUND
         THEN
            BEGIN
               UPDATE tmp_reg_ota
                  SET cod_erro = 'OTAG0001'
                WHERE CURRENT OF c_ota_ger;

               w_qtd_rej := w_qtd_rej + 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  RAISE_APPLICATION_ERROR
                                    (-20000,
                                     'ERRO AO ABRIR O ARQUIVO DE LOG OTA GER'
                                    );
            END;
         ELSE
            --- INCLUI HISTORICO GER
            --- OBS.: O VALOR DO CAMPO "CON_INTE" É INICIALMENTE ZERO (0), POIS SERA MODIFICADO
            ---       ONLINE. SEGUNDO INFORMAÇÕES OBTIDAS POR LISE NA DATA:31/01/2002.
            BEGIN
               INSERT INTO hist_geracoes_conces
                           (dat_hgco, val_ener_brut, con_inte,
                            val_dem_atva_hger, cod_geco
                           )
                    VALUES (w_dat_ref, r_ger.con_ota, 0,
                            r_ger.dem_ota, r_ger.cod_ota
                           );

               w_qtd_inc := w_qtd_inc + 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  BEGIN
                     Carga.gravalog
                        (   'ERRO AO INCLUIR HISTORICO OTA GER (DUPLICADO) COD_GER: '
                         || r_ger.cod_ota
                        );

                     UPDATE tmp_reg_ota
                        SET cod_erro = 'OTAG0002'
                      WHERE CURRENT OF c_ota_ger;

                     w_qtd_rej := w_qtd_rej + 1;
                  END;
            --RAISE_APPLICATION_ERROR(-20000,'ERRO AO INCLUIR HISTORICO OTA GER (DUPLICADO) COD_GER: ' || R_GER.COD_OTA);
            END;
         END IF;
      END LOOP;

      --- FINALIZA ATUALIZACAO DO HISTORICO OTA GER
      IF g_param.atualiza = 'SIM'
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
      END IF;

      ---- FINALIZA PROCESSO
      finaliza_job;
      Carga.gravalog (   ' QUANTIDADE DE REGISTROS LIDOS.... '
                      || TO_CHAR (w_qtd_lidos, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANTIDADE DE REG. REJEITADOS.... '
                      || TO_CHAR (w_qtd_rej, '9999,999,999')
                     );
      Carga.gravalog (   ' QUANT. DE REG. HIST INCLUIDOS.... '
                      || TO_CHAR (w_qtd_inc, '9999,999,999')
                     );

      IF g_param.atualiza = 'SIM'
      THEN
         Carga.gravalog
                  ('*** ---------------- FINAL DA CARGA ----------------*** ');
      ELSE
         Carga.gravalog
                  ('*** -------- FINAL DA CARGA SEM ATUALIZACAO --------*** ');
      END IF;

      UTL_FILE.FCLOSE (g_log);
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         Carga.gravalog (   ' QUANTIDADE DE REGISTROS LIDOS.... '
                         || TO_CHAR (w_qtd_lidos, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANTIDADE DE REG. REJEITADOS.... '
                         || TO_CHAR (w_qtd_rej, '9999,999,999')
                        );
         Carga.gravalog (   ' QUANT. DE REG. HIST INCLUIDOS.... '
                         || TO_CHAR (w_qtd_inc, '9999,999,999')
                        );
         Carga.gravalog (' erro : ' || SQLERRM);
         Carga.gravalog
                    ('*** ---------------- ERRO NA CARGA ----------------*** ');
         UTL_FILE.FCLOSE_ALL;
   END carga_ger;

   -- FIM CARGA OTA GER
   PROCEDURE atualiza_vm
   IS
   BEGIN
      /* ----- ATUALIZA VIEW DE TELAS ------------------------------- */
      /* Parte 3 */
      DBMS_SNAPSHOT.REFRESH ('MCH.V_CONS_CLASSE');
      /* Depende de HIST_MERCADO_GLOBAL_CONCES */
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_MGB_A_MAXCONS');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_MGB_M_TOT');
      /* depende de V_HIST_MGB_A_MAXCONS */
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_MGB_A_TOT');
      /* ----- ATUALIZA VIEW ACUMULADAS PARA BALANCO ENERGETICO ----- */
      DBMS_SNAPSHOT.REFRESH ('MCH.V_CESU_MES_REF');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_CLASSE_MERCADO_MES_REF');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_GECO_MES_REF');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_GRCO_MES_REF');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_BSE_LOCAL');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CESU_MES');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CESU_ACUM_ANO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CESU_ACUM_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CESU_ACUM_12');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CESU_ACUM_12_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CESU_MES_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GECO_MES');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GECO_ACUM_ANO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GECO_ACUM_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GECO_ACUM_12');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GECO_ACUM_12_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GECO_MES_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GRCO_MES');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GRCO_ACUM_ANO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GRCO_ACUM_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GRCO_ACUM_12');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GRCO_ACUM_12_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GRCO_MES_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_MERCADO_MES');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_MERCADO_ACUM_ANO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_MERCADO_ACUM_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_MERCADO_ACUM_12');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_MERCADO_ACUM_12_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_MERCADO_MES_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_MUNI_MERCADO_A');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_PSU_MES_REF');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_PSU_MES');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_PSU_ACUM_ANO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_PSU_ACUM_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_PSU_ACUM_12');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_PSU_ACUM_12_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_PSU_LOCAL');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_PSU_MES_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_TOTAL_CLASSE_54A');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_TOTAL_TENSAO_54A');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_MERCADO_ACUMULADO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GECO_ACUMULADO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CESU_ACUMULADO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_PSU_ACUMULADO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GRCO_ACUMULADO');
      /* DEVE SER RODADA APOS O MERCADO_ACUMULADO  */
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CLRAMO_ACUM');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CLRAMO_GRTE_ACUM');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_FAIXA_ACUM');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_SRAMO_ACUM');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_FAIXA_OUTROS');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GRTE_SCL_ACUM');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_SRAMO_ACUM');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_TARIFA_SCL_ACUM');
      /* Depende de V_HIST_FAIXA_ACUM */
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_FAIXA_BAL_ACUM');
      /* Depende de V_HIST_GRTE_SCL_ACUM */
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_GRTE_ACUM');
      /* Depende de V_HIST_SRAMO_ACUM */
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_RAMO_ACUM');
      /* Depende de V_HIST_RAMO_ACUM */
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_SCLASSE_ACUM');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CLASSE_ACUM');
      /* Depende de V_HIST_TARIFA_SCL_ACUM */
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_TARIFA_GRTE_ACUM');
      -- VIEW PARA GERAR O REL. DO BAL ANALÍTICO DE GERALDO
      -- POSSUE OS DADOS DOS 48 MESES ANTERIORES A DATA SOLITADA
      DBMS_SNAPSHOT.REFRESH ('MCH.V_63A_BAL_ANALITICO');
      -- VIEW SO PARA BUSCAR SOMENTE O NOME DO GRANDE CONSUMIDOR
      DBMS_SNAPSHOT.REFRESH ('MCH.V_GRCO_NOM');
      /* VIEWS MATERIALIZADAS DA TERCEIRA ETAPA */
      -- IMPORTE DO CONSUMO
      DBMS_SNAPSHOT.REFRESH ('MCH.V_IMPORTE_CLA_TENSAO_ANO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_CONS_ENERGIA_PLANTE');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_CONS_ENERGIA_CLA_ANO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_CONS_ENERGIA_CLA_ANOANT');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_CONS_ENERGIA_PLCLA_ANO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_CONS_ENERGIA_CLA_ANO_ACUM');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_CONS_ENERGIA_CLA_ANOANT_ACUM');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_CONS_ENERGIA_PLCLA_ANO_ACUM');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CARGA_ANO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CARGA_ANO_ACUM');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CARGA_PREV_ANO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_HIST_CARGA_PREV_ANO_ACUM');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_BAL_ENER_TIPO_ANO');
      DBMS_SNAPSHOT.REFRESH ('MCH.V_BAL_ENER_TIPO_ANO_ACUM');
   END;
-- Ajuste de carga
-- Tirar depois
/* TIRAR DEPOIS */
/*
 PROCEDURE Ajusta_CARGA_HIST_MUNICIPIO
  IS
  --- CURSORES
  CURSOR         C_HMUNI_REF IS
                 SELECT *  FROM VM_TMP_MUNI
                   WHERE TIP_FAT = 'REF' ;

  CURSOR         C_HMUNI_CAN IS
                 SELECT *  FROM VM_TMP_MUNI
                   WHERE TIP_FAT = 'CAN' ;

  --- VARIAVEIS AUXILIARES

  R_HMUNI         VM_TMP_MUNI%ROWTYPE;

  W_COD_MUNI      C_MUNICIPIOS.COD_MUNI%TYPE ;
  W_COD_GCLM      MUNICIPIOS_CLASSES_MERCADO.COD_GCLM%TYPE;

  --- ACUMULADORES

  W_QTD_INC_MUNI         NUMBER := 0;
  W_QTD_REJ_MUNI         NUMBER := 0;
  W_QTD_INC_MUNICL       NUMBER := 0;
  W_QTD_REJ_MUNICL       NUMBER := 0;
  W_QTD_INC_HMUNI_FAT    NUMBER := 0;
  W_QTD_REJ_HMUNI_FAT    NUMBER := 0;
  W_QTD_INC_HMUNI_REF    NUMBER := 0;
  W_QTD_REJ_HMUNI_REF    NUMBER := 0;
  W_QTD_INC_HMUNI_CAN    NUMBER := 0;
  W_QTD_REJ_HMUNI_CAN    NUMBER := 0;
  W_QTD_MUNI_LIDOS       NUMBER := 0;
  W_QTD_MUNICL_LIDOS     NUMBER := 0;
  W_QTD_HMUNI_LIDOS_FAT  NUMBER := 0;
  W_QTD_HMUNI_LIDOS_REF  NUMBER := 0;
  W_QTD_HMUNI_LIDOS_CAN  NUMBER := 0;

  W_VAL_TOT_REAJ_REF     NUMBER := 0;
  W_QTD_TOT_REAJ_REF     NUMBER := 0;
  W_VAL_TOT_REAJ_CAN     NUMBER := 0;
  W_QTD_TOT_REAJ_CAN     NUMBER := 0;

   --- ROTINAS INTERNAS
  PROCEDURE GRAVA_TOTAIS
  IS
  BEGIN
       CARGA.GRAVALOG(' QUANTIDADE DE MUNICIPIOS LIDOS...'  || TO_CHAR( W_QTD_MUNI_LIDOS   ,'9999,999,999')) ;
       CARGA.GRAVALOG(' QUANTIDADE DE MUNICIP. REJEITADOS ' || TO_CHAR( W_QTD_REJ_MUNI     ,'9999,999,999')) ;
       CARGA.GRAVALOG(' QUANTIDADE DE MUNICIP. INCLUIDAS  ' || TO_CHAR( W_QTD_INC_MUNI     ,'9999,999,999')) ;

       CARGA.GRAVALOG(' QUANT. DE MUNI/CLASSE LIDOS......' || TO_CHAR( W_QTD_MUNICL_LIDOS   ,'9999,999,999')) ;
       CARGA.GRAVALOG(' QUANT. DE MUNI/CLASSE REJEITADAS.' || TO_CHAR( W_QTD_REJ_MUNICL     ,'9999,999,999')) ;
       CARGA.GRAVALOG(' QUANT. DE MUNI/CLASSE INCLUIDA...' || TO_CHAR( W_QTD_INC_MUNICL    ,'9999,999,999')) ;

       CARGA.GRAVALOG(' QUANT. DE HIST.MUNI FAT LIDOS......' || TO_CHAR( W_QTD_HMUNI_LIDOS_FAT  ,'9999,999,999')) ;
       CARGA.GRAVALOG(' QUANT. DE HIST.MUNI FAT REJEITADAS.' || TO_CHAR( W_QTD_REJ_HMUNI_FAT    ,'9999,999,999')) ;
       CARGA.GRAVALOG(' QUANT. DE HIST.MUNI FAT INCLUIDA...' || TO_CHAR( W_QTD_INC_HMUNI_FAT    ,'9999,999,999')) ;

       CARGA.GRAVALOG(' QUANT. DE HIST.MUNI REF LIDOS......' || TO_CHAR( W_QTD_HMUNI_LIDOS_REF  ,'9999,999,999')) ;
       CARGA.GRAVALOG(' QUANT. DE HIST.MUNI REF REJEITADAS.' || TO_CHAR( W_QTD_REJ_HMUNI_REF    ,'9999,999,999')) ;
       CARGA.GRAVALOG(' QUANT. DE HIST.MUNI REF INCLUIDA...' || TO_CHAR( W_QTD_INC_HMUNI_REF    ,'9999,999,999')) ;

       CARGA.GRAVALOG(' QUANT. DE HIST.MUNI CAN LIDOS......' || TO_CHAR( W_QTD_HMUNI_LIDOS_CAN  ,'9999,999,999')) ;
       CARGA.GRAVALOG(' QUANT. DE HIST.MUNI CAN REJEITADAS.' || TO_CHAR( W_QTD_REJ_HMUNI_CAN    ,'9999,999,999')) ;
       CARGA.GRAVALOG(' QUANT. DE HIST.MUNI CAN INCLUIDA...' || TO_CHAR( W_QTD_INC_HMUNI_CAN    ,'9999,999,999')) ;

       CARGA.GRAVALOG(' VAL TOT CONSUMO REF ...............' || TO_CHAR( W_VAL_TOT_REAJ_REF    ,'9999,999,999')) ;
       CARGA.GRAVALOG(' QTD TOT CONSUMO REF ...............' || TO_CHAR( W_QTD_TOT_REAJ_REF    ,'9999,999,999')) ;

       CARGA.GRAVALOG(' VAL TOT CONSUMO CAN ...............' || TO_CHAR( W_VAL_TOT_REAJ_CAN    ,'9999,999,999')) ;
       CARGA.GRAVALOG(' QTD TOT CONSUMO CAN ...............' || TO_CHAR( W_QTD_TOT_REAJ_CAN    ,'9999,999,999')) ;

  END GRAVA_TOTAIS;


 BEGIN
      G_NOME_LOG := 'gmch_JAN2002_log_AJUSTE_CRG_MUNI.txt' ;


  -- ABERTURA DO ARQUIVO DE LOG
       BEGIN
          G_LOG := UTL_FILE.FOPEN(G_DIR_SAI, G_NOME_LOG  , 'a'  );
       EXCEPTION
       WHEN UTL_FILE.INVALID_PATH THEN
            RAISE_APPLICATION_ERROR(-20000,'ERRO AO ABRIR O ARQUIVO DE LOG');
       END;

       CARGA.GRAVALOG( '*** ---------- INICIO DA CARGA HIST MUNICIPIO ----------*** ' ) ;

       -- PARAMETROS DO SISTEMA
      CARGA.GRAVALOG( 'TIRANDO DADOS_JOB');
      PARAMETROS(G_PARAM);
       --DADOS_JOB(NOME_JOB,G_JOB);

       CARGA.GRAVALOG( '*** ---------- LIMPA A TABELA DE ERROS  ----------------*** ' ) ;
       EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MUNI_BAD' ;

       CARGA.GRAVALOG( '*** ---------- ATUALIZACAO HISTORICO FATURADO  -------*** ' ) ;


       CARGA.GRAVALOG( '*** ------- AJUSTA O HISTORICO REFATURADO  -------*** ' ) ;

       FOR R_HMUNI IN C_HMUNI_REF LOOP
           --- AJUSTA HISTORICO MERCADO
            IF '01/2002' <> TO_CHAR(R_HMUNI.DAT_REF,'MM/YYYY') THEN
               W_QTD_HMUNI_LIDOS_REF :=  W_QTD_HMUNI_LIDOS_REF + 1 ;
                 --CARGA.GRAVALOG( ' ');
                 --CARGA.GRAVALOG( 'AJUSTE P/ A DATA      : ' || R_HMUNI.DAT_REF);
                 --CARGA.GRAVALOG( 'MUNICIPIO             : ' || R_HMUNI.COD_MUNI);
                 --CARGA.GRAVALOG( 'CLASSE                : ' || R_HMUNI.COD_GCLM);
                 --CARGA.GRAVALOG( 'VALOR A SER AJUSTADO  : ' || R_HMUNI.CON_TOT);
                 --CARGA.GRAVALOG( 'QUANTIDADE AJUSTADA   : ' || R_HMUNI.QTD_CONS);
              BEGIN
                    UPDATE HIST_MUNICIPIO_MERCADO
                       SET  CON_HMGC  =  CON_HMGC - R_HMUNI.CON_TOT
                         ,  QTD_CONS  =  QTD_CONS - R_HMUNI.QTD_CONS
                    WHERE COD_MUNI = R_HMUNI.COD_MUNI
                      AND COD_GCLM = R_HMUNI.COD_GCLM
                      AND DAT_HMGC = R_HMUNI.DAT_REF ;
                    IF SQL%FOUND THEN
                        W_QTD_INC_HMUNI_REF := W_QTD_INC_HMUNI_REF + 1;
                  W_VAL_TOT_REAJ_REF  := W_VAL_TOT_REAJ_REF + R_HMUNI.CON_TOT;
                  W_QTD_TOT_REAJ_REF  := W_QTD_TOT_REAJ_REF + R_HMUNI.QTD_CONS;
                    ELSE
                        W_QTD_REJ_HMUNI_REF  := W_QTD_REJ_HMUNI_REF  + 1;
                    END IF ;
                  EXCEPTION
                  WHEN OTHERS THEN
                     W_QTD_REJ_HMUNI_REF  := W_QTD_REJ_HMUNI_REF  + 1;
                  END;
            END IF;
       END LOOP;


   --- CARREGA HISTORICO CANCELADO

       CARGA.GRAVALOG( '*** ------- AJUSTA HISTORICO CANCELADO  -------*** ' ) ;

       FOR R_HMUNI IN C_HMUNI_CAN LOOP
           --- INCLUI HISTORICO MERCADO
            IF '01/2002' <> TO_CHAR(R_HMUNI.DAT_REF,'MM/YYYY') THEN
                -- CARGA.GRAVALOG( ' ');
                -- CARGA.GRAVALOG( 'AJUSTE P/ A DATA      : ' || R_HMUNI.DAT_REF);
                -- CARGA.GRAVALOG( 'MUNICIPIO             : ' || R_HMUNI.COD_MUNI);
                -- CARGA.GRAVALOG( 'CLASSE                : ' || R_HMUNI.COD_GCLM);
                -- CARGA.GRAVALOG( 'VALOR A SER AJUSTADO  : ' || R_HMUNI.CON_TOT);
                -- CARGA.GRAVALOG( 'QUANTIDADE AJUSTADA   : ' || R_HMUNI.QTD_CONS);
                 W_QTD_HMUNI_LIDOS_CAN :=  W_QTD_HMUNI_LIDOS_CAN + 1 ;
                 BEGIN
                    UPDATE HIST_MUNICIPIO_MERCADO
                       SET  CON_HMGC  =  CON_HMGC + R_HMUNI.CON_TOT
                         ,  QTD_CONS  =  QTD_CONS + R_HMUNI.QTD_CONS
                    WHERE COD_MUNI = R_HMUNI.COD_MUNI
                      AND COD_GCLM = R_HMUNI.COD_GCLM
                      AND DAT_HMGC = R_HMUNI.DAT_REF ;
                    IF SQL%FOUND THEN
                  W_VAL_TOT_REAJ_CAN  := W_VAL_TOT_REAJ_CAN + R_HMUNI.CON_TOT;
                  W_QTD_TOT_REAJ_CAN  := W_QTD_TOT_REAJ_CAN + R_HMUNI.QTD_CONS;
                        W_QTD_INC_HMUNI_CAN := W_QTD_INC_HMUNI_CAN + 1;
                    ELSE
                        W_QTD_REJ_HMUNI_CAN  := W_QTD_REJ_HMUNI_CAN + 1;
                    END IF ;
                 EXCEPTION
                 WHEN OTHERS THEN
                      W_QTD_REJ_HMUNI_CAN  := W_QTD_REJ_HMUNI_CAN  + 1;
                 END;
            END IF;
       END LOOP;

       --- FINALIZA ATUALIZACAO DO HISTORICO MERCADO GLOBAL

       IF G_PARAM.ATUALIZA = 'SIM' THEN
          COMMIT;
        CARGA.GRAVALOG('*** -------- COMMIT --------*** ' ) ;
       ELSE
          ROLLBACK;
        CARGA.GRAVALOG('*** -------- ROLLBACK --------*** ' ) ;
       END IF;

       ---- FINALIZA PROCESSO
       --FINALIZA_JOB;
       GRAVA_TOTAIS;
       IF G_PARAM.ATUALIZA = 'SIM' THEN
          CARGA.GRAVALOG('*** ---------------- FINAL DO AJUSTE DA CARGA ----------------*** ' ) ;
       ELSE
          CARGA.GRAVALOG('*** -------- FINAL DO AJUSTE DA CARGA SEM ATUALIZACAO --------*** ' ) ;
       END IF;

       UTL_FILE.FCLOSE(G_LOG);

EXCEPTION
     WHEN others  THEN
       ROLLBACK;
       GRAVA_TOTAIS;
       CARGA.GRAVALOG(' erro : ' || SQLERRM ) ;
       CARGA.GRAVALOG('*** ---------------- ERRO DO AJUSTE DA CARGA ----------------*** ' ) ;
       UTL_FILE.fclose_all;
END Ajusta_CARGA_HIST_MUNICIPIO ;
*/
END Carga;                                               -- Package Body CARGA
/
