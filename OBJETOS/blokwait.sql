doc

    Name:    blokwait.sql

    Author:  Mark Gurry

    This script shows the number of waits for a single block. This can be
    caused by many people trying to insert into the same table at the same
    time when you have set freelists to 1. It can also be caused by many
    updates on the same block at the same time or a combination of inserts
    and updates. There are many other causes as mentioned in Chapter 11.

#

ttitle 'Data Block and Free List Waits'

select class, count
  from v$waitstat
where class in ( ‘data block’,  ‘free list’);