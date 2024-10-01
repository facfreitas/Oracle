SET ORACLE_SID=ALCM
SQLPLUS /NOLOG @SHUT.SQL

NET STOP OracleOraHome92Agent
NET STOP OracleOraHome92ManagementServer
net stop OracleServiceALCM
net stop OracleOraHome92TNSListener

EXIT