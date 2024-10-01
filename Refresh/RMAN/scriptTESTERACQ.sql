create user teste identified by "teste"
default tablespace users
temporary tablespace temp;
grant connect, resource to teste;

CREATE TABLE teste.nova
(
  INFO     VARCHAR2(200 CHAR)
);


INSERT INTO teste.nova
     VALUES ('O REFRESH PASSOU POR AQUI');
     COMMIT;

exit;
