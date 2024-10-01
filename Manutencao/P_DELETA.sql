-- "Set scan off" turns off substitution variables. 
Set scan off; 

CREATE OR REPLACE PROCEDURE LOGWATCH.p_deleta
IS
-----------------------------------------------------------------------------------------------------------------
-- Empresa:        Sysdesign
-- Desenvolvedor:  Antonio Sant'Ana
-- Data:           14/06/2004
-- Objetivo:       Comandos de delec?o
-----------------------------------------------------------------------------------------------------------------
-- Historico de Atualizac?es
-- Data         Empresa     Implementador      Descric?o da Alterac?o
-- 01/11/2005	Sysdesign	Fernando		   Alterac?o da janela de delec?o dos log's para 30 dias
------------------------------------------------------------------------------------------------------------------
BEGIN
DELETE LOGFTP WHERE DATETIME < TRUNC(SYSDATE-30);
COMMIT;
DELETE LOGFTP_SESSION WHERE DATETIME < TRUNC(SYSDATE-30);
COMMIT;
DELETE LOGIMPORT WHERE DATETIME < TRUNC(SYSDATE-30);
COMMIT;
DELETE LOGNTAPP WHERE DATETIME < TRUNC(SYSDATE-30);
COMMIT;
DELETE LOGNTSEC WHERE DATETIME < TRUNC(SYSDATE-30);
COMMIT;
DELETE LOGNTSYS WHERE DATETIME < TRUNC(SYSDATE-30);
COMMIT;
DELETE LOGADM WHERE DATETIME < TRUNC(SYSDATE-30);
COMMIT;
DELETE LOGPROXY WHERE DATETIME < TRUNC(SYSDATE-30);
COMMIT;
DELETE LOGSYSLOG WHERE DATETIME < TRUNC(SYSDATE-30);
COMMIT;
DELETE LOGWEB WHERE DATETIME < TRUNC(SYSDATE-30);
COMMIT;
DELETE TEVENTLOG WHERE DATETIME < TRUNC(SYSDATE-30);
COMMIT;
DELETE LOGFW WHERE DATETIME < TRUNC(SYSDATE-30);
COMMIT;

END P_Deleta;
/


