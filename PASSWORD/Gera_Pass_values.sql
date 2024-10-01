select * from user$
where type# = 1
and spare4 is not null
order by name

SELECT 'ALTER USER ' || name || ' identified by values '''|| password || ''';'FROM user$
where type# = 1
and spare4 is not null
order by name