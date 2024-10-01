-- Opcoes do ANALYZE --> COMPUTE
                     --> ESTIMATE
			   --> DELETE
                     
-- Executar logado como usuário SYS

BEGIN DBMS_UTILITY.analyze_schema('<OWNER>','<OPCAO>'); END;

BEGIN DBMS_UTILITY.analyze_database('COMPUTE'); END;

