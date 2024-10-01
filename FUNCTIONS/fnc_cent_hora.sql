CREATE OR REPLACE FUNCTION FNC_CENTSEG_HORA( pCENTESIMO NUMBER ) RETURN VARCHAR2 IS

   cHora VARCHAR2( 15 ) := NULL;
   cMin  VARCHAR2( 15 ) := NULL;
   cSeg  VARCHAR2( 15 ) := NULL;
   cCent VARCHAR2( 15 ) := NULL;
   
BEGIN
   cHora := TO_CHAR( TRUNC( pCENTESIMO / 360000 ), '00' );
   cMin  := TO_CHAR( TRUNC( MOD( pCENTESIMO / 360000, 1 ) * 60 ), '00' );
   cSeg  := TO_CHAR( TRUNC( MOD( ( pCENTESIMO / 360000 ) * 60 , 1 ) * 60 ), '00' );
   cCent := TO_CHAR( MOD( ( MOD( ( pCENTESIMO / 360000 ) * 60 , 1 ) * 60 ), 1 ) * 100, '00' );
   
   
   RETURN( LTRIM ( RTRIM ( cHora ) ) || ':' || 
           LTRIM ( RTRIM ( cMin  ) ) || ':' || 
           LTRIM ( RTRIM ( cSeg  ) ) || ':' || 
           LTRIM ( RTRIM ( cCent ) ) );
END;
/
