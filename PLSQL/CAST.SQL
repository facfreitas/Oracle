DROP TYPE address_t FORCE;
 
CREATE TYPE address_t AS OBJECT 
   (street VARCHAR2(100), city VARCHAR2(100));
/       
CREATE TYPE address_book_t AS TABLE OF address_t; 
/
CREATE TYPE address_array_t AS VARRAY(3) OF address_t; 
/
DROP TABLE addresses;
CREATE TABLE addresses OF address_t;

INSERT INTO addresses VALUES (
    address_t('19th St', 'St. Louis')); 
INSERT INTO addresses VALUES (
    address_t('Biglanes Blvd', 'Dallas'));
INSERT INTO addresses VALUES (
    address_t('Upanddown Lane', 'San Francisco'));
   
@ssoo
DECLARE
   addr_varray address_array_t;
   
   addr_ntable address_book_t := 
      address_book_t (
         address_t('Madison Ave', 'Chicago'), 
         address_t('Devon Ave', 'Chicago'));

   PROCEDURE disphdr (str IN VARCHAR2)
   IS BEGIN
      DBMS_OUTPUT.NEW_LINE;
      DBMS_OUTPUT.PUT_LINE (str);
   END;      
BEGIN
   disphdr ('Casting in PL/SQL for Scalar Datatypes:');
   -- CAST for TO_DATE...no way to pass format mask.
   DBMS_OUTPUT.PUT_LINE (
      CAST ('10-JAN-99' AS DATE));
   
   -- CAST as TO_NUMBER...no way to pass format mask.   
   DBMS_OUTPUT.PUT_LINE (
      CAST ('107898888' AS NUMBER));
      
   -- Cannot call CAST directly in PL/SQL for collections...
   -- addr_varray := CAST (addr_ntable AS address_array_t);
   
   SELECT CAST (addr_ntable AS address_array_t)
     INTO addr_varray
     FROM dual;
     
   disphdr ('Count in VArray Casted from Nested Table:');

   DBMS_OUTPUT.PUT_LINE (
      addr_varray.COUNT || 
      ' rows in VArray.');
      
   SELECT CAST (MULTISET (
             SELECT street, city
               FROM addresses p
              ORDER BY city) 
       AS address_array_t)
     INTO addr_varray
     FROM dual;
 
   disphdr ('Contents of VArray Populated from Subquery:');

   FOR indx IN 
      addr_varray.FIRST .. addr_varray.LAST
   LOOP
      DBMS_OUTPUT.PUT_LINE (addr_varray(indx).city);
   END LOOP;
      
END;
/ 

REM You can do this:

SELECT CAST (ROWID AS VARCHAR2(20)) Vrowid FROM department;

REM But you cannot do this:

DECLARE
   my_rowid VARCHAR2(20);
BEGIN
   FOR rec IN (
      SELECT CAST (ROWID AS VARCHAR2(20)) Vrowid 
        FROM department)
   LOOP
      DBMS_OUTPUT.PUT_LINE (rec.Vrowid);
   END LOOP;
END;
/ 

