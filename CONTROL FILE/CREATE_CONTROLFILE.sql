STARTUP NOMOUNT
CREATE CONTROLFILE REUSE DATABASE "ORCL" RESETLOGS  NOARCHIVELOG
    MAXLOGFILES 16
    MAXLOGMEMBERS 3
    MAXDATAFILES 100
    MAXINSTANCES 8
    MAXLOGHISTORY 584
LOGFILE
  GROUP 1 'R:\99_DATA\ORACLE\ORADATA\ORCL\REDO01.LOG'  SIZE 50M BLOCKSIZE 512,
  GROUP 2 'R:\99_DATA\ORACLE\ORADATA\ORCL\REDO02.LOG'  SIZE 50M BLOCKSIZE 512,
  GROUP 3 'R:\99_DATA\ORACLE\ORADATA\ORCL\REDO03.LOG'  SIZE 50M BLOCKSIZE 512
-- STANDBY LOGFILE
DATAFILE
  'R:\99_DATA\ORACLE\ORADATA\ORCL\SYSTEM01.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\SYSAUX01.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\USERS01.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_1.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\SMART_LAUNDRY.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_2.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_3.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_4.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_5.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_6.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_7.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_8.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_9.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_10.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_11.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_12.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_13.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_14.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_15.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_16.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_17.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_18.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_19.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_20.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_21.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_22.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_23.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_24.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_25.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_26.DBF',
  'R:\99_DATA\ORACLE\ORADATA\ORCL\FLOW_27.DBF'
CHARACTER SET WE8MSWIN1252
;
