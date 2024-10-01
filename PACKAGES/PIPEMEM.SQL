REM **********************************************************
REM * Shows the penalty of inefficient management of VARCHAR2
REM * in PL/SQL tables by Oracle 7.2, 7.3.  The generic utility
REM * dbpipe.unpack_to_tbl suffers this penalty.
REM * (fixed in PL/SQL8)
REM **********************************************************

set serveroutput on size 100000

DECLARE
   null_msg_tbl dbpipe.message_tbltype;
   msg_tbl dbpipe.message_tbltype;
   call_stat  INTEGER;

BEGIN

   /* pack a message a number of items */
   FOR i in 1..50 
   LOOP
      DBMS_PIPE.PACK_MESSAGE('message number: '||TO_CHAR(i));
   END LOOP;
   
   /* send and receive the message */
   call_stat :=DBMS_PIPE.SEND_MESSAGE('PIPEX');
   call_stat :=DBMS_PIPE.RECEIVE_MESSAGE('PIPEX');

   /* use the generic unpack and show memory */
   dbpipe.unpack_to_tbl(msg_tbl,FALSE);
   my_session.memory;

   /* now free, release and show memory */
   msg_tbl := null_msg_tbl;
   DBMS_SESSION.FREE_UNUSED_USER_MEMORY;
   my_session.memory;

END;
/

