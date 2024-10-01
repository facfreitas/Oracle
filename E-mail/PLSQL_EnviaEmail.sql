Declare
SendorAddress varchar2(30) := 'teste@enseada.com';
ReceiverAddress varchar2(30) := 'fernando.freitas@enseada.com';
EmailServer varchar2(255) := 'enseada-com.mail.protection.outlook.com';
Port number := 25;
conn UTL_SMTP.CONNECTION;
crlf VARCHAR2(2):= CHR(13) || CHR(10);
mesg VARCHAR2(4000);
BEGIN
conn:= utl_smtp.open_connection(EmailServer,Port);
utl_smtp.helo(conn,EmailServer);
utl_smtp.mail(conn,SendorAddress);
utl_smtp.rcpt(conn,ReceiverAddress);
mesg:=
'From:'||SendorAddress|| crlf ||
'Subject: Teste de e-mail enviado pelo Servidor Oracle' || crlf ||
'To: '||ReceiverAddress || crlf ||
'' || crlf ||
'Este é um e-mail de teste!';
utl_smtp.data(conn,mesg);
utl_smtp.quit(conn);
END;
/
