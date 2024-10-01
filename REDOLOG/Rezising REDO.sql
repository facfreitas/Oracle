alter system switch logfile; -- Comutando arquivo de log

alter system archive log current; -- Arquivando o log

alter database drop logfile group 4; -- Removendo o grupo inteiro de redo

ALTER DATABASE ADD LOGFILE GROUP 3
('S:\ORACLE\SCA\REDO\REDO04_A.LOG','T:\ORACLE\SCA\REDO\REDO04_B.LOG') SIZE 10 m;

-- *************************************************************************** --

-- RAC EXEMPLE
--Add logfile groups for node 1 :(THREAD 1)
ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 5 ('+DG_DATA02','+DG_FRA') SIZE 1G;
ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 6 ('+DG_DATA02','+DG_FRA') SIZE 1G;

--Add logfile groups for node 2 : (THREAD 2)
ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 7 ('+DG_DATA02','+DG_FRA') SIZE 1G;
ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 8 ('+DG_DATA02','+DG_FRA') SIZE 1G;

+DG_DATA/crp01/onlinelog/group_1.256.852894621
+DG_FRA/crp01/onlinelog/group_1.262.852894621