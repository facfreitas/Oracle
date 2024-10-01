CREATE SEQUENCE sys.AUD_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

create table SYS.AUDIT_TABLE (
                            ID              NUMBER(20),
                            LOGIN           VARCHAR2(30),
                            SCHEMA_NAME     VARCHAR2(30),
                            PROGRAM_NAME    VARCHAR2(100),
                            DB_NAME         VARCHAR2(100),                            
                            USER_MACHINE    VARCHAR2(100),
                            CREATEDDATE     DATE
                           )
                           
CREATE OR REPLACE TRIGGER SYS.TR_AFTER_LOGON
 after logon on database
DECLARE
   -- variáveis de auditoria da v$session
   auBDLogin       VARCHAR2 (30);
   auBDSid         NUMBER;
   auBDSerial      NUMBER;
   auDSSidSerial   VARCHAR2 (64);
   auDSPrograma    VARCHAR2 (64);
   auOSUser        VARCHAR2 (64);
   auDSMachine     VARCHAR2 (64);
   auBDName        VARCHAR2 (64);
   auBDInstance    VARCHAR (32);
   
BEGIN
   SELECT UserName,
          Sid,
          Serial#,
          TRIM (Program),
          OSUSER,
          MACHINE
     INTO auBDLogin,
          auBDSid,
          auBDSerial,
          auDSPrograma,
          auOSUser,
          auDSMachine
     FROM v$session
    WHERE     AUDSID =
                 (SELECT DISTINCT (USERENV ('SESSIONID')) FROM V$SESSION)
          AND SID IN (SELECT MAX (SID)
                        FROM V$SESSION
                       WHERE AUDSID = USERENV ('SESSIONID'));
 
   IF     SUBSTR (auBDLogin, 1, 4) in ('EPCC','EEP_','WCAD','PRIV') AND
   UPPER(auDSPrograma) not in ('OSEAPP.EXE','PM.EXE','OSEAPPB.EXE','WFFOLHAAPROPRIACAO.EXE') AND
   UPPER(auDSPrograma) not like ('ORAAGENT%') AND
   UPPER(auDSMachine) not in ('WINDCHILL','LCHLRAC01.EEPSA.COM.BR','LCHLRAC02.EEPSA.COM.BR')
 
   THEN
      SELECT UPPER (instance_name) INTO auBDInstance FROM v$instance;
      
        INSERT INTO SYS.AUDIT_TABLE (
                                    ID, 
                                    LOGIN, 
                                    SCHEMA_NAME, 
                                    PROGRAM_NAME,
                                    DB_NAME, 
                                    USER_MACHINE, 
                                    CREATEDDATE) 
            VALUES (AUD_SEQ.nextval,auOSUser,auBDLogin,auDSPrograma, auBDInstance, auDSMachine,SYSDATE);
            COMMIT;
 
      EEP_CORE.PKG_MAIL.upEnviarEmail (
         'Acesso a Banco ou Aplicação ',
            auBDLogin
         || ' tentou logar na base '
         || TRIM (auBDInstance)
         || ' com o programa '
         || auDSPrograma
         || ' em '
         || TO_CHAR (SYSDATE, 'dd/mm/yyyy hh24:mi:ss')
         || ' Usuário '
         || auOSUser
         || '  Micro: '
         || auDSMachine,
         'fernando.freitas@eepsa.com.br',
         'TR_AFTER_LOGON');
 
    --  EXECUTE IMMEDIATE auDSSidSerial;
   END IF;
END;
/
