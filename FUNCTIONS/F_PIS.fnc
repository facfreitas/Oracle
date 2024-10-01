CREATE OR REPLACE FUNCTION CLB239950.F_PIS (DADO IN NUMBER)
 RETURN VARCHAR2 IS
 WSOMA   INTEGER;
 WM11    INTEGER;
 WDV     INTEGER;
 WDIGITO INTEGER;
 I       INTEGER :=0;

/* PARA TESTAR:
      SELECT F_PIS(12131780311) FROM DUAL */

BEGIN
     WDV := SUBSTR(DADO,11,1);
     WSOMA := 0;
     WM11 := 2;
 WHILE I <  10 LOOP
       I:=I+1;
       WSOMA := WSOMA + (WM11 * SUBSTR(DADO,11 - I, 1));
      IF WM11 < 9 THEN
          WM11 := WM11+1;
      ELSE
          WM11 := 2;
      END IF;
           WDIGITO := 11 - (WSOMA MOD 11);
      IF WDIGITO > 9 THEN
         WDIGITO := 0;
      END IF;
 END LOOP;
      IF WDV = WDIGITO THEN
         RETURN('TRUE');
      ELSE
         RETURN('FALSE');
      END IF;
END F_PIS;
/
