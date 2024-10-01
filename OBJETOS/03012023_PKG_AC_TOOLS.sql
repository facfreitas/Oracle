--------------------------------------------------------
--  File created - Tuesday-January-03-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body PKG_AC_TOOLS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ERF"."PKG_AC_TOOLS" AS

  PROCEDURE PRC_APROVADO_RONDA_EMAIL(P_SOLICITACAO_ID NUMBER) AS
   V_MESSAGE_TEMPLATE varchar2(32000) := 
    '
                    <div class="logo">
                    <table>
                    <tbody>
                    <tr style="background-color: #e1e1e1;">
                    <td><img class="logo" src="https://www.enseada.com/wp-content/uploads/2018/06/Enseada_logo_ES_reduzida.png" /></td>
                    </tr>
                    <tr>
                    <td>
                    <div class="body">
                        <center><h2><strong><span style="text-decoration: underline;">Agendamento de Visitante</span></strong></h2></center>
                        <p>Prezado,</p>
                        <p><strong>#NOME# </strong></p>
                        <p>Foi agendado o acesso ao Terminal Enseada para o(s) seguinte(s) visitante(s) abaixo:</p>
                        <p><strong>Número Agendamento: </strong>#NUMERO#</p>
                        #DATA#
                        <p><strong>Solicitante: </strong>#SOLICITANTE#</p>
                   
                        <table style="height: 54px; border-color: BLACK;" border="1" width="532">
                        <tbody>
                            #TABELAPRINCIPAL#
                            #TABELA#
                        </tbody>
                        </table>
                    <p>&nbsp;</p>
                        <table>
                        <tbody>
                            <tr>
                            <td style="border-radius: 4px; height: 30px; font-family: Helvetica,Arial,sans-serif;" bgcolor="#009EE3"><a style="padding: 10px 3px; display: block; font-family: Arial,Helvetica,sans-serif; font-size: 16px; color: #fff; text-decoration: none; text-align: center;" href="http://a-office/visitante" target="_blank" rel="noopener" data-saferedirecturl="http://a-office/visitante">Acesse o Link</a></td>
                            </tr>
                        </tbody>
                        </table>
                    <p>&nbsp;</p>
                    </div>
                    </td>
                    </tr>
                    </tbody>
                    </table>
                    </div>
';

      cursor c_visitantes is 
                    SELECT     
                        cpf,
                        nome,
                        placa,
                        nome_empresa,
                        CASE 
                          WHEN refeicao = 1 THEN 'SIM'
                          ELSE 'NÃO'
                        END as refeicao,
                        CASE 
                          WHEN ACESSO_WIFI = 1 THEN 'SIM'
                          ELSE 'NÃO'
                        END as wifi                        
                    FROM  ac_solicitacao_visitante  , ac_solicitacao_veiculo
                    WHERE ac_solicitacao_visitante.solicitacao_acesso_id = ac_solicitacao_veiculo.solicitacao_acesso_id(+)
                    and ac_solicitacao_visitante.id = ac_solicitacao_veiculo.visitante_id(+)
                    AND ac_solicitacao_visitante.solicitacao_acesso_id = P_SOLICITACAO_ID;
         
      cursor c_ronda is 
                    SELECT     
                        (SELECT NOME FROM SAP_HR.vw_domain_sap_all WHERE vw_domain_sap_all.LOGIN = INTEGRANTE_ID AND ROWNUM = 1) as NOME ,
                        (SELECT EMAIL FROM SAP_HR.vw_domain_sap_all WHERE vw_domain_sap_all.LOGIN = INTEGRANTE_ID AND ROWNUM = 1) as EMAIL 
                    FROM  AC_SOLICITACAO_APROVADOR  
                    WHERE STATUS = 1; -- era 3 ( RONDA )
                    
      message varchar2(32000) := '';
      tabelaVisitante varchar2(32000) := '';
      V_SOLICITANTE  varchar2(500);
      V_APROVADOR  varchar2(500);
      V_DATA  DATE;
      V_PERIODO NUMBER;
      V_TOTAL_VEICULO NUMBER;
      
    BEGIN
       begin    
           --- criar evento no Ronda-----
           PRC_CRIAR_VISITA_RONDA(P_SOLICITACAO_ID);
           
          SELECT   
              (SELECT NOME FROM SAP_HR.vw_domain_sap_all WHERE vw_domain_sap_all.LOGIN = solicitante_id AND ROWNUM = 1) AS SOLICITANTE,
            --  (SELECT NOME FROM SAP_HR.vw_domain_sap_all WHERE vw_domain_sap_all.LOGIN = responsavel_id) AS APROVADOR,
              data_visita as DATA,
              periodo
           INTO 
               V_SOLICITANTE,
           --    V_APROVADOR,
               V_DATA,
               V_PERIODO
          FROM  ac_solicitacao_acesso WHERE id = P_SOLICITACAO_ID;
         
         
         SELECT COUNT(*) INTO V_TOTAL_VEICULO FROM ac_solicitacao_veiculo WHERE solicitacao_acesso_id = P_SOLICITACAO_ID;
         
         
               IF V_TOTAL_VEICULO > 0 THEN
                     V_MESSAGE_TEMPLATE := replace(V_MESSAGE_TEMPLATE, '#TABELAPRINCIPAL#', '  <tr>
                                                                                    <td style="text-align: center;"><strong>CPF</strong></td>
                                                                                    <td style="text-align: center;"><strong>NOME</strong></td>
                                                                                    <td style="text-align: center;"><strong>REFEIÇÃO</strong></td>
                                                                                    <td style="text-align: center;"><strong>ACESSO WI-FI</strong></td>
                                                                                    <td style="text-align: center;"><strong>EMPRESA</strong></td>
                                                                                    <td style="text-align: center;"><strong>PLACA</strong></td>
                                                                                    </tr>
                                                                                  ' );
               ELSE
                     V_MESSAGE_TEMPLATE := replace(V_MESSAGE_TEMPLATE, '#TABELAPRINCIPAL#', '  <tr>
                                                                                    <td style="text-align: center;"><strong>CPF</strong></td>
                                                                                    <td style="text-align: center;"><strong>NOME</strong></td>
                                                                                    <td style="text-align: center;"><strong>REFEIÇÃO</strong></td>
                                                                                    <td style="text-align: center;"><strong>ACESSO WI-FI</strong></td>
                                                                                    <td style="text-align: center;"><strong>EMPRESA</strong></td>
                                                                                    </tr>
                                                                                  ' );               
               END IF;
                                                                                  
               for v_values in c_visitantes loop 
                    tabelaVisitante := tabelaVisitante || '<tr>';       
                    tabelaVisitante := tabelaVisitante || '<td >' || v_values.cpf || '</td>';
                    tabelaVisitante := tabelaVisitante || '<td >' || v_values.nome || '</td>';
                    tabelaVisitante := tabelaVisitante || '<td >' || v_values.refeicao || '</td>';
                    tabelaVisitante := tabelaVisitante || '<td >' || v_values.wifi || '</td>';
                    tabelaVisitante := tabelaVisitante || '<td >' || v_values.nome_empresa || '</td>';
                    IF V_TOTAL_VEICULO > 0 THEN
                       tabelaVisitante := tabelaVisitante || '<td >' || v_values.placa || '</td>';                    
                    END IF;
                    tabelaVisitante := tabelaVisitante || '</tr>';     
                end loop;                    

           for v_values in c_ronda loop            
                   /* PASSAR OS PARAMETROS */
                   message := replace(V_MESSAGE_TEMPLATE,'#NOME#', v_values.NOME);                    
                   message := replace(message,'#NUMERO#', P_SOLICITACAO_ID);                     
                   message := replace(message,'#SOLICITANTE#', V_SOLICITANTE);  
             --      message := replace(message,'#APROVADOR#', V_APROVADOR); 
             
             
                   if V_PERIODO = 1 THEN
                      message := replace(message,'#DATA#', '<p><strong>Data: </strong>'||TO_CHAR(V_DATA,'DD-MM-YYYY')||'</p>');  
                   else
                     message := replace(message,'#DATA#', '<p><strong>Período: </strong>'||TO_CHAR(V_DATA,'DD-MM-YYYY')||' a ' ||TO_CHAR(V_DATA+(V_PERIODO-1),'DD-MM-YYYY')||'</p>'); 
                   end if;
                   
                   message := replace(message,'#TABELA#', tabelaVisitante);      
               ---enviar e-mail ------               
                APEX_MAIL.SEND
                (
                P_TO            => v_values.EMAIL,
                --P_CC            => P_CC ,
                P_FROM          => 'noreplay-acessovisitante@enseada.com',
                P_BODY          => 'Seu cliente de email não é compatível com HTML favor procurar o suporte técnico da Enseada.',
                P_BODY_HTML     =>  message,
                P_SUBJ          => '[VISITANTE_ESTALEIRO] - Agendamento de Visitante - '|| V_DATA
                );
               
                APEX_MAIL.PUSH_QUEUE; 
            end loop;
            
            ----- alterar status pra aprovado -------
            UPDATE ac_solicitacao_acesso SET status = 3 , 
                                             RESPONSAVEL_APROVADOR_ID = UPPER(NVL(v('APP_USER'), USER)),
                                             DATA_APROVACAO = SYSDATE
            WHERE ID = P_SOLICITACAO_ID;     
            
            PRC_APROVADO_RONDA_SOLIC_EMAIL(P_SOLICITACAO_ID);
       EXCEPTION
        WHEN OTHERS THEN   
           DBMS_OUTPUT.PUT_LINE('Código Oracle: ' || SQLCODE);
           DBMS_OUTPUT.PUT_LINE('Mensagem Oracle: ' || SQLERRM);
       END;  
       
  END PRC_APROVADO_RONDA_EMAIL; 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  PROCEDURE PRC_APROVADO_RONDA_SOLIC_EMAIL(P_SOLICITACAO_ID NUMBER) AS
   V_MESSAGE_TEMPLATE varchar2(32000) := 
    '
                    <div class="logo">
                    <table>
                    <tbody>
                    <tr style="background-color: #e1e1e1;">
                    <td><img class="logo" src="https://www.enseada.com/wp-content/uploads/2018/06/Enseada_logo_ES_reduzida.png" /></td>
                    </tr>
                    <tr>
                    <td>
                    <div class="body">
                        <center><h2><strong><span style="text-decoration: underline;">Agendamento de Visitante</span></strong></h2></center>
                        <p>Prezado,</p>
                        <p><strong>#NOME# </strong></p>
                        <p>Confirmação do agendamento ao Terminal Enseada para o(s) seguinte(s) visitante(s) abaixo:</p>
                        <p><strong>Número Agendamento: </strong>#NUMERO#</p>
                        #DATA#
                   
                        <table style="height: 54px; border-color: BLACK;" border="1" width="532">
                        <tbody>
                            #TABELAPRINCIPAL#
                            #TABELA#
                        </tbody>
                        </table>
                    <p>&nbsp;</p>
                        <table>
                        <tbody>
                            <tr>
                            <td style="border-radius: 4px; height: 30px; font-family: Helvetica,Arial,sans-serif;" bgcolor="#009EE3"><a style="padding: 10px 3px; display: block; font-family: Arial,Helvetica,sans-serif; font-size: 16px; color: #fff; text-decoration: none; text-align: center;" href="http://a-office/visitante" target="_blank" rel="noopener" data-saferedirecturl="http://a-office/visitante">Acesse o Link</a></td>
                            </tr>
                        </tbody>
                        </table>
                    <p>&nbsp;</p>
                    </div>
                    </td>
                    </tr>
                    </tbody>
                    </table>
                    </div>
';

      cursor c_visitantes is 
                    SELECT     
                        cpf,
                        nome,
                        placa,
                        nome_empresa,
                        CASE 
                          WHEN refeicao = 1 THEN 'SIM'
                          ELSE 'NÃO'
                        END as refeicao,
                        CASE 
                          WHEN ACESSO_WIFI = 1 THEN 'SIM'
                          ELSE 'NÃO'
                        END as wifi 
                    FROM  ac_solicitacao_visitante  , ac_solicitacao_veiculo
                    WHERE ac_solicitacao_visitante.solicitacao_acesso_id = ac_solicitacao_veiculo.solicitacao_acesso_id(+)
                    and ac_solicitacao_visitante.id = ac_solicitacao_veiculo.visitante_id(+)
                    AND ac_solicitacao_visitante.solicitacao_acesso_id = P_SOLICITACAO_ID;
         
      cursor c_ronda is 
                    SELECT     
                        (SELECT NOME FROM SAP_HR.vw_domain_sap_all WHERE vw_domain_sap_all.LOGIN = SOLICITANTE_ID AND ROWNUM = 1) as NOME ,
                        (SELECT EMAIL FROM SAP_HR.vw_domain_sap_all WHERE vw_domain_sap_all.LOGIN = SOLICITANTE_ID AND ROWNUM = 1) as EMAIL 
                    FROM  AC_SOLICITACAO_ACESSO  
                    WHERE ID = P_SOLICITACAO_ID; -- era 3 ( RONDA )
                    
      message varchar2(32000) := '';
      tabelaVisitante varchar2(32000) := '';
      V_SOLICITANTE  varchar2(500);
      V_APROVADOR  varchar2(500);
      V_DATA  DATE;
      V_PERIODO NUMBER;
      V_TOTAL_VEICULO NUMBER;
      
    BEGIN
       begin    
           
          SELECT   
              (SELECT NOME FROM SAP_HR.vw_domain_sap_all WHERE vw_domain_sap_all.LOGIN = solicitante_id AND ROWNUM = 1) AS SOLICITANTE,
            --  (SELECT NOME FROM SAP_HR.vw_domain_sap_all WHERE vw_domain_sap_all.LOGIN = responsavel_id) AS APROVADOR,
              data_visita as DATA,
              periodo
           INTO 
               V_SOLICITANTE,
           --    V_APROVADOR,
               V_DATA,
               V_PERIODO
          FROM  ac_solicitacao_acesso WHERE id = P_SOLICITACAO_ID;
         
         
         SELECT COUNT(*) INTO V_TOTAL_VEICULO FROM ac_solicitacao_veiculo WHERE solicitacao_acesso_id = P_SOLICITACAO_ID;
         
         
               IF V_TOTAL_VEICULO > 0 THEN
                     V_MESSAGE_TEMPLATE := replace(V_MESSAGE_TEMPLATE, '#TABELAPRINCIPAL#', '  <tr>
                                                                                    <td style="text-align: center;"><strong>CPF</strong></td>
                                                                                    <td style="text-align: center;"><strong>NOME</strong></td>
                                                                                    <td style="text-align: center;"><strong>REFEIÇÃO</strong></td>
                                                                                    <td style="text-align: center;"><strong>ACESSO WI-FI</strong></td>
                                                                                    <td style="text-align: center;"><strong>EMPRESA</strong></td>
                                                                                    <td style="text-align: center;"><strong>PLACA</strong></td>
                                                                                    </tr>
                                                                                  ' );
               ELSE
                     V_MESSAGE_TEMPLATE := replace(V_MESSAGE_TEMPLATE, '#TABELAPRINCIPAL#', '  <tr>
                                                                                    <td style="text-align: center;"><strong>CPF</strong></td>
                                                                                    <td style="text-align: center;"><strong>NOME</strong></td>
                                                                                    <td style="text-align: center;"><strong>REFEIÇÃO</strong></td>
                                                                                    <td style="text-align: center;"><strong>ACESSO WI-FI</strong></td>
                                                                                    <td style="text-align: center;"><strong>EMPRESA</strong></td>
                                                                                    </tr>
                                                                                  ' );               
               END IF;
                                                                                  
               for v_values in c_visitantes loop 
                    tabelaVisitante := tabelaVisitante || '<tr>';       
                    tabelaVisitante := tabelaVisitante || '<td >' || v_values.cpf || '</td>';
                    tabelaVisitante := tabelaVisitante || '<td >' || v_values.nome || '</td>';
                    tabelaVisitante := tabelaVisitante || '<td >' || v_values.refeicao || '</td>';
                    tabelaVisitante := tabelaVisitante || '<td >' || v_values.wifi || '</td>';
                    tabelaVisitante := tabelaVisitante || '<td >' || v_values.nome_empresa || '</td>';
                    IF V_TOTAL_VEICULO > 0 THEN
                       tabelaVisitante := tabelaVisitante || '<td >' || v_values.placa || '</td>';                    
                    END IF;
                    tabelaVisitante := tabelaVisitante || '</tr>';     
                end loop;                     

           for v_values in c_ronda loop            
                   /* PASSAR OS PARAMETROS */
                   message := replace(V_MESSAGE_TEMPLATE,'#NOME#', v_values.NOME);                    
                   message := replace(message,'#NUMERO#', P_SOLICITACAO_ID);                     
                   message := replace(message,'#SOLICITANTE#', V_SOLICITANTE);  
             --      message := replace(message,'#APROVADOR#', V_APROVADOR); 
             
             
                   if V_PERIODO = 1 THEN
                      message := replace(message,'#DATA#', '<p><strong>Data: </strong>'||TO_CHAR(V_DATA,'DD-MM-YYYY')||'</p>');  
                   else
                     message := replace(message,'#DATA#', '<p><strong>Período: </strong>'||TO_CHAR(V_DATA,'DD-MM-YYYY')||' a ' ||TO_CHAR(V_DATA+(V_PERIODO-1),'DD-MM-YYYY')||'</p>'); 
                   end if;
                   
                   message := replace(message,'#TABELA#', tabelaVisitante);      
               ---enviar e-mail ------               
                APEX_MAIL.SEND
                (
                P_TO            => v_values.EMAIL,
                --P_CC            => P_CC ,
                P_FROM          => 'noreplay-acessovisitante@enseada.com',
                P_BODY          => 'Seu cliente de email não é compatível com HTML favor procurar o suporte técnico da Enseada.',
                P_BODY_HTML     =>  message,
                P_SUBJ          => '[VISITANTE_ESTALEIRO] - Confirmação do Agendamento de Visitante - '|| V_DATA
                );
               
                APEX_MAIL.PUSH_QUEUE; 
            end loop;
                       
       EXCEPTION
        WHEN OTHERS THEN   
           DBMS_OUTPUT.PUT_LINE('Código Oracle: ' || SQLCODE);
           DBMS_OUTPUT.PUT_LINE('Mensagem Oracle: ' || SQLERRM);
       END;  
       
  END PRC_APROVADO_RONDA_SOLIC_EMAIL; 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



  PROCEDURE PRC_CRIAR_VISITA_RONDA(P_SOLICITACAO_ID NUMBER) AS
  BEGIN
        
 ------ INSERIR NO CADASTRO DE EMPRESA DE NAO EXISTIR ------------------------ 
        INSERT INTO vetorh_d.r032oem (   codoem,nomoem,apeoem, tipins, numcgc )
        
        SELECT  DISTINCT
            RANK() OVER(PARTITION BY ac_solicitacao_acesso.id ORDER BY cnpj_empresa) + (SELECT MAX(codoem) FROM vetorh_d.r032oem ) as SEQUENCIA,
            nome_empresa,nome_empresa,
            1, 
            cnpj_empresa
        FROM
            erf.ac_solicitacao_visitante ,    erf.ac_solicitacao_acesso
        WHERE  ac_solicitacao_acesso.id = ac_solicitacao_visitante.solicitacao_acesso_id
        AND cnpj_empresa IS NOT NULL
        AND NOT EXISTS ( SELECT numcgc 
                         FROM vetorh_d.r032oem 
                         WHERE numcgc = cnpj_empresa
                        )
        AND ac_solicitacao_acesso.balanca is NULL
        AND ac_solicitacao_acesso.ID = P_SOLICITACAO_ID;       
        
 
 ------ INSERIR NO CADASTRO DE VISITANTE DE NAO EXISTIR ------------------------ 
        INSERT INTO vetorh_d.r090vis (    tipdoc,    numdoc,    nomvis,    codoem,    nomoem,    codprm,    dditel,    dddtel,    telcon,    segtdo,    segdoc,    numcnh,    catcnh,    datcnh,    vencnh,    obsvis,    fotvis,    datvid,
            datfot,    flafot,    datrgv,    emicid,    estcid,    dexcid,    contpm,    codnac,    utichv,    seqreg,    emavis) 
        SELECT
            CASE 
              WHEN ESTRANGEIRO = 1 THEN 5
              ELSE 2
            END AS tipdoc,            
            cpf,           SUBSTR(nome,1,40) as nome,         
            decode(cnpj_empresa,null, 0 , NVL(( SELECT codoem FROM vetorh_d.r032oem WHERE numcgc = ac_solicitacao_visitante.cnpj_empresa AND ROWNUM = 1),0)) AS CODIGO,           
            decode(cnpj_empresa,null, AC_SOLICITACAO_VISITANTE.NOME_EMPRESA, ( SELECT nomoem FROM vetorh_d.r032oem WHERE numcgc = ac_solicitacao_visitante.cnpj_empresa AND ROWNUM = 1)) AS NOME_EMPRESA,       
            2 as codprm, -- acesso no estaleiro
            0,            0,            0,            0,            null,            null,            null,            TO_DATE('31/12/1900','DD/MM/YYYY'),            TO_DATE('31/12/1900','DD/MM/YYYY'),
            null,            null,              TO_DATE('31/12/1900','DD/MM/YYYY'),            TO_DATE('31/12/1900','DD/MM/YYYY'),                0,            TO_DATE('31/12/1900','DD/MM/YYYY'),            null,            null,                TO_DATE('31/12/1900','DD/MM/YYYY'),                null,             0,            null, 
            0,            null    
        FROM
            erf.ac_solicitacao_visitante ,    erf.ac_solicitacao_acesso
        WHERE  ac_solicitacao_acesso.id = ac_solicitacao_visitante.solicitacao_acesso_id
        AND NOT EXISTS ( SELECT numdoc 
                         FROM vetorh_d.r090vis 
                         WHERE numdoc = cpf
                        )
        AND ac_solicitacao_acesso.balanca is NULL
        AND ac_solicitacao_acesso.ID = P_SOLICITACAO_ID;

 ------ INSERIR NO CADASTRO DE VEICULO DE NAO EXISTIR ------------------------ 
        INSERT INTO vetorh_d.R088VEI ( PLAVEI )
        
        SELECT  DISTINCT ac_solicitacao_veiculo.placa
        FROM
            erf.AC_SOLICITACAO_VEICULO ,    erf.ac_solicitacao_acesso
        WHERE  ac_solicitacao_acesso.id = AC_SOLICITACAO_VEICULO.solicitacao_acesso_id
        AND PLACA IS NOT NULL
        AND NOT EXISTS ( SELECT PLACA 
                         FROM vetorh_d.R088VEI 
                         WHERE PLACA = R088VEI.PLAVEI
                        )
        AND ac_solicitacao_acesso.ID = P_SOLICITACAO_ID;            
        
 ------ INSERIR NO CADASTRO DE AGENDAMENTO DE VISITANTE SE NAO EXISTIR NA DATA ------------------------        
        INSERT INTO vetorh_d.r090agv (    datprv,    horprv,    numemp,    tipcol,    numcad,    seqagv,    tipdoc,    numdoc,    nomvis,    codoem,    nomoem,    autvei,    plavei,    tipvis,    codprm,    dditel,    dddtel,    telcon,
            datval,    horval,    empaut,    tclaut,    cadaut,    obsvis,    codusu,    visefe,    stapng,    usulib,    datlib,    horlib,    motlib,    emicid,    estcid,    dexcid,
            empsol,    tclsol,    cadsol,    empccu,    codccu,    stawav,    codlib,    codnac,    segtdo,    segdoc,    codpor,    codmot,    emavis,    verplf,    codplf,    datsag,
            horsag,    datpsa,    horpsa,    codups,    obsrep,    locagv )
        
        SELECT
        CASE WHEN to_char(data_visita,'DDMMYYYY') = to_char(sysdate,'DDMMYYYY') THEN data_visita ELSE (data_visita-1) END,        450,        2,        1,   
        3425, --NVL((SELECT TO_NUMBER(PERNR) FROM SAP_HR.VW_DOMAIN_SAP_ALL WHERE VW_DOMAIN_SAP_ALL.LOGIN  = SOLICITANTE_ID),3425) as NUNCADASTRO,       
        RANK() OVER(PARTITION BY ac_solicitacao_acesso.id ORDER BY nome) + (SELECT COUNT(*) FROM vetorh_d.r090agv WHERE TO_CHAR(datsag,'DDMMYYYY') = TO_CHAR(data_visita,'DDMMYYYY')) as SEQUENCIA,
            CASE 
              WHEN ESTRANGEIRO = 1 THEN 5
              ELSE 2
            END AS tipdoc,     
        cpf,        SUBSTR(nome,1,40) as nome, 
        decode(cnpj_empresa,null, 0 , NVL(( SELECT codoem FROM vetorh_d.r032oem WHERE numcgc = ac_solicitacao_visitante.cnpj_empresa AND ROWNUM = 1),0)) AS CODIGO,
        decode(cnpj_empresa,null, AC_SOLICITACAO_VISITANTE.NOME_EMPRESA, ( SELECT nomoem FROM vetorh_d.r032oem WHERE numcgc = ac_solicitacao_visitante.cnpj_empresa AND ROWNUM = 1)) AS NOME_EMPRESA, 
        null,        
        ac_solicitacao_veiculo.placa as Placa,  
        1,       
        2 as codprm, -- acesso no estaleiro
        0,        0,    null,      
        data_visita+(erf.ac_solicitacao_acesso.periodo-1) as DATA_VALIDADE,
        1080,        2,        1,           
        3425, --NVL((SELECT TO_NUMBER(PERNR) FROM SAP_HR.VW_DOMAIN_SAP_ALL WHERE VW_DOMAIN_SAP_ALL.LOGIN  = SOLICITANTE_ID),3425), 
        null,        108,        'N',        0,        0,       TO_DATE('31/12/1900','DD/MM/YYYY'),        0,        null,        null,        null,        TO_DATE('31/12/1900','DD/MM/YYYY'),        0,        0,        0,        0,        null,
        1,        0,        10,        0,        null,        1,        0,        null,        1,        6,        data_visita,        450,        null,        null,        null, null,       1332
        FROM
            erf.ac_solicitacao_visitante ,    erf.ac_solicitacao_acesso , AC_SOLICITACAO_VEICULO
        WHERE  ac_solicitacao_acesso.id = ac_solicitacao_visitante.solicitacao_acesso_id
        AND ac_solicitacao_visitante.solicitacao_acesso_id = ac_solicitacao_veiculo.solicitacao_acesso_id(+)
        AND ac_solicitacao_visitante.id = ac_solicitacao_veiculo.visitante_id(+)
        AND ac_solicitacao_acesso.balanca is NULL
        AND NOT EXISTS ( SELECT numdoc
                         FROM vetorh_d.r090agv 
                         WHERE numdoc = cpf
                         AND TO_CHAR(datsag,'DDMMYYYY') = TO_CHAR(data_visita,'DDMMYYYY')
                        ) 
        AND ac_solicitacao_acesso.ID = P_SOLICITACAO_ID
        AND data_visita >= SYSDATE-1;
        
  END PRC_CRIAR_VISITA_RONDA;

END PKG_AC_TOOLS;

/
