CREATE OR REPLACE FUNCTION CLB239950.F_DIF_HORA  ( DT_INI IN DATE,
                     	   						   DT_FIN IN DATE ) 
RETURN VARCHAR2 IS

-- *************************************************************************
-- * FUNCAO: FUNÇãO PARA RETORNAR A DIFERENçA ENTRE DATAS NO FORMATO HORA  *
-- * AUTOR.: ANDERSON MELO - ALMELO@COELBA.COM.BR 		                   *
-- * DATA..: 10/01/2002                                                    *
-- *************************************************************************

   VS_HORA VARCHAR2(20);
   VN_DIF  NUMBER;
   VN_INT  NUMBER;
   VN_DEC  NUMBER;
   VN_HORA NUMBER;
   VN_MINUTO NUMBER;

BEGIN

   VN_DIF := (TRUNC((DT_FIN - DT_INI),8)*24)*60   ;
   VN_INT := TRUNC(VN_DIF,0);
   VN_DEC := TRUNC(VN_DIF - VN_INT)*60;

   IF VN_INT > 60 THEN
      VN_HORA   := VN_INT / 60;
      VN_INT    := TRUNC(VN_HORA,0);
      VN_MINUTO := TRUNC(VN_HORA - VN_INT)*60;
      VS_HORA := TO_CHAR(TRUNC(VN_HORA))||':'||LPAD(VN_MINUTO,2,'0');
   ELSE
      VS_HORA := '00:'||LPAD(VN_INT,2,'0');
   END IF   ;
   RETURN (VS_HORA);
END F_DIF_HORA;
/
