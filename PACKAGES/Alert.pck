create or replace package Alert as

  -- Author  : ANDERSON MELO
  -- Created : 02/02/2004 17:12:14
  -- Purpose : Pacote para ler o alerta do banco e informar as linhas com erro do dia
  
FUNCTION PodeLer (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.PodeLer(java.lang.String) return java.lang.int';
	
FUNCTION PodeEscrever (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.PodeEscrever(java.lang.String) return java.lang.int';	

FUNCTION CriarNovoArquivo (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.CriarNovoArquivo(java.lang.String) return java.lang.int';	

FUNCTION Deletar (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.Deletar(java.lang.String) return java.lang.int';

FUNCTION PegarTamanho (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.PegarTamanho(java.lang.String) return java.lang.int';

FUNCTION Renomear (p_path1 IN VARCHAR2,p_path2 IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.Renomear(java.lang.String,java.lang.String) return java.lang.int';

FUNCTION Exite (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.Existe(java.lang.String) return java.lang.int';

FUNCTION Diretorio (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.Diretorio(java.lang.String) return java.lang.int';

FUNCTION Arquivo (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.Arquivo(java.lang.String) return java.lang.int';

FUNCTION Oculto (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.Oculto(java.lang.String) return java.lang.int';

FUNCTION DataModificado (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.DataModificado(java.lang.String) return java.lang.int';

FUNCTION ListaArquivos (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.ListaArquivos(java.lang.String) return java.lang.int';

FUNCTION CriarDiretorio (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.CriarDiretorio(java.lang.String) return java.lang.int';

FUNCTION SomenteLeitura (p_path IN VARCHAR2) RETURN NUMBER AS 
LANGUAGE JAVA NAME 'p_ler_alert.SomenteLeitura(java.lang.String) return java.lang.int';



end Alert;
/
create or replace package body Alert is


begin

end Alert;
/
