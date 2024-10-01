create or replace package PKG_RELATORIOS is

  -- Author  : ANDERSON MELO - ALMELO@TERRA.COM.BR
  -- Created : 09/06/03 15:12:31
  -- Purpose : GERA RELATÓRIOS COMPLETOS DO BANCO DE DADOS
  
  -- Public type declarations
  type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  <ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  <VariableName> <Datatype>;

  -- Public function and procedure declarations
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;

end PKG_RELATORIOS;
/
create or replace package body PKG_RELATORIOS is

/*
#################################################################
# SCRIPT QUE GERA RELATÓRIO COMPLETO SOBRE O BANCO DE DADOS     #
# AUTOR: ANDERSON MELO (ALMELO@TERRA.COM.BR)                    #
# CREATE: 10/02/2003                                            #
# ALTER : 09/06/2003                                            #
# VERSÃO : 3.1                                                  #
# SAIDA: GERA ARQUIVO HTML CONTENDO AS INFORMAÇÕES DO BANCO     #
#################################################################
# INSTRUÇÕES DE USO DO UTL_FILE:                                # 
#								#
# 1- CRIAR UM USUÁRIO DE BANCO QUAQUER                          #
# 2- ASSOCIAR ELE AO GRUPO ORA_DBA E ADMINISTRATOR(OPCIONAL)    #
# 3- ALTERAR O START DO BANCO E DO LISTENER PARA ESTE USUARIO   #
# 4- EDITAR O INIT DO BANCO, ADICIONANDO O PARAMETRO            #
#    UTL_FILE_DIR=* (ACESSO A TODAS PASTAS)                     #
# 5- CRIAR AS PASTAS NO SERVIDOR QUE ELE DEVERÁ TER ACESSO      #
# 6- ATRIBUIR PERMISSÕES DE R/W PARA ESTE USER NESTAS           #
#    PASTAS(COMPARTILHAMENTO)                                   #
#################################################################
*/ 

  -- Private type declarations
  type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  <ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  <VariableName> <Datatype>;

  -- Function and procedure implementations
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
    <LocalVariable> <Datatype>;
  begin
    <Statement>;
    return(<Result>);
  end;

begin
  -- Initialization
  <Statement>;
end PKG_RELATORIOS;
/
