-- Remove o serviço
ORADIM -delete -sid TESTE01hml -SRVC OracleServiceTESTE01HML

-- Cria o serviço
ORADIM -new -sid TESTE01HML -intpwd cpsdba -startmode auto -pfile E:\Oracle\teste01hml\pfile\initteste01.ora

-- ALTERANDO O SID DO BANCO
sqlplus /nolog @E:\Oracle\scripts\create_control_teste01hml.sql

-- OPEN RESETLOGS do BD
sqlplus /nolog @E:\Oracle\scripts\stop.sql


exit



