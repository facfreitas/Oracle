*******************************************************************************
-- Author :- Nitin Patel *
-- Date :- 03rd September, 2002 *
-- Purpose :- Auto Email From Oracle Database. 

-- *******************************************************************************
create or replace PROCEDURE send_mail
( sender IN VARCHAR2,
recipient IN VARCHAR2,
subject IN VARCHAR2,
message IN VARCHAR2)
IS
mailhost VARCHAR2(30) := '192.168.100.10';
mail_conn utl_smtp.connection;
crlf VARCHAR2( 2 ):= CHR( 13 ) || CHR( 10 );
mesg VARCHAR2( 1000 );

BEGIN
mail_conn := utl_smtp.open_connection(mailhost, 25);

mesg:= 'Date: ' || TO_CHAR( SYSDATE, 'dd Mon yy hh24:mi:ss' ) || crlf
||
'From: <'||sender||'>' || crlf ||
'Subject: '||subject || crlf ||
'To: '||recipient || crlf ||
'Your query has been complete
d. The output can be viewed below. '||crlf||
'MIME-Version: 1.0'||crlf|| message;

utl_smtp.helo(mail_conn, mailhost);
utl_smtp.mail(mail_conn, sender);
utl_smtp.rcpt(mail_conn, recipient);
utl_smtp.data(mail_conn, mesg);
utl_smtp.quit(mail_conn);

Exception
WHEN OTHERS THEN
raise_application_error(-20002,'unable to send the mail.'||SQLERRM);
END;