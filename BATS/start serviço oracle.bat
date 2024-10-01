SET ORACLE_SID=ALCM
NET START OracleOraHome92TNSListener
NET START OracleOraHome92Agent
NET START OracleOraHome92ManagementServer
net start OracleServiceALCM

SQLPLUS /NOLOG @STARTUP.SQL
EXIT
EXIT