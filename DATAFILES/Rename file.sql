ALTER DATABASE RENAME FILE 'K:\DWH\ORADATA\SYSTEM01.DBF' TO 'N:\ORACLE\DWH\DATA\SYSTEM';
ALTER DATABASE RENAME FILE 'K:\DWH\ORADATA\UNDOTBS01.DBF' TO 'N:\ORACLE\DWH\DATA\UNDOTBS01.DBF';
ALTER DATABASE RENAME FILE 'K:\DWH\ORADATA\USERS01.DBF' TO 'N:\ORACLE\DWH\DATA\USERS01.dbf';




'ALTERDATABASERENAMEFILE'''||MEMBER||'''TO'||'''N:\ORACLE\DWH\DATA\REDO'||SUBSTR(MEMBER,12,15)||''';'
alter database rename file 'K:\DWH\REDO\REDO01_A.ORA' to 'N:\Oracle\DWH\redo\REDO01_A.ORA';
alter database rename file 'K:\DWH\REDO\REDO02_A.ORA' to 'N:\Oracle\DWH\redo\REDO02_A.ORA';
alter database rename file 'K:\DWH\REDO\REDO03_A.ORA' to 'N:\Oracle\DWH\redo\REDO03_A.ORA';
alter database rename file 'K:\DWH\REDO\REDO04_A.ORA' to 'N:\Oracle\DWH\redo\REDO04_A.ORA';
alter database rename file 'K:\DWH\REDO\REDO04_B.ORA' to 'N:\Oracle\DWH\redo\REDO04_B.ORA';
alter database rename file 'K:\DWH\REDO\REDO01_B.ORA' to 'N:\Oracle\DWH\redo\REDO01_B.ORA';
alter database rename file 'K:\DWH\REDO\REDO02_B.ORA' to 'N:\Oracle\DWH\redo\REDO02_B.ORA';
alter database rename file 'K:\DWH\REDO\REDO05_A.ORA' to 'N:\Oracle\DWH\redo\REDO05_A.ORA';
alter database rename file 'K:\DWH\REDO\REDO05_B.ORA' to 'N:\Oracle\DWH\redo\REDO05_B.ORA';
alter database rename file 'K:\DWH\REDO\REDO03_B.ORA' to 'N:\Oracle\DWH\redo\REDO03_B.ORA';


alter database rename file 'N:\Oracle\DWH\redo\REDO01_B.ORA' to 'M:\Oracle\DWH\redoB\REDO01_B.ORA';
alter database rename file 'N:\Oracle\DWH\redo\REDO02_B.ORA' to 'M:\Oracle\DWH\redoB\REDO02_B.ORA';
alter database rename file 'N:\Oracle\DWH\redo\REDO03_B.ORA' to 'M:\Oracle\DWH\redoB\REDO03_B.ORA';
alter database rename file 'N:\Oracle\DWH\redo\REDO04_B.ORA' to 'M:\Oracle\DWH\redoB\REDO04_B.ORA';
alter database rename file 'N:\Oracle\DWH\redo\REDO05_B.ORA' to 'M:\Oracle\DWH\redoB\REDO05_B.ORA';


cd \
M:
md Oracle
CD ORACLE
md DWH
cd DWH
md Archive
md Control
md Loader
md Data
md Export
md Redo
md Scripts
md Spfile
md Pfile
md Trace
cd Trace
md Bdump
md Cdump
md Udump
exit
