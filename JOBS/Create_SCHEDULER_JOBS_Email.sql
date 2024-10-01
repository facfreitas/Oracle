-- Cria o Scheduler Job para atualização de estatisticas do BD todo
BEGIN
   DBMS_SCHEDULER.create_job (
      job_name        => 'COLETA_ESTATISTICAS_BANCO',
      job_type        => 'PLSQL_BLOCK',
      job_action      => 'BEGIN DBMS_STATS.gather_database_stats; END;',
      start_date      => SYSTIMESTAMP,
      repeat_interval => 'FREQ=DAILY; BYDAY=SAT; BYHOUR=14; BYMINUTE=0; BYSECOND=0',
      enabled         => TRUE
   );
END;

-- Configura o atributo para o SMTP Server
exec dbms_scheduler.set_scheduler_attribute('email_server','10.145.196.95');

-- Seta o SMTP Server como parâmetro
alter system set smtp_out_server='10.145.196.95' scope=both sid='*';

-- Cria a notificação do job
BEGIN
  DBMS_SCHEDULER.ADD_JOB_EMAIL_NOTIFICATION (
    job_name    => 'COLETA_ESTATISTICAS_BANCO',
    recipients  => 'databasesupport@enseada.com',
    sender      => 'operacao@enseada.com',
    subject     => 'Job Notification - %job_owner%.%job_name% - %event_type% - Database: ' || SYS_CONTEXT('USERENV', 'DB_UNIQUE_NAME'),
    body        => '%event_type% occurred on %event_timestamp%. %error_message%',
    events      => 'JOB_FAILED, JOB_BROKEN, JOB_DISABLED, JOB_SCH_LIM_REACHED');
END;
/

-- Consulta
SELECT JOB_NAME, RECIPIENT, EVENT FROM DBA_SCHEDULER_NOTIFICATIONS;