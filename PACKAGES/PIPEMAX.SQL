REM ****************************************************
REM * Script used to demonstrate that pipes can be very
REM * large in the SGA, not limited to 8K in size.
REM ****************************************************
set verify off
set serveroutput on size 100000

DECLARE
   pipename    VARCHAR2(100) := '&&pipename';
   msgsize     INTEGER := 1000;
   message     VARCHAR2(1000) := RPAD('message',msgsize);
   exec_stat   INTEGER;
   iterations  INTEGER :=0;

BEGIN
   DBMS_PIPE.RESET_BUFFER;
   exec_stat := DBMS_PIPE.CREATE_PIPE(pipename => '&&pipename'
                                     ,maxpipesize => &&maxpipesize
                                     ,private => TRUE);
   WHILE exec_stat = 0 
   LOOP
      DBMS_PIPE.PACK_MESSAGE(message);
      exec_stat := DBMS_PIPE.SEND_MESSAGE(pipename => '&&pipename'
                                         ,timeout => 1 );
      iterations := iterations +1;
   END LOOP;

   DBMS_OUTPUT.PUT_LINE('Exec stat: '||TO_CHAR(exec_stat)||
                        ', Total size: '||TO_CHAR((iterations-1)*msgsize) );

   exec_stat := DBMS_PIPE.REMOVE_PIPE('&&pipename');
END;
/

undefine pipename
undefine maxpipesize

