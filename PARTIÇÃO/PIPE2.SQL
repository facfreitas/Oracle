set serveroutput on size 100000

spool pipe2.log

DECLARE
   test_pipename  VARCHAR2(30):='OPBIP_TEST_PIPE2';
   call_status    INTEGER;
   message1_out   VARCHAR2(2000);
   message2_out   VARCHAR2(2000);

BEGIN
   DBMS_PIPE.RESET_BUFFER;
   
   /* make sure pipe is empty */
   call_status := DBMS_PIPE.CREATE_PIPE(test_pipename);
   DBMS_PIPE.PURGE(test_pipename);

   /* pack and send first message  */
   DBMS_PIPE.PACK_MESSAGE('This is message one');
   call_status := DBMS_PIPE.SEND_MESSAGE(test_pipename);
   DBMS_OUTPUT.PUT_LINE('call status send1: '||TO_CHAR(call_status));

   /* now pack second message without sending  */
   DBMS_PIPE.PACK_MESSAGE('This is message two');

   /* receive, unpack and print message */
   call_status := DBMS_PIPE.RECEIVE_MESSAGE(test_pipename);
   DBMS_OUTPUT.PUT_LINE('call status receive1: '||TO_CHAR(call_status));
   DBMS_PIPE.UNPACK_MESSAGE(message1_out);
   DBMS_OUTPUT.PUT_LINE('message unpacked: '||message1_out);

   /* now send message two...is it still there?  */
   call_status := DBMS_PIPE.SEND_MESSAGE(test_pipename);
   DBMS_OUTPUT.PUT_LINE('call status send2: '||TO_CHAR(call_status));

   /* receive, unpack and print message */
   call_status := DBMS_PIPE.RECEIVE_MESSAGE(test_pipename);
   DBMS_OUTPUT.PUT_LINE('call status receive2: '||TO_CHAR(call_status));
   DBMS_PIPE.UNPACK_MESSAGE(message2_out);
   DBMS_OUTPUT.PUT_LINE('message unpacked: '||message2_out);
END;
/

spool off

