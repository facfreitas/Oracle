select sid,serial#,username,trunc

(last_call_et/3600,2)||' hr' 

last_call_et 

from V$session where

last_call_et > 3600 and username is not null


/*
Note : last_call_et is in seconds .You can give where clause accordingly.

Ex : for 2hrs:7200 etc.

Once identified ,if you want to kill those session ,
you can use this command:


alter system kill session '<sid>,<serial#>';
*/