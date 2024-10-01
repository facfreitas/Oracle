clear screen
prompt   =========================================
prompt       APW - Agenda Pessoal via Web
prompt   =========================================
prompt        (c)2000 Fernando Boaglio
prompt        http://www.oracle.trix.net
prompt   =========================================
prompt   =========================================
prompt           Instalação dos objetos:
prompt   =========================================
prompt
prompt   =========================================
prompt Eliminando objetos de uma eventual instalacao abortada
prompt   =========================================
drop table PFISICAS cascade constraints;
drop table PJURIDICAS cascade constraints;
drop table cidades cascade constraints;
drop sequence PFISICAS_id;
drop sequence PJURIDICAS_id;
drop sequence cidades_id;
drop package apw;
prompt   =========================================
prompt       Criando Tabela CIDADES
prompt   =========================================
create table cidades
(id number(4) constraint cidades_id_pk primary key,
 nome varchar2(100) constraint cidades_nome_nn not null,
 obs varchar2(400) )
/
prompt   =========================================
prompt   Criando Tabela PFISICAS (Pessoas Fisicas)
prompt   =========================================
create table PFISICAS
(id number(4) constraint pfisicas_id_pk primary key,
 nome varchar2(100) constraint pfisicas_nome_nn not null,
 endereco varchar2(200),
 fone_casa varchar2(20),
 fone_celular varchar2(20),
 fone_trabalho varchar2(20),
 data_nasc date,
 e_mail varchar2(100),
 home_page varchar2(100),
 cidade_id number(4) constraint pfisicas_cidade_id_fk references cidades(id),
 obs varchar2(400) )
/
prompt   =========================================
prompt  Criando Tabela PJURIDICAS (Pessoas Juridicas)
prompt   =========================================
create table PJURIDICAS
(id number(4) constraint pjuridicas_id_pk primary key,
 nome varchar2(100) constraint pjuridicas_nome_nn not null,
 endereco varchar2(200),
 cidade_id number(4) constraint pjuridicas_cidade_id_fk references cidades(id),
 fone varchar2(20),
 e_mail varchar2(100),
 home_page varchar2(100),
 obs varchar2(400) )
/
prompt   =========================================
prompt         Criando Sequences
prompt   =========================================
create sequence cidades_id;
create sequence PJURIDICAS_id;
create sequence PFISICAS_id;
prompt   =========================================
prompt           Inserindo dados exemplo
prompt   =========================================
insert into cidades values (cidades_id.nextval,'São Paulo (SP)',null);
insert into cidades values (cidades_id.nextval,'Campinas (SP)',null);
insert into cidades values (cidades_id.nextval,'Valinhos (SP)','perto de Campinas');
insert into cidades values (cidades_id.nextval,'Rio de Janeiro (RJ)',null);
insert into cidades values (cidades_id.nextval,'Brasília (DF)',null);
insert into cidades values (cidades_id.nextval,'Goiânia (GO)',null);
insert into cidades values (cidades_id.nextval,'Porto Alegre (RS)',null);
insert into cidades values (cidades_id.nextval,'Florianópolis (PA)',null);
insert into cidades values (cidades_id.nextval,'Salvador (BA)',null);
insert into cidades values (cidades_id.nextval,'Fortaleza (CE)',null);
insert into cidades values (cidades_id.nextval,'Maceió (AL)',null);
insert into PFISICAS values (PFISICAS_id.nextval,'Fernando Boaglio','','','','','','oracle@trix.net','http://www.oracle.trix.net',1,'qualquer problema entre em contato!');
insert into PJURIDICAS values (Pjuridicas_id.nextval,'WWW Consultoria','Rua dos Amores, 1000 ','1','555-0000','wwwcos@hotmail.com','http://www.wwwc.com.br','consultoria/desenvolvimento web');
commit;
prompt   =========================================
prompt      Criando aplicação
prompt   =========================================
create or replace package apw is

  -- Autor       : Fernando Boaglio
  -- URL         : http://www.oracle.trix.net
  -- Criado      : 14 e 15/8/2000 
  -- Aplicativo  : Agenda PL/SQL
  
  /*
  Esta aplicacao foi criada com o proposito totalmente DIDATICO, ou seja,
  para o aprendizado de aplicacoes web em PL/SQL.
  Trata-se de um sistema de consulta/cadastro e alteracao bem simples,
  envolvendo 3 tabelas: CIDADES, PFISICAS (das pessoas fisicas) e
  PJURIDICAS (das pessoas juridicas).
  Para o desenvolvimento de algo mais complexo basta adaptar a aplicacao
  e adicionar rotinas na medida do possivel.
  Numa futura implementacao poderia existir a mesma aplicacao, porem
  com suporte a varios usuarios, ou seja, varias agendas de varios
  usuarios, cada um com sua area publica e privada e cada um com a 
  sua senha.
  Se gostou dessa aplicacao e gostaria dessa nova versao mande
  um e-mail para oracle@trix.net dizendo o que achou dessa
  aplicacao.
  */
   procedure inicio; 
   -- cidade
   procedure alterar_cidade(v_id number default -1,v_opcao varchar2);
   procedure alterar_cidade2(v_id number,v_nome varchar2,v_obs varchar2);
   procedure inserir_cidade(v_nome varchar2,v_obs varchar2);
   procedure mostrar_cidade(v_id number);
   
   -- pessoa fisica
    procedure alterar_pf(v_id number default -1,v_opcao varchar2);
    procedure alterar_pf2(v_id number,v_nome varchar2,v_fone_casa varchar2,
    v_fone_trabalho varchar2,v_fone_celular varchar2,v_endereco varchar2,
    v_data_nasc owa_util.datetype,v_e_mail varchar2,v_home_page varchar2,
    v_cidade_id number, v_obs varchar2);
    procedure inserir_pf(v_nome varchar2,v_fone_casa varchar2,
    v_fone_trabalho varchar2,v_fone_celular varchar2,v_endereco varchar2,
    v_data_nasc owa_util.datetype,v_e_mail varchar2,v_home_page varchar2,
    v_cidade_id number, v_obs varchar2);
    procedure mostrar_pf(v_id number);
   
   -- pessoa juridica
   procedure alterar_pj(v_id number default -1,v_opcao varchar2);
   procedure alterar_pj2(v_id number,v_nome varchar2,v_fone varchar2,
    v_endereco varchar2,v_e_mail varchar2,v_home_page varchar2,
    v_cidade_id number, v_obs varchar2);
   procedure inserir_pj(v_nome varchar2,v_fone varchar2,v_endereco varchar2,
   v_e_mail varchar2,v_home_page varchar2, v_cidade_id number, v_obs varchar2);
   procedure mostrar_pj(v_id number);
      
   -- relatorios
   procedure relatorio;
   procedure relatorio2;
   procedure relatorio3;
   procedure relatorio4;
   
   -- busca registros
   procedure busca(v_busca varchar2,v_tipo varchar2);
   
   -- apagar registros
   procedure apagar_registro(v_id number,v_action varchar2,v_table varchar2);
    
end apw;
/
show errors
create or replace package body apw is

  -- Autor       : Fernando Boaglio
  -- URL         : http://www.oracle.trix.net
  -- Criado      : 14 e 15/8/2000 
  -- Aplicativo  : Agenda PL/SQL
  
  /*
  Esta aplicacao foi criada com o proposito totalmente DIDATICO, ou seja,
  para o aprendizado de aplicacoes web em PL/SQL.
  Trata-se de um sistema de consulta/cadastro e alteracao bem simples,
  envolvendo 3 tabelas: CIDADES, PFISICAS (das pessoas fisicas) e
  PJURIDICAS (das pessoas juridicas).
  Para o desenvolvimento de algo mais complexo basta adaptar a aplicacao
  e adicionar rotinas na medida do possivel.
  Numa futura implementacao poderia existir a mesma aplicacao, porem
  com suporte a varios usuarios, ou seja, varias agendas de varios
  usuarios, cada um com sua area publica e privada e cada um com a 
  sua senha.
  Se gostou dessa aplicacao e gostaria dessa nova versao mande
  um e-mail para oracle@trix.net dizendo o que achou dessa
  aplicacao.
  */
          --*********************************************************--
          ---------------------/ Varáveis Privadas /--------------------
          --*********************************************************--

   v_cor1       VARCHAR2(10):='#CCCC33';
   v_cor2       VARCHAR2(10):='#ccccCC';
   v_cor        VARCHAR2(10);
   v_registros  number;
   
          --*********************************************************--
          ---------------------/ Rotinas Privadas /--------------------
          --*********************************************************--
  
  --------------------------------------------------------------------------------
  --------------------------  PROCEDURE CABECALHO  -------------------------------
  --------------------------------------------------------------------------------
  
procedure cabecalho(v_title varchar2)
as
begin
 htp.htmlopen;
 htp.headopen;
 htp.title(v_title);
 htp.headclose;
 htp.bodyopen(cattributes=>'BGCOLOR="#FFFFFF"');
 htp.line;
 htp.center('<font face=verdana color=green><i>APW - Agenda Pessoal via Web</font>&nbsp;&nbsp; <font color=red size=-1> 2.1</i></font>');
 htp.line;
end;

  --------------------------------------------------------------------------------
  ----------------------------  PROCEDURE RODAPE  --------------------------------
  --------------------------------------------------------------------------------
  
procedure rodape
as
 dummy varchar2(200):=owa_util.get_cgi_env('PATH_INFO');
begin
 htp.bodyclose;
 htp.br;
 if dummy<>'/apw.inicio' then
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.code('[ '||htf.anchor('javascript:history.go(-1);','  Página anterior')||' ]'),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;
    htp.centerclose;
    htp.br;
  end if;
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.code('[ '||htf.anchor('apw.inicio','  Início')||' ]'),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;
    htp.centerclose;
 htp.br;
 htp.tableopen('noborder',cattributes => 'WIDTH="100%" cellspacing="0" cellpadding=0');
 htp.tablerowopen;
 htp.tabledata('<font size=-2 color="#ff0000">&copy;2000</font> <font size=-2>'||htf.anchor2('http://www.oracle.trix.net','Pagina de Oracle',ctarget => '_BLANK')||'</font>','RIGHT');
 htp.tablerowclose;
 htp.tablerowopen;
 htp.tabledata('<font size=-2>Powered by</font> <font size=-2 color="#ff0000">Oracle Application Server</font>','RIGHT');
 htp.tablerowclose;
 htp.tableclose;
 htp.hr;
 htp.htmlclose;
end;

  --------------------------------------------------------------------------------
  -----------------------------  PROCEDURE ERRO  ---------------------------------
  --------------------------------------------------------------------------------

   procedure erro
   as
   begin
    htp.htmlopen;
    htp.center(htf.header(2,'<font color=red>Erro!</font>'));
    htp.br;
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata('<font color=blue>'||SQLERRM||'</font> na rotina <font color=blue>'||substr(owa_util.get_cgi_env('PATH_INFO'),2)||'</font>',calign => 'CENTER');
     htp.tableRowClose; 
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata('<font color=blue>Algum Bug? Mande e-mail para </font>'||htf.mailto('oracle@trix.net','oracle@trix.net'),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;    
    htp.centerclose;      
    htp.br;
    rodape;
   end;

          --*********************************************************--
          ---------------------/ Rotinas Publicas /--------------------
          --*********************************************************--


  --------------------------------------------------------------------------------
  ---------------------------  PROCEDURE INICIO  ---------------------------------
  --------------------------------------------------------------------------------

  procedure inicio
  is
  begin
  	 cabecalho('Página inicial');
     htp.center(htf.header(3,'Selecione a op&ccedil;&atilde;o desejada:'));
     htp.centeropen;
     htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
     htp.tableCaption('<font color="#FF1010" size=+2>Relat&oacute;rios</font>','CENTER');
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.anchor('apw.relatorio','Relat&oacute;rio Geral'),calign => 'CENTER');
     htp.tableRowClose;
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.anchor('apw.relatorio2','Relat&oacute;rio de Pessoas F&iacute;sicas'),calign => 'CENTER');
     htp.tableRowClose;
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.anchor('apw.relatorio3','Relat&oacute;rio de Pessoas Jur&iacute;dicas'),calign => 'CENTER');
     htp.tableRowClose;
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.anchor('apw.relatorio4','Relat&oacute;rio de Cidades'),calign => 'CENTER');
     htp.tableRowClose;
     htp.tableclose;
     htp.br;
     htp.tableCaption('<font color="#FF1010" size=+2>Busca</font>','CENTER');
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(
       htf.br||
       htf.formopen('apw.busca')||
       htf.bold('Entre com a palavra: ')||
       '&nbsp;&nbsp;'||
       htf.formtext('v_busca')||
       '&nbsp;&nbsp;'||
       htf.formselectopen('v_tipo')||
       htf.formselectoption('Pessoa F&iacute;sica',cattributes => 'VALUE="1"')||
       htf.formselectoption('Pessoa Jur&iacute;dica',cattributes => 'VALUE="2"')||
       htf.formselectoption('Cidade',cattributes => 'VALUE="3"')||
       htf.formselectoption('Tudo',cselected => 'sim',cattributes => 'VALUE="4"')||
       htf.formselectclose||
       '&nbsp;&nbsp;'||
       htf.formsubmit(cvalue => 'buscar')||
       htf.formclose,       
       calign => 'CENTER');
     htp.tableRowClose;  
     htp.tableClose;
     htp.br;
     htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
     htp.tableCaption('<font color="#FF1010" size=+2>Cadastros</font>','CENTER');
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.anchor('apw.alterar_cidade?v_opcao=Inserir','Cadastrar Cidade'),calign => 'CENTER');
     htp.tableRowClose;
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.anchor('apw.alterar_pf?v_opcao=Inserir','Cadastrar Pessoa F&iacute;sica'),calign => 'CENTER');
     htp.tableRowClose;
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.anchor('apw.alterar_pj?v_opcao=Inserir','Cadastrar Pessoa Jur&iacute;dica'),calign => 'CENTER');
     htp.tableRowClose;
     htp.tableclose;
     htp.br;
     htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');  
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.anchor('javascript:self.close();','Sair'),calign => 'CENTER');
     htp.tableRowClose;  
     htp.tableClose;
     htp.centerclose;
  	 rodape;
        exception when others then erro; 
  end; 
  
  --------------------------------------------------------------------------------
  ---------------------------  PROCEDURE alterar_cidade---------------------------
  --------------------------------------------------------------------------------

   procedure alterar_cidade(v_id number default -1,v_opcao varchar2)
   as
    cursor cid is select * from cidades where id=v_id;
   begin
    cabecalho(v_opcao);
   if v_opcao='Apagar' then
    -- APAGAR
    htp.br;
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.strong('Apagar o registro '||v_id||' Tem certeza ? '),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;
    htp.br;
    htp.formopen('apw.apagar_registro');
    htp.formhidden('v_id',v_id); 
    htp.formhidden('v_table','cidades');
    htp.formsubmit('v_action','Sim');
    htp.formsubmit('v_action','Não');   
    htp.centerclose;    
   elsif v_opcao='Alterar' then
    -- ALTERAR
    htp.centeropen;
    htp.formopen('apw.alterar_cidade2');
    for r_rec in cid loop
    htp.formhidden('v_id',v_id);
    htp.tableopen(cborder => 'noborder');
    htp.tablerowopen;
     htp.tabledata('Nome: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_nome',cvalue => r_rec.nome));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Obs: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_obs',cvalue => r_rec.obs));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata(htf.formsubmit(cvalue=>'Alterar'),'CENTER',ccolspan => '2');    
    htp.tablerowclose;   
    htp.tableclose;
    end loop;
    htp.formclose;
    htp.centerclose;  
   else 
     -- INSERIR
    htp.centeropen;
    htp.formopen('apw.inserir_cidade');
    htp.tableopen(cborder => 'noborder');
    htp.tablerowopen;
     htp.tabledata('Nome:',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_nome',csize => '60'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Obs:',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_obs'));
    htp.tablerowclose;    
    htp.tablerowopen;
    htp.tabledata(htf.formsubmit(cvalue=>'Cadastrar'),'CENTER',ccolspan => '2');
    htp.tablerowclose;
    htp.tableclose;
    htp.formclose;
    htp.centerclose;   
   end if;
   rodape;
      exception when others then erro; 
   end;
   
  --------------------------------------------------------------------------------
  --------------------------  PROCEDURE alterar_cidade2---------------------------
  --------------------------------------------------------------------------------

   procedure alterar_cidade2(v_id number,v_nome varchar2,v_obs varchar2)
   as
    begin
    cabecalho('Alterar Cidade...');
    update cidades
    set nome=v_nome,obs=v_obs
    where id = v_id;
    htp.br;
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.strong('Registro atualizado com <font color="#00FF00">sucesso</font> !!!'),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;
    htp.centerclose;
    rodape;
       exception when others then erro; 
   end;
  
  --------------------------------------------------------------------------------
  ---------------------------  PROCEDURE alterar_pf ------------------------------
  --------------------------------------------------------------------------------

   procedure alterar_pf(v_id number default -1,v_opcao varchar2)
   as
    cursor pf is select * from pfisicas where id=v_id;
    cursor cid is select id,nome from cidades order by 2;
   begin
    cabecalho(v_opcao);
   if v_opcao='Apagar' then
    -- APAGAR
    htp.br;
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.strong('Apagar o registro '||v_id||' Tem certeza ? '),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;
    htp.br;
    htp.formopen('apw.apagar_registro');
    htp.formhidden('v_id',v_id); 
    htp.formhidden('v_table','pfisicas');
    htp.formsubmit('v_action','Sim');
    htp.formsubmit('v_action','Não');   
    htp.centerclose;    
   elsif v_opcao='Alterar' then
    -- ALTERAR
    htp.centeropen;
    htp.formopen('apw.alterar_pf2');
    for r_rec in pf loop
    htp.formhidden('v_id',v_id);
    htp.tableopen(cborder => 'noborder');
    htp.tablerowopen;
     htp.tabledata('Nome: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_nome',csize => '70',cvalue => r_rec.nome));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Endereço: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_endereco',csize => '70',cvalue => r_rec.endereco));
    htp.tablerowclose;
    htp.tablerowopen;
    htp.tabledata('Cidade: ',calign => 'CENTER');
    htp.p('<td>');    
    htp.formselectopen('v_cidade_id',' ');
    for rec_cid in cid loop 
     if rec_cid.id = r_rec.cidade_id then
      htp.formselectoption(rec_cid.nome,'sim','VALUE="'||rec_cid.id||'"');
     else
      htp.formselectoption(rec_cid.nome,cattributes => 'VALUE="'||rec_cid.id||'"');
     end if;
    end loop;
    htp.formselectclose;
    htp.p('</td>');
    htp.tablerowclose;        
    htp.tablerowopen;
     htp.tabledata('Fone Casa: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_fone_casa',csize => '70',cvalue => r_rec.fone_casa));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Fone Trabalho: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_fone_trabalho',csize => '70',cvalue => r_rec.fone_trabalho));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Fone Celular: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_fone_celular',csize => '70',cvalue => r_rec.fone_celular));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('E-mail: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_e_mail',csize => '70',cvalue => r_rec.e_mail));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Nascimento: ',calign => 'CENTER');
     htp.p('<td align="CENTER">');
     owa_util.choose_date('v_data_nasc',nvl(r_rec.data_nasc,sysdate));
     htp.p('</td>');
     htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Home Page: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_home_page',csize => '70',cvalue => r_rec.home_page));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Obs: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_obs',csize => '70',cvalue => r_rec.obs));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata(htf.formsubmit(cvalue=>'Alterar'),'CENTER',ccolspan => '2');    
    htp.tablerowclose;   
    htp.tableclose;
    end loop;
    htp.formclose;
    htp.centerclose;  
   else 
     -- INSERIR
   htp.centeropen;
    htp.formopen('apw.inserir_pf');
    htp.tableopen(cborder => 'noborder');
    htp.tablerowopen;
     htp.tabledata('Nome: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_nome',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Endereço: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_endereco',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
    htp.tabledata('Cidade: ',calign => 'CENTER');
    htp.p('<td>');    
    htp.formselectopen('v_cidade_id',' ');
    for rec_cid in cid loop 
     if rec_cid.id = 1 then
      htp.formselectoption(rec_cid.nome,'sim','VALUE="'||rec_cid.id||'"');
     else
      htp.formselectoption(rec_cid.nome,cattributes => 'VALUE="'||rec_cid.id||'"');
     end if;
    end loop;
    htp.formselectclose;
    htp.p('</td>');
    htp.tablerowclose;        
    htp.tablerowopen;
     htp.tabledata('Fone Casa: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_fone_casa',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Fone Trabalho: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_fone_trabalho',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Fone Celular: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_fone_celular',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('E-mail: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_e_mail',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Nascimento: ',calign => 'CENTER');
     htp.p('<td align="CENTER">');
     owa_util.choose_date('v_data_nasc',sysdate);
     htp.p('</td>');
     htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Home Page: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_home_page',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Obs: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_obs',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata(htf.formsubmit(cvalue=>'Cadastrar'),'CENTER',ccolspan => '2');    
    htp.tablerowclose;   
    htp.tableclose;
    htp.formclose;
    htp.centerclose;  
   end if;
   rodape;
      exception when others then erro; 
   end;
  

  --------------------------------------------------------------------------------
  ----------------------------  PROCEDURE alterar_pf2 ----------------------------
  --------------------------------------------------------------------------------
  
   procedure alterar_pf2(v_id number,v_nome varchar2,v_fone_casa varchar2,
    v_fone_trabalho varchar2,v_fone_celular varchar2,v_endereco varchar2,
    v_data_nasc owa_util.datetype,v_e_mail varchar2,v_home_page varchar2,
    v_cidade_id number, v_obs varchar2)
   as
    v_data date;
   begin
    v_data := owa_util.todate(v_data_nasc);
    cabecalho('Alterar Pessoa Física...');
    update pfisicas
    set nome=v_nome, fone_casa=v_fone_casa,fone_trabalho=v_fone_trabalho,
    fone_celular=v_fone_celular , endereco=v_endereco, 
    data_nasc = v_data,
    e_mail=v_e_mail, home_page=v_home_page,cidade_id=v_cidade_id,obs=v_obs 
    where id = v_id;
    htp.br;
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.strong('Registro atualizado com <font color="#00FF00">sucesso</font> !!!'),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;
    htp.centerclose;
    rodape;
       exception when others then erro; 
    end;
  
  
  --------------------------------------------------------------------------------
  ---------------------------  PROCEDURE alterar_pj ------------------------------
  --------------------------------------------------------------------------------

   procedure alterar_pj(v_id number default -1,v_opcao varchar2)
   as
    cursor pj is select * from pjuridicas where id=v_id;
    cursor cid is select id,nome from cidades order by 2;
   begin
   cabecalho(v_opcao);
   if v_opcao='Apagar' then
    -- APAGAR
    htp.br;
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.strong('Apagar o registro '||v_id||' Tem certeza ? '),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;
    htp.br;
    htp.formopen('apw.apagar_registro');
    htp.formhidden('v_id',v_id); 
    htp.formhidden('v_table','pjuridicas');
    htp.formsubmit('v_action','Sim');
    htp.formsubmit('v_action','Não');   
    htp.centerclose;    
   elsif v_opcao='Alterar' then
    -- ALTERAR
    htp.centeropen;
    htp.formopen('apw.alterar_pj2');
    for r_rec in pj loop
    htp.formhidden('v_id',v_id);
    htp.tableopen(cborder => 'noborder');
    htp.tablerowopen;
     htp.tabledata('Nome: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_nome',csize => '70',cvalue => r_rec.nome));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Endereço: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_endereco',csize => '70',cvalue => r_rec.endereco));
    htp.tablerowclose;
    htp.tablerowopen;
    htp.tabledata('Cidade: ',calign => 'CENTER');
    htp.p('<td>');    
    htp.formselectopen('v_cidade_id',' ');
    for rec_cid in cid loop 
     if rec_cid.id = r_rec.cidade_id then
      htp.formselectoption(rec_cid.nome,'sim','VALUE="'||rec_cid.id||'"');
     else
      htp.formselectoption(rec_cid.nome,cattributes => 'VALUE="'||rec_cid.id||'"');
     end if;
    end loop;
    htp.formselectclose;
    htp.p('</td>');
    htp.tablerowclose;        
    htp.tablerowopen;
     htp.tabledata('Fone: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_fone',csize => '70',cvalue => r_rec.fone));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('E-mail: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_e_mail',csize => '70',cvalue => r_rec.e_mail));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Home Page: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_home_page',csize => '70',cvalue => r_rec.home_page));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Obs: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_obs',csize => '70',cvalue => r_rec.obs));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata(htf.formsubmit(cvalue=>'Alterar'),'CENTER',ccolspan => '2');    
    htp.tablerowclose;   
    htp.tableclose;
    end loop;
    htp.formclose;
    htp.centerclose;  
   else 
     -- INSERIR
   htp.centeropen;
    htp.formopen('apw.inserir_pj');
    htp.tableopen(cborder => 'noborder');
    htp.tablerowopen;
     htp.tabledata('Nome: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_nome',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Endereço: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_endereco',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
    htp.tabledata('Cidade: ',calign => 'CENTER');
    htp.p('<td>');    
    htp.formselectopen('v_cidade_id',' ');
    for rec_cid in cid loop 
     if rec_cid.id = 1 then
      htp.formselectoption(rec_cid.nome,'sim','VALUE="'||rec_cid.id||'"');
     else
      htp.formselectoption(rec_cid.nome,cattributes => 'VALUE="'||rec_cid.id||'"');
     end if;
    end loop;
    htp.formselectclose;
    htp.p('</td>');
    htp.tablerowclose;        
    htp.tablerowopen;
     htp.tabledata('Fone: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_fone',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('E-mail: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_e_mail',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Home Page: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_home_page',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata('Obs: ',calign => 'CENTER');
     htp.tabledata(htf.formtext('v_obs',csize => '70'));
    htp.tablerowclose;
    htp.tablerowopen;
     htp.tabledata(htf.formsubmit(cvalue=>'Cadastrar'),'CENTER',ccolspan => '2');    
    htp.tablerowclose;   
    htp.tableclose;
    htp.formclose;
    htp.centerclose;  
   end if;
   rodape;
      exception when others then erro; 
   end;
  
  --------------------------------------------------------------------------------
  ----------------------------  PROCEDURE alterar_pj2 ----------------------------
  --------------------------------------------------------------------------------
  
   procedure alterar_pj2(v_id number,v_nome varchar2,v_fone varchar2,
    v_endereco varchar2,v_e_mail varchar2,v_home_page varchar2,
    v_cidade_id number, v_obs varchar2)
   as
   begin
    cabecalho('Alterar Pessoa Jurídica...');
    update pjuridicas
    set nome=v_nome, fone=v_fone,endereco=v_endereco, 
    e_mail=v_e_mail, home_page=v_home_page,cidade_id=v_cidade_id,obs=v_obs 
    where id = v_id;
    htp.br;
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.strong('Registro atualizado com <font color="#00FF00">sucesso</font> !!!'),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;
    htp.centerclose;
    rodape;
       exception when others then erro; 
    end;
   
  --------------------------------------------------------------------------------
  --------------------------  PROCEDURE inserir_pf   -----------------------------
  --------------------------------------------------------------------------------
   
  procedure inserir_pf(v_nome varchar2,v_fone_casa varchar2,
    v_fone_trabalho varchar2,v_fone_celular varchar2,v_endereco varchar2,
    v_data_nasc owa_util.datetype,v_e_mail varchar2,v_home_page varchar2,
    v_cidade_id number, v_obs varchar2)
    as
     v_data date;
   begin
    v_data := owa_util.todate(v_data_nasc);
   cabecalho('Inserir Pessoa Física...');
    insert into pfisicas
    values(pfisicas_ID.nextval,v_nome,v_endereco,v_fone_casa,v_fone_celular,
    v_fone_trabalho,v_data,v_e_mail,v_home_page,v_cidade_id,v_obs);
    htp.br;
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.strong('Registro inserido com <font color="#00FF00">sucesso</font> !!!'),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;
    htp.centerclose;
    rodape;
       exception when others then erro; 
  end;
     
  --------------------------------------------------------------------------------
  --------------------------  PROCEDURE inserir_pj   ----------------------------
  --------------------------------------------------------------------------------
   
  procedure inserir_pj(v_nome varchar2,v_fone varchar2,v_endereco varchar2,
   v_e_mail varchar2,v_home_page varchar2, v_cidade_id number, v_obs varchar2)
    as
   begin
   cabecalho('Inserir Pessoa Jurídica...');
    insert into pjuridicas
    values(pjuridicas_ID.nextval,v_nome,v_endereco,v_cidade_id,v_fone,
     v_e_mail,v_home_page,v_obs);
    htp.br;
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.strong('Registro inserido com <font color="#00FF00">sucesso</font> !!!'),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;
    htp.centerclose;
    rodape;
       exception when others then erro; 
  end;
      
  --------------------------------------------------------------------------------
  ----------------------------  PROCEDURE Relatorio -----------------------------
  --------------------------------------------------------------------------------

   procedure relatorio
    as
      cursor relatorio2 is
       select * from pfisicas order by 2;
      cursor relatorio3 is
       select * from pjuridicas order by 2;
   begin
   cabecalho('Relatório Geral');
   htp.centeropen;
   htp.tableOpen(Cborder => 'border=2');
   htp.tablecaption('Todas as pessoas jurídicas','CENTER');
   htp.tablerowopen;
    htp.tableheader('Nome');
    htp.tableheader('Fone Casa');
    htp.tableheader('Fone Trabalho');
    htp.tableheader('Fone Celular');
    htp.tableheader('e-mail');
    htp.tableheader('Home Page');
   for r_rec in relatorio2 loop
    if v_cor=v_cor1
       then
        v_cor:=v_cor2;
       else
        v_cor:=v_cor1;
      end if;
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor||'"');
     htp.tableData(htf.anchor('apw.mostrar_pf?v_id='||r_Rec.id,r_rec.nome),'CENTER');
     htp.tableData(nvl(r_rec.fone_casa,'-----------'),'CENTER');
     htp.tableData(nvl(r_rec.fone_trabalho,'-----------'),'CENTER');
     htp.tableData(nvl(r_rec.fone_celular,'-----------'),'CENTER');
     if r_rec.e_mail is null then
       htp.tableData('-----------','CENTER');
      else
       htp.tableData(htf.mailto(r_rec.e_mail,r_rec.e_mail),'CENTER');
     end if;
     if r_rec.home_page is null then
       htp.tableData('-----------','CENTER');
      else
       htp.tableData(htf.anchor2(r_rec.home_page,r_rec.home_page,ctarget => '_blank'),'CENTER');      
     end if;
     htp.tableRowClose;
   v_registros:=relatorio2%ROWCOUNT;
   end loop;
   htp.tableClose;
   htp.centerclose;
   htp.br;
   if v_registros=1
    then htp.center(htf.strong('Total de 1 registro cadastrado'));
     elsif v_registros is null then  htp.center(htf.strong('Nenhum registro cadastrado'));
    else htp.center(htf.strong('Total de '||v_registros||' registros cadastrados'));
   end if;   
   htp.br;
   htp.br;
    htp.centeropen;
   htp.tableOpen(Cborder => 'border=2');
   htp.tablecaption('Todas as pessoas físicas','CENTER');
   htp.tablerowopen;
    htp.tableheader('Nome');
    htp.tableheader('Fone');
    htp.tableheader('Obs');
    htp.tableheader('E-mail');
    htp.tableheader('Home Page');
   for r_rec in relatorio3 loop
    if v_cor=v_cor1
       then
        v_cor:=v_cor2;
       else
        v_cor:=v_cor1;
      end if;
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor||'"');
     htp.tableData(htf.anchor('apw.mostrar_pj?v_id='||r_Rec.id,r_rec.nome),'CENTER');
     htp.tableData(nvl(r_rec.fone,'-----------'),'CENTER');
     htp.tableData(nvl(r_rec.obs,'-----------'),'CENTER');
     if r_rec.e_mail is null then
       htp.tableData('-----------','CENTER');
      else
       htp.tableData(htf.mailto(r_rec.e_mail,r_rec.e_mail),'CENTER');
     end if;
     if r_rec.home_page is null then
       htp.tableData('-----------','CENTER');
      else
       htp.tableData(htf.anchor2(r_rec.home_page,r_rec.home_page,ctarget => '_blank'),'CENTER');      
     end if;
     htp.tableRowClose;
   v_registros:=relatorio3%ROWCOUNT;
   end loop;
   htp.tableClose;
   htp.centerclose;
   htp.br;
   htp.br;
   if v_registros=1
    then htp.center(htf.strong('Total de 1 registro cadastrado'));
     elsif v_registros is null then  htp.center(htf.strong('Nenhum registro cadastrado'));
    else htp.center(htf.strong('Total de '||v_registros||' registros cadastrados'));
   end if;   
   htp.br;
   rodape;
      exception when others then erro; 
   end;
   
  --------------------------------------------------------------------------------
  ----------------------------  PROCEDURE Relatorio2 -----------------------------
  --------------------------------------------------------------------------------

   procedure relatorio2
    as
      cursor relatorio2 is
    select * from pfisicas order by 2;
   begin
   cabecalho('Relatório Geral - Pessoa Jurídica');
   htp.centeropen;
   htp.tableOpen(Cborder => 'border=2');
   htp.tablecaption('Todas as pessoas jurídicas','CENTER');
   htp.tablerowopen;
    htp.tableheader('Nome');
    htp.tableheader('Fone Casa');
    htp.tableheader('Fone Trabalho');
    htp.tableheader('Fone Celular');
    htp.tableheader('e-mail');
    htp.tableheader('Home Page');
   for r_rec in relatorio2 loop
    if v_cor=v_cor1
       then
        v_cor:=v_cor2;
       else
        v_cor:=v_cor1;
      end if;
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor||'"');
     htp.tableData(htf.anchor('apw.mostrar_pf?v_id='||r_Rec.id,r_rec.nome),'CENTER');
     htp.tableData(nvl(r_rec.fone_casa,'-----------'),'CENTER');
     htp.tableData(nvl(r_rec.fone_trabalho,'-----------'),'CENTER');
     htp.tableData(nvl(r_rec.fone_celular,'-----------'),'CENTER');
     if r_rec.e_mail is null then
       htp.tableData('-----------','CENTER');
      else
       htp.tableData(htf.mailto(r_rec.e_mail,r_rec.e_mail),'CENTER');
     end if;
     if r_rec.home_page is null then
       htp.tableData('-----------','CENTER');
      else
       htp.tableData(htf.anchor2(r_rec.home_page,r_rec.home_page,ctarget => '_blank'),'CENTER');      
     end if;
     htp.tableRowClose;
   v_registros:=relatorio2%ROWCOUNT;
   end loop;
   htp.tableClose;
   htp.centerclose;
   htp.br;
   htp.br;
   if v_registros=1
    then htp.center(htf.strong('Total de 1 registro cadastrado'));
     elsif v_registros is null then  htp.center(htf.strong('Nenhum registro cadastrado'));
    else htp.center(htf.strong('Total de '||v_registros||' registros cadastrados'));
   end if;   
   htp.br;
   rodape;
      exception when others then erro; 
   end;
                  
  --------------------------------------------------------------------------------
  ----------------------------  PROCEDURE Relatorio3 -----------------------------
  --------------------------------------------------------------------------------

   procedure relatorio3
    as
      cursor relatorio3 is
    select * from pjuridicas order by 2;
   begin
   cabecalho('Relatório Geral - Pessoa Física');
   htp.centeropen;
   htp.tableOpen(Cborder => 'border=2');
   htp.tablecaption('Todas as pessoas físicas','CENTER');
   htp.tablerowopen;
    htp.tableheader('Nome');
    htp.tableheader('Fone');
    htp.tableheader('Obs');
    htp.tableheader('E-mail');
    htp.tableheader('Home Page');
   for r_rec in relatorio3 loop
    if v_cor=v_cor1
       then
        v_cor:=v_cor2;
       else
        v_cor:=v_cor1;
      end if;
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor||'"');
     htp.tableData(htf.anchor('apw.mostrar_pj?v_id='||r_Rec.id,r_rec.nome),'CENTER');
     htp.tableData(nvl(r_rec.fone,'-----------'),'CENTER');
     htp.tableData(nvl(r_rec.obs,'-----------'),'CENTER');
     if r_rec.e_mail is null then
       htp.tableData('-----------','CENTER');
      else
       htp.tableData(htf.mailto(r_rec.e_mail,r_rec.e_mail),'CENTER');
     end if;
     if r_rec.home_page is null then
       htp.tableData('-----------','CENTER');
      else
       htp.tableData(htf.anchor2(r_rec.home_page,r_rec.home_page,ctarget => '_blank'),'CENTER');      
     end if;
     htp.tableRowClose;
   v_registros:=relatorio3%ROWCOUNT;
   end loop;
   htp.tableClose;
   htp.centerclose;
   htp.br;
   rodape;
      exception when others then erro; 
   end;
         
  --------------------------------------------------------------------------------
  ----------------------------  PROCEDURE Relatorio4 -----------------------------
  --------------------------------------------------------------------------------

   procedure relatorio4
    as
      cursor relatorio4 is
    select id,nome,obs from cidades order by 1;
   begin
   cabecalho('Relatório Geral - Cidades');
   htp.centeropen;
   htp.tableOpen(Cborder => 'border=2');
   htp.tablecaption('Todas as cidades','CENTER');
   htp.tablerowopen;
    htp.tableheader('Nome');
    htp.tableheader('Obs:');
   for r_rec in relatorio4 loop
    if v_cor=v_cor1
       then
        v_cor:=v_cor2;
       else
        v_cor:=v_cor1;
      end if;
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor||'"');
     htp.tableData(htf.anchor('apw.mostrar_cidade?v_id='||r_Rec.id,r_rec.nome),'CENTER');
     htp.tableData(nvl(r_rec.obs,'-----------'),'CENTER');
     htp.tableRowClose;
   v_registros:=relatorio4%ROWCOUNT;
   end loop;
   htp.tableClose;
   htp.centerclose;
   htp.br;
   if v_registros=1
    then htp.center(htf.strong('Total de 1 registro cadastrado'));
     elsif v_registros is null then  htp.center(htf.strong('Nenhum registro cadastrado'));
    else htp.center(htf.strong('Total de '||v_registros||' registros cadastrados'));
   end if;   
   htp.br;
   rodape;
      exception when others then erro; 
   end;
       
  --------------------------------------------------------------------------------
  ------------------------  PROCEDURE APAGAR_Registro ----------------------------
  --------------------------------------------------------------------------------
  
   procedure apagar_registro(v_id number,v_action varchar2,v_table varchar2)
   as
    V_CURSOR NUMBER;
    V_RETURN NUMBER;
    comando varchar2(40):='delete '||v_table||' where id='||v_id;
  begin
    if v_action='Sim' then
    cabecalho('Registro '||v_id||' excluído ');
    -- Sim
    V_CURSOR:=DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(V_CURSOR,COMANDO,DBMS_SQL.NATIVE);
    V_RETURN := DBMS_SQL.EXECUTE(V_CURSOR);
    DBMS_SQL.CLOSE_CURSOR(V_CURSOR);
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.strong('Registro '||v_id||' excluído <font color="#00FF00">sucesso</font> !!!'),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;
    htp.centerclose;
    rodape;
    else
    -- Não
    inicio;
   end if; 
      exception when others then erro; 
  end;
         
  --------------------------------------------------------------------------------
  ------------------------  PROCEDURE inserir_cidade  ----------------------------
  --------------------------------------------------------------------------------
   
  procedure inserir_cidade(v_nome varchar2,v_obs varchar2)
   as
   begin
   cabecalho('Inserir cidade...');
    insert into cidades
    values(cidades_ID.nextval,v_nome,v_obs);
    htp.br;
    htp.centeropen;
    htp.tableOpen('border=5',cattributes=>' WIDTH="70%"');
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
     htp.tabledata(htf.strong('Registro inserido com <font color="#00FF00">sucesso</font> !!!'),calign => 'CENTER');
     htp.tableRowClose; 
    htp.tableclose;
    htp.centerclose;
    rodape;
       exception when others then erro; 
  end;
       
  --------------------------------------------------------------------------------
  ------------------------  PROCEDURE mostra_cidade  ----------------------------
  --------------------------------------------------------------------------------
   
  procedure mostrar_cidade(v_id number)
  as
   cursor mostra1 is select * from cidades where id=v_id;
  begin
   cabecalho('Mostrando cidade: registro >>>'||v_id);
 	 htp.centeropen;
   htp.tableOpen('border=5');
   for nome1_rec in mostra1 loop
    htp.tablerowopen;
    htp.tableData('Registro','RIGHT');
    htp.tableData(nome1_rec.id);
    htp.tableRowClose;
    htp.tablerowopen;
    htp.tableData('Nome','RIGHT');
    htp.tableData(nome1_rec.nome);
    htp.tableRowClose;
    htp.tablerowopen;
    htp.tableData('Obs','RIGHT');
    htp.tableData(nome1_rec.obs);
    htp.tableRowClose;
   end loop;
   htp.tableClose;
   htp.centerclose;
   htp.br;
   htp.centeropen;
   htp.formopen('apw.alterar_cidade');
   htp.formhidden('v_id',v_id);
   htp.formsubmit('v_opcao','Alterar');
   htp.formsubmit('v_opcao','Apagar');
   htp.formclose;
   htp.centerclose;
   htp.br;   
 	 rodape;
      exception when others then erro; 
  end;
  
  --------------------------------------------------------------------------------
  --------------------------  PROCEDURE mostra_PF     ----------------------------
  --------------------------------------------------------------------------------
   
  procedure mostrar_pf(v_id number)
  as
   cursor mostra1 is select * from pfisicas where id=v_id;
   v_cidade cidades.nome%type default '--------';
  begin
   cabecalho('Mostrando Pessoa Física: registro '||v_id);
   htp.br;
 	 htp.centeropen;
   htp.tableOpen('border=5 width="70%"');
   for nome1_rec in mostra1 loop
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor1||'"');
    htp.tableData('Registro','CENTER');
    htp.tableData(htf.strong(nome1_rec.id),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
    htp.tableData('Nome','CENTER');
    htp.tableData(htf.strong(nome1_rec.nome),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor1||'"');
    htp.tableData('Endereço','CENTER');
    htp.tableData(htf.strong(nvl(nome1_rec.endereco,'----------')),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
    htp.tableData('Fone Casa','CENTER');
    htp.tableData(htf.strong(nvl(nome1_rec.fone_casa,'----------')),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor1||'"');
    htp.tableData('Fone Trabalho','CENTER');
    htp.tableData(htf.strong(nvl(nome1_rec.fone_trabalho,'----------')),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
    htp.tableData('Fone Celular','CENTER');
    htp.tableData(htf.strong(nvl(nome1_rec.fone_celular,'----------')),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor1||'"');
    htp.tableData('E-mail','CENTER');
    htp.tableData(htf.strong(nvl(nome1_rec.e_mail,'----------')),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
    htp.tableData('Nascimento','CENTER');
    htp.tableData(htf.strong(nvl(to_char(nome1_rec.data_nasc),'----------')),'CENTER');
    htp.tableRowClose;
    select nvl(nome,'--------')
    into v_cidade
    from cidades
    where id = nome1_rec.cidade_id;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor1||'"');
    htp.tableData('Cidade','CENTER');
    htp.tableData(htf.strong(v_cidade),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
    htp.tableData('Obs','CENTER');
    htp.tableData(htf.strong(nvl(nome1_rec.obs,'----------')),'CENTER');
    htp.tableRowClose;
   end loop;
   htp.tableClose;
   htp.centerclose;
   htp.br;
   htp.centeropen;
   htp.formopen('apw.alterar_pf');
   htp.formhidden('v_id',v_id);
   htp.formsubmit('v_opcao','Alterar');
   htp.formsubmit('v_opcao','Apagar');
   htp.formclose;
   htp.centerclose;
   htp.br;   
 	 rodape;
   exception when others then erro;   
  end;
   
  --------------------------------------------------------------------------------
  --------------------------  PROCEDURE mostra_PJ     ----------------------------
  --------------------------------------------------------------------------------
   
  procedure mostrar_pj(v_id number)
  as
   cursor mostra1 is select * from pjuridicas where id=v_id;
   v_cidade cidades.nome%type default '--------';
  begin
   cabecalho('Mostrando Pessoa Jurídica: registro '||v_id);
   htp.br;
 	 htp.centeropen;
   htp.tableOpen('border=5 width="70%"');
   for nome1_rec in mostra1 loop
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor1||'"');
    htp.tableData('Registro','CENTER');
    htp.tableData(htf.strong(nome1_rec.id),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
    htp.tableData('Nome','CENTER');
    htp.tableData(htf.strong(nome1_rec.nome),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor1||'"');
    htp.tableData('Endereço','CENTER');
    htp.tableData(htf.strong(nvl(nome1_rec.endereco,'----------')),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
    htp.tableData('Fone','CENTER');
    htp.tableData(htf.strong(nvl(nome1_rec.fone,'----------')),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor1||'"');
    htp.tableData('E-mail','CENTER');
    htp.tableData(htf.strong(nvl(nome1_rec.e_mail,'----------')),'CENTER');
    htp.tableRowClose;
    select nvl(nome,'--------')
    into v_cidade
    from cidades
    where id = nome1_rec.cidade_id;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor1||'"');
    htp.tableData('Cidade','CENTER');
    htp.tableData(htf.strong(v_cidade),'CENTER');
    htp.tableRowClose;
    htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor2||'"');
    htp.tableData('Obs','CENTER');
    htp.tableData(htf.strong(nvl(nome1_rec.obs,'----------')),'CENTER');
    htp.tableRowClose;
   end loop;
   htp.tableClose;
   htp.centerclose;
   htp.br;
   htp.centeropen;
   htp.formopen('apw.alterar_pj');
   htp.formhidden('v_id',v_id);
   htp.formsubmit('v_opcao','Alterar');
   htp.formsubmit('v_opcao','Apagar');
   htp.formclose;
   htp.centerclose;
   htp.br;   
 	 rodape;
   exception when others then erro;   
  end;
  
  --------------------------------------------------------------------------------
  --------------------------  PROCEDURE busca ------------------------------------
  --------------------------------------------------------------------------------
  
  procedure busca(v_busca varchar2,v_tipo varchar2)
   
   as
   -- tipo record nome_rec_type
   type nome_rec_type is record
   ( v_id number(4),
     v_nome varchar2(100),
     v_obs varchar2(400) );
   
   -- tipo variavel cursor nome_cur_type (ponteiro)
   type nome_cur_type is REF CURSOR return nome_rec_type;   
 
   -- variavel do tipo nome_cur_type
   nome_cur nome_cur_type;
   
   -- Variaveis que receberao o resultado do FETCH
   v_id number(4);
   v_nome varchar2(100);
   v_obs varchar2(400);
    
   -- variavel da busca para uso no LIKE
   v_busca2 varchar2(100):='%'||lower(v_busca)||'%';
     
   begin   
   cabecalho('Buscando...');
   htp.centeropen;
   htp.header(3,'Buscando por <font color="#3366CC">'||v_busca||'</font>');
   htp.centerclose;
   htp.br;      
   if v_tipo=1 then 
     -- Pessoa Fisica
    open nome_cur for 
       select id,nome,obs from pfisicas 
       where lower(NOME) like v_busca2
       or lower(endereco) like v_busca2
       or lower(FONE_CASA) like v_busca2
       or lower(FONE_CELULAR) like v_busca2
       or lower(FONE_TRABALHO) like v_busca2
       or lower(to_char(DATA_NASC)) like v_busca2
       or lower(E_MAIL) like v_busca2
       or lower(HOME_PAGE) like v_busca2
       or lower(OBS) like v_busca2
       order by 2;       
    elsif v_tipo=2 then
      -- Pessoa Juridica
    open nome_cur for 
       select id,nome,obs from pjuridicas 
       where lower(NOME) like v_busca2
       or lower(endereco) like v_busca2
       or lower(FONE) like v_busca2
       or lower(E_MAIL) like v_busca2
       or lower(HOME_PAGE) like v_busca2
       or lower(OBS) like v_busca2
       order by 2;     
    elsif v_tipo=3 then
      -- Cidade
    open nome_cur for 
       select id,nome,obs from cidades 
       where lower(NOME) like v_busca2
       or lower(OBS) like v_busca2
       order by 2;    
     else
       -- TUDO
    open nome_cur for 
       select id,nome,obs from pfisicas 
       where lower(NOME) like v_busca2
       or lower(endereco) like v_busca2
       or lower(FONE_CASA) like v_busca2
       or lower(FONE_CELULAR) like v_busca2
       or lower(FONE_TRABALHO) like v_busca2
       or lower(to_char(DATA_NASC)) like v_busca2
       or lower(E_MAIL) like v_busca2
       or lower(HOME_PAGE) like v_busca2
       or lower(OBS) like v_busca2
       UNION
       select id,nome,obs from pjuridicas 
       where lower(NOME) like v_busca2
       or lower(endereco) like v_busca2
       or lower(FONE) like v_busca2
       or lower(E_MAIL) like v_busca2
       or lower(HOME_PAGE) like v_busca2
       or lower(OBS) like v_busca2
       UNION
       select id,nome,obs from cidades 
       where lower(NOME) like v_busca2
       or lower(OBS) like v_busca2
       order by 2;    
    end if;
   htp.centeropen;
   htp.tableOpen(Cborder => 'border=2');
   htp.tablerowopen;
    htp.tableheader('Nome');
    htp.tableheader('Obs');
   htp.tableRowClose;
   loop
    -- faz o Fetch para as 2 variaveis
    fetch nome_cur into v_id,v_nome,v_obs;
    -- sai do loop quando acabarem as linhas da busca
    exit when nome_cur%notfound;
    -- exibe o resultado
    if v_cor=v_cor1
       then
        v_cor:=v_cor2;
       else
        v_cor:=v_cor1;
      end if;
     htp.tablerowopen(cattributes=>'BGCOLOR="'||v_cor||'"');
    if v_tipo=1 then
     htp.tableData(htf.anchor('apw.mostrar_pf?v_id='||v_id,v_nome),'CENTER');
     htp.tableData(nvl(v_obs,'-----------'),'CENTER');
     htp.tableRowClose;
    elsif v_tipo=2 then
     htp.tableData(htf.anchor('apw.mostrar_pj?v_id='||v_id,v_nome),'CENTER');
     htp.tableData(nvl(v_obs,'-----------'),'CENTER');
     htp.tableRowClose;
    elsif v_tipo=3 then
     htp.tableData(htf.anchor('apw.mostrar_cidade?v_id='||v_id,v_nome),'CENTER');
     htp.tableData(nvl(v_obs,'-----------'),'CENTER');
     htp.tableRowClose;
    else
     htp.tableData(v_nome,'CENTER');
     htp.tableData(nvl(v_obs,'-----------'),'CENTER');
     htp.tableRowClose;
    end if;
   end loop;  
   htp.tableclose;
   if nome_cur%rowcount=0
    then 
     htp.br;
     htp.center(htf.strong('Nenhum registro encontrado'));
   end if;
   close nome_cur;
  rodape;
     exception when others then erro;   
  end;  
      
    /*
    Algum Bug? Mande e-mail para oracle@trix.net
    */
    
end apw;
/
show err
prompt   =========================================
prompt            Fim da instalação 
prompt   =========================================
prompt       Coloque o seu servidor web no ar
prompt      (WebDB ou OAS) e chame o endereco:
prompt    http://seu-site/sua-aplicacao/apw.inicio
prompt   =========================================
