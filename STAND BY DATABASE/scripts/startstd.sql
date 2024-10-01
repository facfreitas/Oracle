-- Iniciando a instância em modo NOMOUNT 
startup nomount;

-- Montando o Standby Database
alter database mount standby database;

-- Colocando o Standby em mode de Recover Managed
alter database recover managed standby database disconnect from session;

-- Verificando GAP de Archives
select thread#, low_sequence#, high_sequence# from v$archive_gap;



