CREATE OR REPLACE PACKAGE TESTE.meuteste IS
Procedure Inicio;
Procedure Menu;
Procedure Consultar;
Procedure Incluir;
END meuteste;
/


CREATE OR REPLACE PACKAGE BODY TESTE.meuteste IS
-----------------------------------------------------------------------------------

  Procedure Inicio IS
  begin
    htp.title('Tela inicio de TOOLKIT');
    htp.framesetopen('100%','10%,*');
	   htp.frame('teste.meuteste.menu', 'menu');
	htp.framesetclose;
  end;
  
-----------------------------------------------------------------------------------

  Procedure Menu IS
  begin
    Htp.Anchor2('teste.meuteste.consultar','Consultar', 'Consultar', 'corpo');
	htp.br;
	Htp.Anchor2('teste.meuteste.incluir','Incluir', 'Incluir', 'corpo');
  end;

----------------------------------------------------------------------------------
	
  Procedure Consultar IS
  cursor c_pessoas IS SELECT pess.nome, TO_CHAR(pess.data_nascimento, 'DD/MM/YYYY') data,
                             pess.sexo, prof.descricao, pess.id, prof.id prof_id
                      FROM PESSOAS pess,
					       PROFISSOES prof
					  WHERE prof.id = pess.id_prof
					  ORDER BY pess.nome, prof.descricao;
  begin
       htp.HtmlOpen;
	     htp.title('C O N S U L T A   de  P E S S O A S');
		 htp.BodyOpen;
		    htp.centeropen;
		    htp.print(htf.bold('C O N S U L T A'));
			htp.centerclose;
			--Htp.TableData('' || Htf.Anchor('teste_oscar_pirez.incluir','Incluir',cattributes=>'TARGET=corpo CLASS=LINK'));

		    htp.FormOpen('ALTERAR', 'POST');
			Htp.TableOpen(cattributes=>'BORDER=1 WIDTH=700 ALIGN=CENTER');
			 htp.TableRowOpen();
			    htp.TableData(htf.bold('NOME'), 'center');
				htp.TableData(htf.bold('DATA'), 'center');
				htp.TableData(htf.bold('SEXO'), 'center');
				htp.TableData(htf.bold('PROFISSÃO'), 'center');
			 htp.TableRowClose;
			 FOR cur IN c_pessoas loop
		      htp.TableRowOpen();
			    htp.TableData(cur.nome);
				htp.TableData(cur.data);
				htp.TableData(cur.sexo);
				htp.TableData(cur.descricao);
                htp.TableData(htf.anchor('Teste_Oscar_Pirez.ALTERAR?P_ID='||CUR.id||'='||cur.prof_id, htf.img('http://10.0.0.5/ows-img/poli/poli_icoalterar.gif',NULL,'Alterar',cattributes=>'border=0')),'CENTER');
				htp.TableData(htf.anchor('Teste_Oscar_Pirez.APAGAR?P_ID='||CUR.id, htf.img('http://10.0.0.5/ows-img/poli/poli_icoexcluir.gif',NULL,'Excluir',cattributes=>'border=0')),'CENTER');

			  htp.TableRowCLose;
			 end loop;
		    htp.tableClose;
			htp.FormClose;
		 htp.BodyClose;
	   htp.HtmlClose;
  end;

----------------------------------------------------------------------------------
  
  Procedure Incluir IS
  cursor c_profissoes IS SELECT id, descricao
                         FROM PROFISSOES
						 ORDER BY descricao;

  w_id NUMBER;
  w_nome VARCHAR2(80);
  w_data DATE;
  w_sexo VARCHAR2(1);
  w_profissao NUMBER;
  begin
   htp.title('Inclusão de PESSOAS');
   htp.HtmlOpen;
   htp.BodyOpen;
     Htp.CenterOpen;
       Htp.FontOpen(cattributes=>'CLASS="titulo"');
         Htp.P(htf.bold('I N C L U I R'));
		 htp.br;
	     htp.br;
       Htp.FontClose;
	 Htp.CenterClose;
	 --Htp.TableData('' || Htf.Anchor('ATND.Teste_Oscar_Pirez.consultar','Consultar',cattributes=>'TARGET=corpo CLASS=LINK'));
     Htp.formopen('teste.meuteste.GRAVAR_I');
	     Htp.TableRowOpen;
	 	   Htp.TableData('Nome');
		   Htp.TableData(htf.formtext('p_nome','80','80',w_nome));
	       htp.br;
		   Htp.TableData('Data de Nascimento');
		   Htp.TableData(htf.formtext('p_data','10','10',w_data));
		   htp.br;
		   Htp.TableData('Sexo');
	       Htp.TableData(htf.FormRadio('p_sexo','M','CHECKED')||'Masculino');
		   Htp.TableData(htf.FormRadio('p_sexo','F',NULL)||'Feminino');
		   htp.br;
		   Htp.TABLEDATA('Prosissão');
		   htp.formselectopen('p_prof_id');
   	       FOR cur IN c_profissoes loop
			  htp.FormSelectOption(cur.descricao, cattributes => 'value="'||cur.id||'"');
           END loop;
	       htp.formselectclose;
		   htp.br;
   		   Htp.TableRowClose;
	  htp.centeropen;
        Htp.anchor ('javascript:document.forms[0].submit();',htf.img ('http://10.0.0.5/ows-img/poli/pch_botincl.gif',cattributes => 'border=0'));
	  htp.centerclose;
   htp.formclose;
   htp.BodyClose;
   htp.HtmlClose;
  end;

----------------------------------------------------------------------------------

end meuteste;
/





