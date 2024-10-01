CREATE OR REPLACE PACKAGE carga
IS
--
   -- Enter package declarations as shown below
   TYPE t_dados_conceito IS RECORD (
      conceito_energia   CHAR (03),
      con_lido           NUMBER (11, 2),
      con_fat            NUMBER (11, 2),
      val_ajuste         NUMBER (11, 2),
      imp_conceito       NUMBER (13, 2),
      imp_base_icms      NUMBER (13, 2)
   );

   TYPE t_con IS TABLE OF t_dados_conceito
      INDEX BY BINARY_INTEGER;

   TYPE t_cod_poblacion IS RECORD (
      cod_mun   NUMBER (03),
      cod_loc   NUMBER (02),
      bairro    NUMBER (03)
   );

   TYPE t_punto_suministro IS RECORD (
      cod_provincia     NUMBER (02),
      cod_pob           t_cod_poblacion,
      cod_calle         NUMBER (05),
      cod_finca         NUMBER (04),
      cod_punto_sumin   NUMBER (03)
   );

   TYPE t_cla_subcla IS RECORD (
      cod_classe   CHAR (01),
      cod_subcla   CHAR (01)
   );

   TYPE t_ramo_subramo IS RECORD (
      cod_ramo      CHAR (02),
      cod_subramo   CHAR (02)
   );

   TYPE t_cod_cnae IS RECORD (
      cla    t_cla_subcla,
      ramo   t_ramo_subramo,
      fil    CHAR (01)
   );

   TYPE t_reg_sic IS RECORD (
      tip_rectif         CHAR (02),
      cod_contrato       CHAR (10),
      tip_est_contrato   CHAR (02),
      cod_cliente        CHAR (08),
      num_factura        CHAR (26),
      tip_factura        CHAR (03),
      tip_factrn_nor     CHAR (02),
      p_sumi             t_punto_suministro,
      cod_org_inter_of   NUMBER (03),
      cod_org_inter_ut   NUMBER (03),
      cod_org_inter_uo   NUMBER (03),
      cod_org_inter_ur   NUMBER (03),
      cod_cnae           t_cod_cnae,
      cod_tarifa         CHAR (04),
      cod_tarifa_dou     CHAR (03),
      carga_instal       NUMBER (09),
      perda_transf       NUMBER (5, 4),
      cod_tension        CHAR (02),
      data_leitura_de    DATE,
      data_leitura_ate   DATE,
-- mch2etp - inicio
      data_inicio_fat    DATE,
      data_fat           DATE,
      dem_ctda_pta       NUMBER (09),
      dem_ctda_fpta      NUMBER (09),
      tip_mot_can        CHAR (02)
   
-- mch2etp - final
   );

/*
  TYPE T_REG_MCH IS RECORD
      ( DAT_REF            DATE            ,
        TIP_FAT            VARCHAR2 (3)    ,
        COD_GRCO           VARCHAR2 (10)   ,
        COD_MUNI           NUMBER   (3)    ,
        COD_LOC            NUMBER   (2)    ,
        COD_BAIR           NUMBER   (3)    ,
        COD_ATEC           VARCHAR2 (7)    ,
        COD_FXA            NUMBER   (2)    ,
        COD_GRP_TSTA       NUMBER   (2)    ,
        COD_GCLM           VARCHAR2 (2)    ,
        CON_PTA            NUMBER   (9)    ,
        DEM_PTA            NUMBER   (9)    ,
        CON_FPTA           NUMBER   (9)    ,
        DEM_FPTA           NUMBER   (9)    ,
        IMP_DEM            NUMBER   (15,2) ,
        IMP_CON            NUMBER   (15,2) ,
        VAL_ECE            NUMBER   (13,2) ,
        VAL_IUEE           NUMBER   (13,2) ,
        POT_INSD           NUMBER   (9)    ,
        DEM_CTDA_PTA       NUMBER   (9)    ,
        DEM_CTDA_FPTA      NUMBER   (9)    ,
        IND_GRCO           VARCHAR2 (1)    ,
        IND_CONT           NUMBER(1)       ,
--- mch2etp - inicio -- novos campos acumuladores
        DEM_LDA_PTA        NUMBER(13,2)    ,          --- demanda lida na ponta
        DEM_LDA_FPTA       NUMBER(13,2)    ,          --- demanda lida fora de ponta
        DEM_ULT_PTA        NUMBER(13,2)    ,          --- demanda de ultrapassagem  na ponta
        DEM_ULT_FPTA       NUMBER(13,2)    ,          --- demanda de ultrapassgem fora de ponta
        DEM_FORN           NUMBER(13,2)    ,          --- demanda de fornecimento
        CON_RESV           NUMBER(13,2)    ,          --- consumo reservado
        DAT_INI_CTR        DATE                       --- data inicio do contrato
--- mch2etp - fim
        )     ;
      */
   TYPE t_fxa_grte IS TABLE OF mch.faixas_trf_grte%ROWTYPE
      INDEX BY BINARY_INTEGER;

   TYPE t_fxa IS TABLE OF mch.faixas_consumo%ROWTYPE
      INDEX BY BINARY_INTEGER;

   TYPE t_reg_ota IS RECORD (
      tip_ota   VARCHAR2 (1),
      cod_ota   VARCHAR2 (3),
      dat_med   DATE,
      con_ota   NUMBER (9),
      dem_ota   NUMBER (6),
      obs_ota   VARCHAR2 (2)
   );

   -- VARIAVEIS GLOBAIS
   g_job_msg             jobs_mensagens%ROWTYPE;
   g_job                 jobs_carga%ROWTYPE;
   g_param               parametros_carga%ROWTYPE;
   g_fxa                 t_fxa;
   g_fxa_grte            t_fxa_grte;
   g_reg                 t_reg_sic;
   g_arq                 UTL_FILE.file_type;
   g_bad                 UTL_FILE.file_type;
   g_log                 UTL_FILE.file_type;
   g_msg                 UTL_FILE.file_type;
   g_rsic                VARCHAR2 (2199);                           ---(2197);
   g_tam_sic             NUMBER (4)                 := 2201;        -- 2199  ;
   g_rlog                VARCHAR2 (133);
   g_rmsg                VARCHAR2 (200);
   g_dir_ent             VARCHAR2 (100)
                      := '\\ADM_NT30\INTEGRA\\COELBA\Comercial\Gmch\Entradas\';
   g_dir_sai             VARCHAR2 (100)
                      := '\\ADM_NT30\INTEGRA\\COELBA\Comercial\Gmch\Saidas\';
   g_nome_arq            VARCHAR2 (100)             := 'gmch.txt';
   g_nome_log            VARCHAR2 (100)             := 'LOG.txt';
                                                        --- 'sic_out2001.txt';
   g_nome_bad            VARCHAR2 (100)             := 'BAD.BAD';
                                                        --- 'sic_out2001.txt';
   g_nome_msg            VARCHAR2 (100)             := 'MSG.BAD';
                                                        --- 'sic_out2001.txt';
   g_cod_grco_ant        VARCHAR2 (10);
   -- CONSTANTES
   g_qtd_held   CONSTANT NUMBER (09)                := 5000;
   -- VARIAVEIS LOGICAS
   g_fim_sic             BOOLEAN                    := FALSE;
   g_fim_ota             BOOLEAN                    := FALSE;
   -- CONTADORES
   g_reg_lidos           NUMBER (10)                := 0;
   g_reg_rej             NUMBER (10)                := 0;
   g_rej_conv            NUMBER (10)                := 0;
   g_rej_data            NUMBER (10)                := 0;
   g_reg_held            NUMBER (10)                := 0;
   g_reg_grav            NUMBER (10)                := 0;
   g_qtd_cons            NUMBER (10)                := 0;
   g_con_tot_fat         NUMBER (15)                := 0;
   g_dem_tot_fat         NUMBER (15)                := 0;
   g_con_tot_can         NUMBER (15)                := 0;
   g_dem_tot_can         NUMBER (15)                := 0;
   g_con_tot_ref         NUMBER (15)                := 0;
   g_dem_tot_ref         NUMBER (15)                := 0;
   --- mch2etp - inicio
   g_tar_con             NUMBER (10)                := 0;
   g_tar_hza             NUMBER (10)                := 0;
   g_tar_hzv             NUMBER (10)                := 0;
   g_tar_out             NUMBER (10)                := 0;
   g_dem_lda_tot_fat     NUMBER (15)                := 0;
   g_dem_ult_tot_fat     NUMBER (15)                := 0;
   g_dem_forn_tot_fat    NUMBER (15)                := 0;
   g_con_resv_tot_fat    NUMBER (15)                := 0;
   g_dem_lda_tot_ref     NUMBER (15)                := 0;
   g_dem_ult_tot_ref     NUMBER (15)                := 0;
   g_dem_forn_tot_ref    NUMBER (15)                := 0;
   g_con_resv_tot_ref    NUMBER (15)                := 0;
   g_dem_lda_tot_can     NUMBER (15)                := 0;
   g_dem_ult_tot_can     NUMBER (15)                := 0;
   g_dem_forn_tot_can    NUMBER (15)                := 0;
   g_con_resv_tot_can    NUMBER (15)                := 0;
   --- mch2etp - fim

   -- EXCECOES
   sic_invalido          EXCEPTION;

   PROCEDURE parametros (w_param OUT parametros_carga%ROWTYPE);

   PROCEDURE dados_job (nome_job IN VARCHAR2, w_job OUT jobs_carga%ROWTYPE);

   PROCEDURE carga_inicial (data_ref IN DATE, nome_job IN VARCHAR2);

   PROCEDURE carga_inicial_ota (w_dat_ref IN DATE, nome_job IN VARCHAR2);

   PROCEDURE gravalog (texto IN VARCHAR2);

   PROCEDURE disp (w_reg IN VARCHAR2);

   PROCEDURE atualiza_views (data_ref IN DATE, nome_job IN VARCHAR2);

   PROCEDURE cria_indices (data_ref IN DATE, nome_job IN VARCHAR2);

   PROCEDURE executa_job (
      data_ref   IN       DATE,
      nome_job   IN       VARCHAR2,
      numjob     IN OUT   BINARY_INTEGER
   );

   PROCEDURE carga_hist_mercado (data_ref IN DATE, nome_job IN VARCHAR2);

   PROCEDURE carga_hist_grco (data_ref IN DATE, nome_job IN VARCHAR2);

   PROCEDURE carga_hist_localidade (data_ref IN DATE, nome_job IN VARCHAR2);

   PROCEDURE carga_hist_municipio (data_ref IN DATE, nome_job IN VARCHAR2);

   -- PROCEDURE Ajusta_CARGA_HIST_MUNICIPIO;

   -- CARGA OTA ( PSU , BSE , GER )
   PROCEDURE carga_psu (w_dat_ref IN DATE, nome_job IN VARCHAR2);

   PROCEDURE carga_bse (w_dat_ref IN DATE, nome_job IN VARCHAR2);

   PROCEDURE carga_ger (w_dat_ref IN DATE, nome_job IN VARCHAR2);

   -- PROCEDURE PARA ATUALIZAR AS VIEWS MATERIALIZADAS
   PROCEDURE atualiza_vm;
END;                                          -- Especificacao do pacote CARGA
/
