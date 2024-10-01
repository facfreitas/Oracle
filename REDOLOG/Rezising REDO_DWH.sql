--GRUPO 1

alter system switch logfile; -- Comutando arquivo de log

alter database drop logfile group 1; -- Removendo o grupo inteiro de redo

alter database add logfile group 1 'N:\ORACLE\DWH\REDO\REDO01_A.ORA' size 200M; -- Acrescendo um grupo redo

alter database add logfile member 'M:\ORACLE\DWH\REDO\REDO01_B.ORA' to group 1; -- Para multiplexar redo

--GRUPO 2

alter system switch logfile; -- Comutando arquivo de log

alter database drop logfile group 2; -- Removendo o grupo inteiro de redo

alter database add logfile group 2 'N:\ORACLE\DWH\REDO\REDO02_A.ORA' size 200M; -- Acrescendo um grupo redo

alter database add logfile member 'M:\ORACLE\DWH\REDO\REDO02_B.ORA' to group 2; -- Para multiplexar redo

--GRUPO 3

alter system switch logfile; -- Comutando arquivo de log

alter database drop logfile group 3; -- Removendo o grupo inteiro de redo

alter database add logfile group 3 'N:\ORACLE\DWH\REDO\REDO03_A.ORA' size 200M; -- Acrescendo um grupo redo

alter database add logfile member 'M:\ORACLE\DWH\REDO\REDO03_B.ORA' to group 3; -- Para multiplexar redo

--GRUPO 4

alter system switch logfile; -- Comutando arquivo de log

alter database drop logfile group 4; -- Removendo o grupo inteiro de redo

alter database add logfile group 4 'N:\ORACLE\DWH\REDO\REDO04_A.ORA' size 200M; -- Acrescendo um grupo redo

alter database add logfile member 'M:\ORACLE\DWH\REDO\REDO04_B.ORA' to group 4; -- Para multiplexar redo

--GRUPO 5

alter system switch logfile; -- Comutando arquivo de log

alter database drop logfile group 5; -- Removendo o grupo inteiro de redo

alter database add logfile group 5 'N:\ORACLE\DWH\REDO\REDO05_A.ORA' size 200M; -- Acrescendo um grupo redo

alter database add logfile member 'M:\ORACLE\DWH\REDO\REDO05_B.ORA' to group 5; -- Para multiplexar redo

