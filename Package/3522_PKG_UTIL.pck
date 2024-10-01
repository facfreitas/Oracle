CREATE OR REPLACE PACKAGE PKG_UTIL AS
-- $Header: PKG_UTIL_PKS.pls 120.1 01/08/12 12:00:00 appldev ship $
/**********************************************************************************************/
/* PKG_UTIL                                                                                   */
/*                                                                                            */
/* Procedure PRC_Tablespace - Lista informacoes das tablespaces                               */
/*                                                                                            */
/* Desenvolvida: 20/02/2012 - Dimas Barreto                                                   */
/*                                                                                            */
/* Alteracoes: 11/03/2013 - Ednei Ferreira                                                    */
/*             Inclusao da procedure PRC_VERIFICA_AMBIENTE  que objetiva a validacao de       */
/*             algumas tabelas de parametros que nao devem ser alteradas em ambiente nao      */
/*             produtivo                                                                      */
/*                                                                                            */
/* Alteracoes: 17/04/2013 - Ednei Ferreira                                                    */
/*             Inclusao da procedure PRC_TABLESPACE_EMAIL, para enviar email quando estiver   */
/*             faltando espaco na tablespaces.                                                */
/*                                                                                            */
/* Alteracoes: 16/05/2013 - Dimas Barreto                                                     */
/*             Alteradas as procedures para validar a tabela BKP_TABELAS                      */
/*                                                                                            */ 
/* Alteracoes: 20/05/2013 - Ednei Ferreira                                                    */
/*             Incluido a procedure PRC_MONTA_PACKAGES                                        */
/*                                                                                            */
/* Alteracoes: 01/06/2013 - Dimas Barreto                                                     */
/*             Criacao da PRC_JOB                                                             */
/**********************************************************************************************/

/* ***************************************************************************************** */
/*                                       TABELA ASCII                                        */
/* ***************************************************************************************** */
/*  Para Acentuacao, veja as funcoes:                                                        */
/*  SELECT ASCII('¿') cod_caracter , CHR(191) caracter FROM dual;                            */ 
/*                                                                                           */
/* ***************************************************************************************** */                              
  PROCEDURE PRC_TABLESPACE (lista out sys_refcursor);
     
  PROCEDURE PRC_TABLESPACE_MAIL;

  PROCEDURE PRC_EMAIL_PENDENTE; 
  
  PROCEDURE PRC_LISTA_TABELAS (lista out sys_refcursor);
  
  procedure PRC_EMAIL (p_origem   in varchar2, 
                       p_destino  in varchar2,
                       p_assunto  in varchar2,
                       p_mensagem in varchar2);
                       
  PROCEDURE PRC_VERIFICA_AMBIENTE (TABELA IN VARCHAR2);
     
  FUNCTION FNC_QTD (p_tabela in varchar2) return number;
     
  PROCEDURE PRC_MONTA_PACKAGES (P_OWNER         IN VARCHAR2
                              , P_TABELA        IN VARCHAR2
                              , P_DESENVOLVEDOR IN VARCHAR2);

  procedure PRC_JOB;
  
  PROCEDURE PRC_DDL( p_n_import  number default null);  
  
END PKG_UTIL;
/
CREATE OR REPLACE PACKAGE BODY PKG_UTIL AS
-- $Header: PKG_UTIL_PKB.pls 120.1 01/08/12 12:00:00 appldev ship $
/**********************************************************************************************/
/* PKG_UTIL                                                                                   */
/*                                                                                            */
/* Procedure PRC_Tablespace - Lista informacoes das tablespaces                               */
/*                                                                                            */
/* Desenvolvida: 20/02/2012 - Dimas Barreto                                                   */
/*                                                                                            */
/* Alteracoes: 11/03/2013 - Ednei Ferreira                                                    */
/*             Inclusao da procedure PRC_VERIFICA_AMBIENTE  que objetiva a validacao de       */
/*             algumas tabelas de parametros que nao devem ser alteradas em ambiente nao      */
/*             produtivo                                                                      */
/*                                                                                            */
/* Alteracoes: 17/04/2013 - Ednei Ferreira                                                    */
/*             Inclusao da procedure PRC_TABLESPACE_EMAIL, para enviar email quando estiver   */
/*             faltando espaco na tablespaces.                                                */
/*                                                                                            */
/* Alteracoes: 16/05/2013 - Dimas Barreto                                                     */
/*             Alteradas as procedures para validar a tabela BKP_TABELAS                      */
/*                                                                                            */ 
/* Alteracoes: 20/05/2013 - Ednei Ferreira                                                    */
/*             Incluido a procedure PRC_MONTA_PACKAGES                                        */
/*                                                                                            */
/* Alteracoes: 01/06/2013 - Dimas Barreto                                                     */
/*             Criacao da PRC_JOB                                                             */
/**********************************************************************************************/

/* ***************************************************************************************** */
/*                                       TABELA ASCII                                        */
/* ***************************************************************************************** */
/*  Para Acentuacao, veja as funcoes:                                                        */
/*  SELECT ASCII('¿') cod_caracter , CHR(191) caracter FROM dual;                            */ 
/*                                                                                           */
/* ***************************************************************************************** */

  PROCEDURE PRC_TABLESPACE(lista out sys_refcursor) as

  BEGIN
     OPEN lista FOR
          SELECT ts.tablespace_name                                 "Tablespace",
                 "File Count"                                       "File Count",
                 TRUNC("SIZE(MB)",2)                                "Size(MB)",
                 TRUNC(fr."FREE(MB)", 2)                            "Free(MB)",
                 TRUNC("SIZE(MB)" - "FREE(MB)", 2)                  "Used(MB)",
                 TRUNC(df.MAX_EXT,2)                                "Max Ext(MB)",
                 TRUNC((fr."FREE(MB)" / df."SIZE(MB)") * 100,1)     "% Free",
                 RPAD('*', TRUNC(CEIL((fr."FREE(MB)" / df."SIZE(MB)") * 100)/10), '*') "Graph"
                 -- ,((DECODE(df."MAX_EXT", 0, df."SIZE(MB)", df."MAX_EXT") - fr."FREE(MB)") / DECODE(df."MAX_EXT", 0, df."SIZE(MB)", df."MAX_EXT")) * 100 "% Free Ext"
          FROM (SELECT tablespace_name,
                       SUM(bytes) / (1024 * 1024) "FREE(MB)"
                FROM dba_free_space
                GROUP BY tablespace_name) fr,

               (SELECT tablespace_name,
                       SUM(bytes) / (1024 * 1024) "SIZE(MB)",
                       COUNT(*) "File Count",
                       SUM(maxbytes) / (1024 * 1024) "MAX_EXT"
                FROM dba_data_files
                GROUP BY tablespace_name) df,

               (SELECT tablespace_name
                FROM dba_tablespaces) ts
          WHERE  ts.tablespace_name   = df.tablespace_name   (+)
          AND    ts.tablespace_name   = fr.tablespace_name(+)
          AND    ts.tablespace_name   IN ('SISENGORD','SISENGORX','SISENGEID','SISENGEIX','SISENG_TMP')
          ORDER BY 1;

  END PRC_TABLESPACE;

  PROCEDURE PRC_TABLESPACE_MAIL as

  l_email_origem       VARCHAR2(100);
  l_email_destino      VARCHAR2(100);
  l_assunto            VARCHAR2(100);
  l_mensagem           VARCHAR2(4000);
  l_ambiente           VARCHAR2(100);
  l_count              NUMBER :=0;
  l_perc_tabspace      NUMBER;

  BEGIN
      SELECT para_valor
        INTO l_email_origem
        FROM parametros
       WHERE para_chave = 'EMAIL_ORIGEM';

      SELECT para_valor
        INTO l_email_destino
        FROM parametros
       WHERE para_chave = 'EMAIL_DBA';

      SELECT para_valor
       INTO l_ambiente
       FROM parametros
       WHERE para_chave = 'BKP_BASE';

      SELECT to_number(para_valor)
       INTO l_perc_tabspace
       FROM parametroS
      WHERE para_chave = 'TABLESPACE_PERCENT';

      l_assunto   := 'Base: '||l_ambiente||' - Notificacao de limite de Tablespace';
      l_mensagem  :=           '<h3><strong>Aviso de espa'||CHR(231)||'o livre da Tablespace inferior a '|| l_perc_tabspace||' % </strong></h3>'
                    ||CHR(10)|| 'Verificar as seguintes Tablespaces:'
                    ||CHR(10)|| '<br><br>'
                    ||CHR(10)|| '<table border=0 cellspacing=0 cellpadding=0>';


      FOR cur_lista IN ( SELECT ts.tablespace_name                                 Tablespace
                              , TRUNC((fr."FREE(MB)" / df."SIZE(MB)") * 100,1)     Espaco_Livre
                           FROM (SELECT tablespace_name,
                                        SUM(bytes) / (1024 * 1024) "FREE(MB)"
                                   FROM dba_free_space
                                  GROUP BY tablespace_name) fr,
                                (SELECT tablespace_name,
                                        SUM(bytes) / (1024 * 1024) "SIZE(MB)",
                                        COUNT(*) "File Count",
                                        SUM(maxbytes) / (1024 * 1024) "MAX_EXT"
                                   FROM dba_data_files
                                  GROUP BY tablespace_name) df,
                                (SELECT tablespace_name
                                   FROM dba_tablespaces) ts
                                  WHERE ts.tablespace_name   = df.tablespace_name   (+)
                                    AND ts.tablespace_name   = fr.tablespace_name(+)
                                    AND ts.tablespace_name   IN ('SISENGORD','SISENGORX','SISENGEID','SISENGEIX','SISENG_TMP')
                                  ORDER BY 1)
      LOOP   
          IF cur_lista.Espaco_Livre <= l_perc_tabspace THEN
              l_count     := l_count +1;
              ---l_mensagem  := l_mensagem || CHR(10) || '  '||rpad(cur_lista.Tablespace,15,' ')||' - '||cur_lista.Espaco_Livre||' %';
              l_mensagem  := l_mensagem ||CHR(10)|| '<tr>'
                                        ||CHR(10)|| '<td width=100 valign=top>'
                                        ||CHR(10)|| cur_lista.Tablespace
                                        ||CHR(10)|| '</td>'
                                        ||CHR(10)|| '<td width=100 valign=top>'
                                        ||CHR(10)|| to_char(cur_lista.Espaco_Livre, '90d0')||' %'
                                        ||CHR(10)|| '</td>'
                                        ||CHR(10)|| '</tr>';
          END IF;
      END LOOP;
      l_mensagem := l_mensagem || '</table>';
      
      IF l_count != 0 THEN
          pkg_util.PRC_EMAIL( l_email_origem
                            , l_email_destino
                            , l_assunto
                            , l_mensagem);                       
      END IF;
  EXCEPTION
      WHEN OTHERS THEN
          NULL;
  END PRC_TABLESPACE_MAIL;
 
  /*****************************************************************************************************/
  /* PRC_LISTA_TABELAS                                                                                 */
  /*                                                                                                   */
  /* Procedure que lista informacoes das tabelas do sistema.                                           */
  /*                                                                                                   */
  /*****************************************************************************************************/
  PROCEDURE PRC_LISTA_TABELAS (lista out sys_refcursor)   as

  BEGIN

       open lista for
            select OWNER                            SCHEMA,
                   TABLE_NAME                       TABELA,
                   fnc_qtd(x.table_name) QT_LINHAS,
--                   num_rows,
                   nvl((select max('S')
                        from bkp_tabelas
                        where tabela_filha = x.table_name ),' ') BACKUP,
                   case
                       when substr(table_name,1,4) = 'MGR_' then
                            'MIGRACAO'
                       when substr(table_name,1,4) = 'XXOD' then
                            'INTEGRACAO'
                       when substr(table_name,1,2) = 'T_' then
                            'BACKUP'
                       when x.temporary = 'Y' then
                            'TEMPORARIA'
                       else
                            ' '
                       end                         TIPO,
                   x.tablespace_name               TABLESPACE,
                   x.avg_row_len                   TAMANHO_MEDIO
           from all_tables x where owner = sys_context('USERENV', 'SESSION_USER')
           order by 5,4 desc,2;

  END PRC_LISTA_TABELAS;


  procedure PRC_EMAIL (p_origem   in varchar2,
                       p_destino  in varchar2,
                       p_assunto  in varchar2,
                       p_mensagem in varchar2) AS

  c UTL_SMTP.CONNECTION;
  l_to   varchar(100);
  l_cc   varchar(100);
  


  BEGIN
       l_to := substr(p_destino,1,instr(p_destino,',')-1);
       l_cc := substr(p_destino,instr(p_destino,',')+1);                       
       c := UTL_SMTP.OPEN_CONNECTION('mail.odebrecht.com',25);           
       UTL_SMTP.HELO(c, 'odebrecht.com');      
       UTL_SMTP.MAIL(c, p_origem);                                       
       UTL_SMTP.RCPT(c, l_to);        
       UTL_SMTP.RCPT(c, l_cc);       
       UTL_SMTP.OPEN_DATA(c);
       UTL_SMTP.WRITE_DATA(c, 'From: '||p_origem|| UTL_TCP.CRLF);
       UTL_SMTP.WRITE_DATA(c, 'To: '||p_destino|| UTL_TCP.CRLF);
       UTL_SMTP.WRITE_DATA(c, 'Subject:'|| p_assunto|| UTL_TCP.CRLF);
       UTL_SMTP.WRITE_DATA(c, 'Importance: High'|| UTL_TCP.CRLF);
       UTL_SMTP.WRITE_DATA(C, 'Content-Type: text/html;'|| UTL_TCP.CRLF);
       UTL_SMTP.WRITE_DATA(C, ''|| UTL_TCP.CRLF);
       UTL_SMTP.WRITE_DATA(C, p_mensagem|| UTL_TCP.CRLF);              
       UTL_SMTP.CLOSE_DATA(c);
       UTL_SMTP.QUIT(c);             
 utl_smtp.close_connection(c);      
      
  EXCEPTION
       WHEN OTHERS THEN   
--           dbms_output.put_line(sqlerrm);     
             utl_smtp.close_connection(c);
             NULL;
  END PRC_EMAIL;

  PROCEDURE PRC_VERIFICA_AMBIENTE (TABELA IN VARCHAR2) IS

      l_existe    VARCHAR2(50);

  BEGIN

      BEGIN
          SELECT 'X'
            INTO l_existe
            FROM PARAMETROS
           WHERE PARA_CHAVE = 'BKP_BASE'
             AND PARA_VALOR  not IN ( 'EI_PDEV'
                                    , 'EI_PROD'
                                    , 'OR_PROD'
                                    );
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              l_existe := ' ';
      END;

      IF l_existe = 'X'  THEN
          raise_application_error (-20999,'A tabela '||TABELA||' esta bloqueada para alteracao nesse ambiente');
      END IF;


  END PRC_VERIFICA_AMBIENTE;

  /*****************************************************************************************************/
  /* PRC_QTD                                                                                           */
  /*                                                                                                   */
  /* Funcao que retorna a quantidade de registros de uma tabela                                        */
  /*                                                                                                   */
  /*****************************************************************************************************/
  FUNCTION FNC_QTD (p_tabela in varchar2) return number as

  l_count          number;
  l_comando        varchar2(100);

  BEGIN

    l_comando := 'SELECT COUNT(*) FROM '||P_TABELA;

    EXECUTE IMMEDIATE  l_comando into l_count;

    RETURN l_count;

  END FNC_QTD;
    
  /*****************************************************************************************************/
  /* PRC_MONTA_PACKAGES                                                                                */
  /*                                                                                                   */
  /* Procedure que elabora o script das packages a partir de determinado owner nome de tabela.         */
  /* A saida é para o output                                                                           */
  /*                                                                                                   */
  /*****************************************************************************************************/
 PROCEDURE PRC_MONTA_PACKAGES ( P_OWNER         IN VARCHAR2
                              , P_TABELA        IN VARCHAR2
                              , P_DESENVOLVEDOR IN VARCHAR2) AS
   --
      l_tipo          VARCHAR2(25);
      l_id            VARCHAR2(25);
      l_timestamp     VARCHAR2(25);
      l_secord        VARCHAR2(25);
      l_txt_spec      CLOB;
      l_txtb01        CLOB;
      l_txtb02        CLOB;
      l_txtb03        CLOB;
      l_txtb04        CLOB;
      l_txtb05        CLOB;
      l_txtb06        CLOB;
      l_txtb07        CLOB;      
        
  BEGIN
      FOR TAB IN ( SELECT DISTINCT OWNER
                        , TABLE_NAME TABELA
                     FROM ALL_TABLES
                    WHERE OWNER       = NVL(P_OWNER,OWNER)
                      AND TABLE_NAME  = NVL(P_TABELA,TABLE_NAME)
                    ORDER BY 1,2)
      LOOP
          --
          l_txt_spec :=              'CREATE OR REPLACE PACKAGE '||TAB.OWNER||'.PKG_'||TAB.TABELA||' AS'
                       || CHR(10) || '-- $Header: PKG_'||TAB.TABELA||'_PKS.pls 120.1 '||to_Date(SYSDATE, 'dd/mm/rrrr hh24:mi:ss')||' appldev ship $'
                       || CHR(10) || '/*'||RPAD('*',92,'*')||'*/'
                       || CHR(10) || '/*'||RPAD(' PKG_'||TAB.TABELA,92)||'*/'
                       || CHR(10) || '/*'||RPAD(' ',92)||'*/'
                       || CHR(10) || '/*'||RPAD(' Procedure Excluir - Exclui '||TAB.TABELA||' informadas numa lista.',92)||'*/'
                       || CHR(10) || '/*'||RPAD(' ',92)||'*/'
                       || CHR(10) || '/*'||RPAD(' Procedure Listar - Lista '||TAB.TABELA||' informadas no parametro de cenario.',92)||'*/'
                       || CHR(10) || '/*'||RPAD(' ',92)||'*/'
                       || CHR(10) || '/*'||RPAD(' Procedure Salvar - Atualiza informacoes na tabela '||TAB.TABELA||' atraves de uma lista de registros',92)||'*/'
                       || CHR(10) || '/*'||RPAD(' ',92)||'*/'
                       || CHR(10) || '/* Desenvolvimento: '||to_char(SYSDATE, 'dd/mm/rrrr')||' - ' || rpad( p_desenvolvedor,61) || '*/'
                       || CHR(10) || '/*'||RPAD(' ',92)||'*/'
                       || CHR(10) || '/* Alteracoes: DD/MM/YYYY - Desenvolvedor                                                     */'
                       || CHR(10) || '/*             Descritivo                                                                     */'
                       || CHR(10) || '/*'||RPAD(' ',92)||'*/'
                       || CHR(10) || '/*'||RPAD('*',92,'*')||'*/'
                       || CHR(10) || ' '
                       || CHR(10) ;
                                        
          --
          l_txtb01 :=              'CREATE OR REPLACE PACKAGE BODY '||TAB.OWNER||'.PKG_'||TAB.TABELA||' AS'
                       || CHR(10) || '-- $Header: PKG_'||TAB.TABELA||'_PKB.pls 120.1 '||to_Date(SYSDATE, 'dd/mm/rrrr hh24:mi:ss')||' appldev ship $'
                       || CHR(10) || '/*'||RPAD('*',92,'*')||'*/'
                       || CHR(10) || '/*'||RPAD(' PKG_'||TAB.TABELA,92)||'*/'
                       || CHR(10) || '/*'||RPAD(' ',92)||'*/'
                       || CHR(10) || '/*'||RPAD(' Procedure Excluir - Exclui '||TAB.TABELA||' informadas numa lista.',92)||'*/'
                       || CHR(10) || '/*'||RPAD(' ',92)||'*/'
                       || CHR(10) || '/*'||RPAD(' Procedure Listar - Lista '||TAB.TABELA||' informadas no parametro de cenario.',92)||'*/'
                       || CHR(10) || '/*'||RPAD(' ',92)||'*/'
                       || CHR(10) || '/*'||RPAD(' Procedure Salvar - Atualiza informacoes na tabela '||TAB.TABELA||' atraves de uma lista de registros',92)||'*/'
                       || CHR(10) || '/*'||RPAD(' ',92)||'*/'
                       || CHR(10) || '/* Desenvolvimento: '||to_char(SYSDATE, 'dd/mm/rrrr')||' - ' || rpad( p_desenvolvedor,61) || '*/'
                       || CHR(10) || '/*'||RPAD(' ',92)||'*/'
                       || CHR(10) || '/* Alteracoes: DD/MM/YYYY - Desenvolvedor                                                     */'
                       || CHR(10) || '/*             Descritivo                                                                     */'
                       || CHR(10) || '/*'||RPAD(' ',92)||'*/'
                       || CHR(10) || '/*'||RPAD('*',92,'*')||'*/'
                       || CHR(10) || ' '
                       || CHR(10) ; 

          FOR col IN (SELECT '1'                     ORDENAMENTO
                           , LOWER(ATC.TABLE_NAME)   TABELA
                           , ATC.COLUMN_ID           ORDEM
                           , LOWER(ATC.COLUMN_NAME)  COLUNA
                           , ATC.DATA_TYPE           TIPO
                           , ATC.DATA_LENGTH         TAMANHO
                           , ( SELECT A.COLUMN_NAME
                                 FROM ALL_CONS_COLUMNS  A
                                    , ALL_CONSTRAINTS   C
                                WHERE 1 = 1
                                  AND A.OWNER            = C.OWNER
                                  AND A.CONSTRAINT_NAME  = C.CONSTRAINT_NAME
                                  AND C.CONSTRAINT_TYPE  = 'P'
                                  AND A.TABLE_NAME       = ATC.TABLE_NAME
                                  AND A.OWNER            = atc.owner
                             )                     PK
                        FROM ALL_TAB_COLUMNS ATC
                       WHERE 1 = 1
                         AND ATC.COLUMN_NAME NOT LIKE '%DT_UPDATE'
                         AND ATC.OWNER              = TAB.OWNER
                         AND ATC.TABLE_NAME         = TAB.TABELA
                      UNION ALL
                      SELECT '2'                     ORDENAMENTO
                           , LOWER(ATC2.TABLE_NAME)  TABELA
                           , ATC2.COLUMN_ID          ORDEM
                           , LOWER(ATC2.COLUMN_NAME) COLUNA
                           , ATC2.DATA_TYPE          TIPO
                           , ATC2.DATA_LENGTH        TAMANHO
                           , ( SELECT A.COLUMN_NAME
                                 FROM ALL_CONS_COLUMNS  A
                                    , ALL_CONSTRAINTS   C
                                WHERE 1 = 1
                                  AND A.OWNER            = C.OWNER
                                  AND A.CONSTRAINT_NAME  = C.CONSTRAINT_NAME
                                  AND C.CONSTRAINT_TYPE  = 'P'
                                  AND A.TABLE_NAME       = ATC2.TABLE_NAME
                                  AND A.OWNER            = atc2.owner
                             )                      PK
                        FROM ALL_TAB_COLUMNS ATC2
                       WHERE 1 = 1
                         AND ATC2.COLUMN_NAME    LIKE '%DT_UPDATE'
                         AND ATC2.OWNER             = TAB.OWNER
                         AND ATC2.TABLE_NAME        = TAB.TABELA
                       ORDER BY 1, 3)
          LOOP
              --
              IF COL.PK != 'X' THEN
                  l_id := COL.pk;
              END IF;
                
              IF substr(col.COLUNA,-3) = '_ID' THEN
                  l_tipo := 'TIdTable';
              ELSIF col.tipo = 'VARCHAR2' THEN 

                  IF COL.TAMANHO > 32 AND COL.TAMANHO < 255 THEN
                      l_tipo := 'TTextTable';
                  ELSIF COL.TAMANHO > 255  THEN
                      l_tipo := 'TTextTable';
                  END IF;

              ELSIF col.tipo = 'TIMESTAMP(3)' THEN
                  l_tipo := 'TTimestampTable';

              ELSIF col.tipo = 'NUMBER' THEN
                  l_tipo := 'TNumberTable';

              ELSIF col.tipo = 'DATE' THEN
                  l_tipo := 'TDateTable';

              ELSIF col.tipo = 'BLOB' THEN
                  l_tipo := 'TBlobTable';
                    
              ELSIF col.tipo = 'CLOB' THEN
                  l_tipo := 'TClobTable';
                    
              END IF;
                 
              IF COL.ORDENAMENTO = '2' THEN
                  l_timestamp := col.COLUNA;
                  l_tipo := 'TTimestampTable';
              END IF;

                
              IF COL.ORDEM = 1 THEN
                  l_txt_spec :=     l_txt_spec ||'  Procedure Excluir ( v_'||RPAD(COL.COLUNA,20)||'   PKG_GLOBAL.'||l_tipo
                          || CHR(10) ||'                    , listaErros           out sys_refcursor);'
                          || CHR(10) ||'  '
                          || CHR(10) ||'  Procedure  Salvar ( v_'||RPAD(COL.COLUNA,24)||'   PKG_GLOBAL.'||l_tipo;
                  --
                  l_txtb01 :=     l_txtb01 ||'  Procedure Excluir ( v_'||RPAD(COL.COLUNA,24)||'   PKG_GLOBAL.'||l_tipo
                          || CHR(10) ||'                    , listaErros               out sys_refcursor) as'
                          || CHR(10) ||'    '
                          || CHR(10) ||'      error_count integer;'
                          || CHR(10) ||'      error_table TTableError2;'
                          || CHR(10) ||'    '
                          || CHR(10) ||'  BEGIN'
                          || CHR(10) ||'      --'
                          || CHR(10) ||'      error_count := 0;'
                          || CHR(10) ||'      error_table := TTableError2();'
                          || CHR(10) ||'  '
                          || CHR(10) ||'      for i in v_'||COL.COLUNA||'.first .. v_'||COL.COLUNA||'.last'
                          || CHR(10) ||'      loop'
                          || CHR(10) ||'  '
                          || CHR(10) ||'          begin'
                          || CHR(10) ||'  '
                          || CHR(10) ||'              error_table.extend();'
                          || CHR(10) ||'              error_table(error_table.count) := TObjectError2 ( v_'||COL.COLUNA||'(i)'
                          || CHR(10) ||'                                                              , null'
                          || CHR(10) ||'                                                              , null'
                          || CHR(10) ||'                                                              , 0'
                          || CHR(10) ||'                                                              , null'
                          || CHR(10) ||'                                                              , null);'
                          || CHR(10) ||'  '
                          || CHR(10) ||'              delete from '||COL.TABELA||' where '||COL.COLUNA||' = v_'||COL.COLUNA||'(i);'
                          || CHR(10) ||'  '
                          || CHR(10) ||'          exception'
                          || CHR(10) ||'              when others then'
                          || CHR(10) ||'                  error_table(error_table.count).ErrorNumber  := sqlcode;'
                          || CHR(10) ||'                  error_table(error_table.count).ErrorMessage := sqlerrm;'
                          || CHR(10) ||'                  error_count                                 := error_count + 1;'
                          || CHR(10) ||'          end;'
                          || CHR(10) ||'      end loop;'
                          || CHR(10) ||'  '
                          || CHR(10) ||'      open listaErros for'
                          || CHR(10) ||'          select * '
                          || CHR(10) ||'            from table(cast(error_table as TTableError2));'
                          || CHR(10) ||'  '
                          || CHR(10) ||'  end Excluir;'
                          || CHR(10) ||'  '
                          || CHR(10) ||'  Procedure  Salvar ( v_'||RPAD(COL.COLUNA,24)||'   PKG_GLOBAL.'||l_tipo;
                  --
                  l_txtb06 := '        SELECT '||l_id;
                            

                            
              ELSIF COL.ordem = 2 THEN
                
                  l_txt_spec := l_txt_spec || CHR(10) ||'                    , v_'||RPAD(COL.COLUNA,24)||'   PKG_GLOBAL.'||l_tipo;
                  l_txtb01   := l_txtb01  || CHR(10) ||'                    , v_'||RPAD(COL.COLUNA,24)||'   PKG_GLOBAL.'||l_tipo;
                  l_txtb02   :=   chr(10) ||'              insert into '||col.tabela||' ( '||col.coluna;
                  l_txtb03   :=             '                                 )'
                               || CHR(10) ||'                          values ( v_'||col.coluna||'(i)';
                  l_txtb04   :=   '                 set '||rpad(col.coluna,22,' ')||' = v_'||col.coluna||'(i)';
                  l_secord   := col.coluna;
                  l_txtb06   := l_txtb06   || CHR(10) ||'             , '||COL.COLUNA;

              ELSE
                  --
                  l_txt_spec := l_txt_spec || CHR(10) ||'                    , v_'||RPAD(COL.COLUNA,24)||'   PKG_GLOBAL.'||l_tipo;
                  l_txtb01   := l_txtb01   || CHR(10) ||'                    , v_'||RPAD(COL.COLUNA,24)||'   PKG_GLOBAL.'||l_tipo;
                    
                  l_txtb06   := l_txtb06   || CHR(10) ||'             , '||COL.COLUNA;

                  IF l_timestamp  = col.COLUNA THEN
                      l_txtb02   := l_txtb02 ;
                      l_txtb03   := l_txtb03 ;
                      l_txtb04   := l_txtb04   || chr(10) ||'                   , '||rpad(col.coluna,22,' ')||' = systimestamp(3)';
                  ELSE 
                      l_txtb02   := l_txtb02   || chr(10) ||'                                 , '||COL.COLUNA;
                      l_txtb03   := l_txtb03   || chr(10) ||'                                 , v_'||COL.COLUNA||'(i)';
                      l_txtb04   := l_txtb04   || chr(10) ||'                   , '||rpad(col.coluna,22,' ')||' = v_'||col.coluna||'(i)';
                  END IF;

              END IF;
          END LOOP;
  
          l_txt_spec  := l_txt_spec || CHR(10) ||'                    , listaErros               out sys_refcursor);'
                                    || CHR(10) ||'  '
                                    || CHR(10) ||'  Procedure Listar ( lista                 out sys_refcursor);'
                                    || CHR(10) ||'  '
                                    || CHR(10) ||'END PKG_'||TAB.TABELA||';'
                                    || CHR(10) ;
                                     
          l_txtb07    :=               CHR(10) ||'                    , listaErros               out sys_refcursor) as'
                                    || CHR(10) ||'  '
                                    || CHR(10) ||'      error_count integer;'
                                    || CHR(10) ||'      error_table TTableError2;'
                                    || CHR(10) ||'  '
                                    || CHR(10) ||'  BEGIN'
                                    || CHR(10) ||'      --'
                                    || CHR(10) ||'      error_count := 0;'
                                    || CHR(10) ||'      error_table := TTableError2();'
                                    || CHR(10) ||'  '
                                    || CHR(10) ||'      for i in v_'||l_id||'.first .. v_'||l_id||'.last'
                                    || CHR(10) ||'      loop'
                                    || CHR(10) ||'  '
                                    || CHR(10) ||'          begin'
                                    || CHR(10) ||'  '
                                    || CHR(10) ||'              error_table.extend();'
                                    || CHR(10) ||'              error_table(error_table.count) := TObjectError2 ( v_'||l_id||'(i)'
                                    || CHR(10) ||'                                                              , null'
                                    || CHR(10) ||'                                                              , null'
                                    || CHR(10) ||'                                                              , 0'
                                    || CHR(10) ||'                                                              , null'
                                    || CHR(10) ||'                                                              , null);'
                                    || CHR(10) ||'  '
                                    || CHR(10) ||'              if v_'||l_id||'(i) is null then';
  
          l_txtb03    := l_txtb03   || chr(10) ||'                                 )'
                                    || chr(10) ||'              returning '||l_id
                                    || chr(10) ||'                      , '||l_timestamp
                                    || chr(10) ||'                   into error_table'
                                    || chr(10) ||'                   (error_table.count).Id, error_table'
                                    || chr(10) ||'                   (error_table.count).DtUpdate;'
                                    || chr(10) ||'  '
                                    || chr(10) ||'          else'
                                    || chr(10) ||'  '
                                    || chr(10) ||'              update '||tab.tabela;

          l_txtb05    := l_txtb05              ||'               where '||l_id||' = v_'||l_id||'(i)'
                                    || chr(10) ||'                 and '||l_timestamp||' = to_timestamp(v_'||l_timestamp||'(i),''YYYY.MM.DD.HH24:MI:SS.FF'')'
                                    || chr(10) ||'           returning '||l_timestamp
                                    || chr(10) ||'                into error_table(error_table.count).DtUpdate;'
                                    || chr(10) ||'  '
                                    || chr(10) ||'          end if;'
                                    || chr(10) ||'  '
                                    || chr(10) ||'          if (sql%rowcount = 0) then'
                                    || chr(10) ||'              raise NO_DATA_FOUND;'
                                    || chr(10) ||'          end if;'
                                    || chr(10) ||'  '
                                    || chr(10) ||'      exception'
                                    || chr(10) ||'          when others then'
                                    || chr(10) ||'              error_table(error_table.count).ErrorNumber  := sqlcode;'
                                    || chr(10) ||'              error_table(error_table.count).ErrorMessage := sqlerrm;'
                                    || chr(10) ||'              error_count                                 := error_count + 1;'
                                    || chr(10) ||'      end;'
                                    || chr(10) ||'     end loop;'
                                    || chr(10) ||'  '
                                    || chr(10) ||'     open listaErros for'
                                    || chr(10) ||'        select * from table(cast(error_table as TTableError2));'
                                    || chr(10) ||'  '
                                    || chr(10) ||'  end Salvar;'
                                    || chr(10) ||'  '
                                    || chr(10) ||'  procedure Listar(lista out sys_refcursor) as'
                                    || chr(10) ||'  begin'
                                    || chr(10) ||'     open lista for';
          --
          l_txtb06    := l_txtb06   || CHR(10) ||'          from '||tab.tabela
                                    || chr(10) ||'         order by '|| l_secord ||' ;'
                                    || chr(10) ||'  END Listar;'
                                    || chr(10) ||'  '
                                    || chr(10) ||'END PKG_'||tab.tabela||';';


           DBMS_OUTPUT.enable (100000);
           DBMS_OUTPUT.PUT_LINE( l_txt_spec ); 
                      
           DBMS_OUTPUT.PUT_LINE( l_txtb01 );     
           DBMS_OUTPUT.PUT_LINE( l_txtb07 );                     
           DBMS_OUTPUT.PUT_LINE( l_txtb02 );
           DBMS_OUTPUT.PUT_LINE( l_txtb03 );
           DBMS_OUTPUT.PUT_LINE( l_txtb04 );
           DBMS_OUTPUT.PUT_LINE( l_txtb05 );
           DBMS_OUTPUT.PUT_LINE( l_txtb06 );

      END LOOP ;

  END PRC_MONTA_PACKAGES;


  procedure PRC_JOB as
    
  l_job_name  varchar2(100);
  l_valor     varchar2(100);
  l_hora      number;
  l_proximo   number;
  l_ultimo     number;
  l_update     number;

  begin
        
       select para_valor
       into   l_valor 
       from   parametros
       where  para_chave = 'JOB_TIME';  
       
       select para_valor
       into   l_ultimo 
       from   parametros       
       where para_chave = 'JOB';


--       DBMS_OUTPUT.PUT_LINE (l_valor);
--       DBMS_OUTPUT.PUT_LINE (l_ultimo);

       FOR i IN 1..12 LOOP
             
           l_hora := to_number(xxod_modx_get_str_fnc(l_valor,i,';'));
       
           if l_hora is null then
              exit; 
           end if;   
            
           l_proximo := to_number(to_char(sysdate,'YYYYMMDD')) + L_HORA /100 ;
            
           if to_number(to_char(sysdate,'yyyymmdd.hh24')) =  l_proximo then              

              if L_PROXIMO <> L_ULTIMO then            
   
                 update parametros 
                 set    para_valor = TO_CHAR(l_proximo,'00000000.00')
                 where para_chave = 'JOB';
              
                 l_update := 1;
              
                 commit;
                 
              end if;
              
              exit;
              
           end if;   
                  
       END LOOP;
    
       if l_update = 1 then
         
       begin
            l_job_name := 'VERIFICA_TABLESPACE';
            dbms_scheduler.create_job ( job_name => l_job_name
                                      , job_type => 'PLSQL_BLOCK'
                                      , job_action =>  'begin pkg_util.prc_tablespace_mail();end;'
                                      , start_date => SYSTIMESTAMP
                                      , enabled =>  TRUE
                                      , comments =>  'VERIFICA TABLESPACE');
       exception
            when others then        
                 null;                 
       end;    

       begin
            l_job_name := 'SISENG_EXCLUI_TABELAS_TEMP';
            dbms_scheduler.create_job ( job_name => l_job_name
                                      , job_type => 'PLSQL_BLOCK'
                                      , job_action =>  'begin pkg_util.prc_ddl();end;'
                                      , start_date => SYSTIMESTAMP
                                      , enabled =>  TRUE
                                      , comments =>  'EXCLUI TABELAS TEMP');
       exception
            when others then
                 null;                 
       end;    
        
       begin
            l_job_name := 'SISENG_EXCLUI_CENARIO';
            dbms_scheduler.create_job ( job_name => l_job_name
                                      , job_type => 'PLSQL_BLOCK'
                                      , job_action =>  'begin pkg_cenarios.prc_exclui_fisico();end;'
                                      , start_date => SYSTIMESTAMP
                                      , enabled =>  TRUE
                                      , comments =>  'EXCLUI CENARIO FISICO');
       exception
            when others then
                 null;     
       end;          
   
       begin
            l_job_name := 'SISENGOR_EXCLUI_SOLICITACOES';
            dbms_scheduler.create_job ( job_name => l_job_name
                                      , job_type => 'PLSQL_BLOCK'
                                      , job_action =>  'begin pkg_integracao_solicitacoes.ExcluirSolicitacoes(); end;'
                                      , start_date => SYSTIMESTAMP
                                      , enabled =>  TRUE
                                      , comments =>  'EXCLUI SOLICITACOES DE INTEGRACAO');
       exception
            when others then
                 null;                 
       end; 

       begin
            l_job_name := 'SISENGOR_EMAIL_WORKFLOW';
            dbms_scheduler.create_job ( job_name => l_job_name
                                      , job_type => 'PLSQL_BLOCK'
                                      , job_action =>  'begin pkg_atividades.ExcluirAtividadesZero(); end;'
                                      , start_date => SYSTIMESTAMP
                                      , enabled =>  TRUE
                                      , comments =>  'EXCLUI ATIVIDADES ZERO');
       exception
            when others then
                 null;                 
       end;          
                      
       begin
            l_job_name := 'WORKFLOW_FECHAMENTO';
            dbms_scheduler.create_job ( job_name => l_job_name
                                      , job_type => 'PLSQL_BLOCK'
                                      , job_action =>  'begin pkg_workflow_lotes.verifica_fechamento();end;'
                                      , start_date => SYSTIMESTAMP
                                      , enabled =>  TRUE
                                      , comments => 'Workflow - grava email fechamento');
       exception
            when others then        
                 null;                 
       end; 
       
       begin
            l_job_name := 'WORKFLOW_ENVIA_EMAIL';
            dbms_scheduler.create_job ( job_name => l_job_name
                                      , job_type => 'PLSQL_BLOCK'
                                      , job_action =>  'begin pkg_util.prc_email_pendente();end;'
                                      , start_date => SYSTIMESTAMP
                                      , enabled =>  TRUE
                                      , comments => 'Workflow - envia email Pendente');
       exception
            when others then        
                 null;                 
       end; 
       
       end if;       
       
   exception
        when others then
             null;        
              
  END PRC_JOB;
  

  /*****************************************************************************************************/
  /* PRC_DDL                                                                                           */
  /*                                                                                                   */
  /* Procedure que excuta o drop nas tabelas temporarias, criadas durante os processo de restore,      */
  /* duplica e efetiva cenarios.                                                                       */
  /*                                                                                                   */
  /*****************************************************************************************************/
  PROCEDURE PRC_DDL( p_n_import  number default null) as

  l_erro            varchar2(1000);
  l_numero_processo number;
  l_bkco_id         char(32);
  l_owner           varchar2(50);

  BEGIN

      SELECT sys_context('USERENV', 'SESSION_USER')
      INTO   l_owner
      FROM   DUAL;

       -- seleciona processo para exclusao
       for i in (select distinct numero_processo
                 from(select p_n_import    numero_processo
                 from dual
                 where  p_n_import is not null
                 union all
                 select bkco_numero_processo
                 from bkp_controle bkp
                 where bkp.bkco_numero_processo   is not null
                 and  (bkp.bkco_dt_termino        is not null
                       or
                      (bkp.bkco_dt_inicio) < sysdate -  (6/24))
                 and   bkp.bkco_numero_processo in 
                       (select SUBSTR(table_name,13,3) 
                        from user_tables 
                        where table_name like 'ATIVIDADES_I%'
                        union all
                        select SUBSTR(table_name,5,3) 
                        from user_tables 
                        where table_name like 'UA_I%'
                        union all
                        select SUBSTR(table_name,5,3) 
                        from user_tables 
                        where table_name like 'UO_I%'    
                        union all
                        select SUBSTR(table_name,9,3) 
                        from user_tables 
                        where table_name like 'VERBAS_I%')                                              
                        )   
                 order by 1)

       loop
           l_numero_processo := i.numero_processo;

           select max(bkco_id)
           into   l_bkco_id
           from  bkp_controle
           where bkco_numero_processo = l_numero_processo;

           for cCur in (select table_name
                        from all_tables
                        where table_name like '%_I'||l_numero_processo
                        AND OWNER = l_owner
                        order by 1)
           loop

               EXECUTE IMMEDIATE 'DROP TABLE '||l_owner||'.'||cCur.table_name;

           end loop;
           begin
                PKG_BACKUP.PRC_LOG (l_bkco_id,'Termino do DROP das tabelas temporarias ' ||l_numero_processo);
           exception 
                when others then 
                     null;
           end;               
       end loop;
         
  exception
      when others then
           l_erro := sqlerrm;
           begin 
                PKG_BACKUP.PRC_LOG (l_bkco_id,'Erro DROP das tabelas temporarias ' ||l_numero_processo||'--' || l_erro);
           exception
                when others then
                     null;
           end;         
 
  END PRC_DDL ; 
  
  PROCEDURE PRC_EMAIL_PENDENTE as

  l_email_origem       VARCHAR2(100);
  l_email_destino      VARCHAR2(100);
  l_assunto            VARCHAR2(100);
  l_mensagem           VARCHAR2(4000);
  l_ambiente           VARCHAR2(100);
  l_count              NUMBER :=0;
  l_perc_tabspace      NUMBER;

  BEGIN
 
  
      SELECT para_valor
       INTO l_ambiente
       FROM parametros
       WHERE para_chave = 'BKP_BASE';


      l_assunto   := 'Base: '||l_ambiente||' - Notificacao de workflow';


      FOR i IN ( select emai_id
                 from email_pendente
                 where emai_dt_envio is null) 
      LOOP   
           l_count := l_count + 1; 
                   
           select emai_origem,
                  emai_destino||','||emai_destino,
                  emai_mensagem                     
           INTO   l_email_origem,  
                  l_email_destino, 
                  l_mensagem
           from email_pendente 
           where emai_id = i.emai_id;
      
      
           l_mensagem := CHR(10)|| '<tr>'
                       ||CHR(10)|| '<td width=100 valign=top>'
                       ||CHR(10)|| l_mensagem
                       ||CHR(10)|| '</td>'
                       ||CHR(10)|| '</tr></table>';


           begin
                pkg_util.PRC_EMAIL( l_email_origem
                                  , l_email_destino
                                  , l_assunto
                                  , l_mensagem);
           exception
               when others then
                    null;
           end;     
           
           update email_pendente 
           set    emai_dt_envio = sysdate
           where  emai_id       = i.emai_id;                                 
                  
      END LOOP;
  EXCEPTION
      WHEN OTHERS THEN
          NULL;
  END PRC_EMAIL_PENDENTE;
       
END PKG_UTIL;
/
