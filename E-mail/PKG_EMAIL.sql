create or replace
PACKAGE BODY PKG_EMAIL AS
/******************************************************************************************/
  PROCEDURE PRC_SEND_MAIL(P_MESSAGE IN VARCHAR2, P_SUBJECT IN VARCHAR2, P_SENDER IN VARCHAR2, P_LINK IN VARCHAR2, P_TO IN VARCHAR2, P_CC IN VARCHAR2, P_FROM IN VARCHAR2) AS
  V_MESSAGE_TEMPLATE varchar2(32000) := '<html><head><style type="text/css"><!--body {font-family: Arial, Helvetica, sans-serif;font-size: 10px;font-style: normal;font-weight: normal;margin: 0px;}a {color: #5D5D5D;}.header, .titleArea, .content, .footer {width: 600px;border: 0;border-collapse:collapse;background-color: #EFEAE1;color: #5D5D5D;margin: 0 auto;}.header td {background-color: #212121;border: 1px solid #212121;text-align: left;font-size:11px;}.header img.logo {padding: 10px;}.titleArea td {background-color: #750303;height: 26px;color:#FFFFFF;font-weight:bold;border-left: 1px solid #750303;border-right: 1px solid #750303;font-size:12px;}.tblDate img {margin-right: 8px;}.content {border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;background-color:#f3f3f1;padding: 20px;font-size:12px;}.tblDate {width: 100%;border-collapse:collapse;color: #5D5D5D;}.tblDate td {padding: 15px;font-size:12px;height: 15px}.footer td {border: 1px solid #CCCCCC;height: 20px;background-color: #ededed;font-size: 11px;}--></style></head><body><table class="header"><tr><td width="359" rowspan="2"><div align="left"><img class="logo" src="http://kmeae00006454.corp.kbr.com:8080/i/themes/KBRApex/KBRLogo.gif" width="145" height="50"></div></td><td width="229">Sent by: #Created_By#</td></tr><tr><td style="vertical-align:top;">Date of creation: #Created_Date#</td></tr></table><table class="titleArea"><tr><td><span>&nbsp;&nbsp;&nbsp;#Title#</span></td></tr></table><table class="content"><tr><td><table class="tblDate"><tr><td colspan="2"><p>#Name#<br>#Message#</p></td></tr></table></td></tr></table><table class="footer"><tr><td width="515">&nbsp;&nbsp;&nbsp;Please do not respond to this email</td><td width="73" style="text-align:center;">&nbsp;&nbsp;<a href="#login#">Login</a></td></tr></table></body></html>';
  message varchar2(32000) := '';
 
  BEGIN
   
    message := replace(V_MESSAGE_TEMPLATE,'#Message#', P_MESSAGE);
    message := replace(message,'#Created_By#', P_SENDER);
    message := replace(message,'#Created_Date#', to_char(sysdate,'DD-MON-YYYY HH24:MI:SS'));
    message := replace(message,'#Title#', P_SUBJECT);
    message := replace(message,'#Name#', 'Dear User,<br>');
    message := replace(message,'#login#', P_LINK);
   
    APEX_MAIL.SEND
    (
    P_TO            => P_TO,
    P_CC            => P_CC ,
    P_FROM          => P_FROM,
    P_BODY          => 'Your email client is not compatible with HTML format, please contact your Local IPS Department',
    P_BODY_HTML     =>  message,
    P_SUBJ          => P_SUBJECT
    );
   
    APEX_MAIL.PUSH_QUEUE;
  END PRC_SEND_MAIL;
/******************************************************************************************/
  FUNCTION FUNC_FILTER_MAIL(P_EMAILS IN VARCHAR2) RETURN VARCHAR2 AS
    N_PIECES NUMBER := 0;
    S_EMAILS VARCHAR2(1000) := TRIM(P_EMAILS);
    S_EMAIL VARCHAR2(1000) := '';
    S_RET_EMAILS VARCHAR2(1000) := '';
    BEGIN
    S_EMAILS := REPLACE(S_EMAILS,',', ';');
    N_PIECES := CORE.PKG_TOOLS.FUNC_OCCOURRENCES(S_EMAILS,';') + 1;
    FOR X IN 1..N_PIECES LOOP
      S_EMAIL := CORE.PKG_TOOLS.FUNC_PIECE(S_EMAILS,X,';');
        --IF CORE.PKG_TOOLS.FUNC_OCCOURRENCES(UPPER(S_EMAIL),'KBR.COM') != 0 THEN --RL 23/MAR/2011: OPS requested to open the email comunication to any external email.
        IF 1=1 THEN
          S_RET_EMAILS := S_RET_EMAILS ||';'|| TRIM(S_EMAIL);
        END IF;
    END LOOP;
    RETURN SUBSTR(S_RET_EMAILS,2);
  END FUNC_FILTER_MAIL;
END PKG_EMAIL;
/******************************************************************************************/
