INSERT INTO UA2
   (
      ID, 
      DESCR 
   )
select replace (id, '.', ''), descr from ua


INSERT INTO UA_INHAUMA2
   (
      ID, 
      DESCR 
   )
select replace (id, 'CONV', ''), descr from UA_INHAUMA