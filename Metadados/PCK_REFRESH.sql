CREATE OR REPLACE PACKAGE DBAINFRA.pckAuxiliarRefreshBD AS

    /*Procedure GuardarUsuario;
    Procedure GuardarPapelUsuario;
    Procedure GuardarPrivilegioPapel;*/

    Procedure GuardarMetaDados;
    Procedure CriarMetaDados;

    Type rcCursor IS Ref Cursor;
End pckAuxiliarRefreshBD;
/

CREATE OR REPLACE PACKAGE BODY DBAINFRA.pckAuxiliarRefreshBD AS
     lDsServidor Varchar2(50) := '\\Carmo';
     lDsCaminho Varchar2(50) := '\g$\admin\SATHML\script\';
     Procedure GuardarUsuario as
             loUsuarios Clob;
             UserCur    rcCursor;
             lDsUsuario Varchar2(50);
             lDsSenha   Varchar2(50);
             lCount     Integer := 0 ;
            Begin 
                       OPEN UserCur FOR 'SELECT username, password
                                            FROM    sys.dba_users
                                            where   USERNAME not like  ''DBA%''
                                            and     USERNAME not like  ''USS%''
                                            and     ACCOUNT_STATUS = ''OPEN''
                                            and     DEFAULT_TABLESPACE <>  ''SYSTEM''
                                            and     USERNAME not like ''SAT_''
                                            and     USERNAME not like ''AUD_''
                                            and     USERNAME <> ''SASMASTER''
                                            ORDER BY 1';
                       loUsuarios := ''; 
                       LOOP
                            FETCH UserCur into lDsUsuario, lDsSenha;
                            EXIT WHEN UserCur%NOTFOUND;
                            loUsuarios := loUsuarios || lDsUsuario || ',' || lDsSenha  ||  CHR(10);
                       End Loop;
                       dbainfra.pckinfra.UPCLOBPARAARQUIVO('Usuario.Dat',loUsuarios,lDsServidor || lDsCaminho);
                       select count(1) into lCount 
                       from all_tables
                       Where table_Name = 'USUARIO'
                       And  Owner = 'DBAINFRA'; 
                       if lCount > 0 then
                            Execute Immediate 'DROP TABLE DBAINFRA.Usuario';
                       End if;
                       Execute Immediate '
                                CREATE TABLE DBAINFRA.Usuario 
                                (
                                    Usuario  Varchar2(50),
                                    Senha  Varchar2(50)
                                )
                                ORGANIZATION EXTERNAL 
                                (
                                    TYPE oracle_loader
                                    DEFAULT DIRECTORY USUARIOS_SCA
                                    ACCESS PARAMETERS 
                                    (
                                        RECORDS DELIMITED BY NEWLINE
                                        FIELDS TERMINATED BY '',''
                                        MISSING FIELD VALUES ARE NULL
                                        REJECT ROWS WITH ALL NULL FIELDS
                                        (Usuario,Senha)
                                    )
                                    LOCATION (''Usuario.Dat'')
                                )
                                PARALLEL
                                REJECT LIMIT 0';
         /*Exception 
                When Others Then
                        Raise ; */
    End GuardarUsuario;
    Procedure GuardarPapelUsuario As
            loUsuarios  Clob;
            UserCur     rcCursor;
            lDsUsuario  Varchar2(50);
            lDsPapel    Varchar2(50);
            lCount      Integer := 0 ;
          Begin 
                    OPEN UserCur FOR '  Select e.USUARIO,d.GRANTED_ROLE 
                                        from Dbainfra.Usuario e 
                                        inner join dba_role_privs d on GRANTEE = USUARIO';
                    loUsuarios := ''; 
                    LOOP
                            FETCH UserCur into lDsUsuario, lDsPapel;
                            EXIT WHEN UserCur%NOTFOUND;
                            loUsuarios := loUsuarios || lDsUsuario || ',' || lDsPapel  ||  CHR(10);
                    End Loop;
                   dbainfra.pckinfra.UPCLOBPARAARQUIVO('PapelUsuario.Dat',loUsuarios,lDsServidor || lDsCaminho);
                   select count(1) into lCount 
                   from all_tables
                   Where table_Name = 'PAPELUSUARIO'
                   And  Owner = 'DBAINFRA'; 
                   if lCount > 0 then
                         Execute Immediate 'Drop Table DBAINFRA.PapelUsuario';
                   End if;
                    Execute Immediate '
                        CREATE TABLE DBAINFRA.PapelUsuario 
                        (
                            DsLogin  Varchar2(50),
                            NmPapel  Varchar2(50))
                            ORGANIZATION EXTERNAL 
                            (
                                TYPE oracle_loader
                                DEFAULT DIRECTORY USUARIOS_SCA
                                ACCESS PARAMETERS (
                                RECORDS DELIMITED BY NEWLINE
                                FIELDS TERMINATED BY '',''
                                MISSING FIELD VALUES ARE NULL
                                REJECT ROWS WITH ALL NULL FIELDS
                                (DsLogin,NmPapel)
                            )
                            LOCATION (''PapelUsuario.Dat'')
                        )
                            PARALLEL
                            REJECT LIMIT 0';
        Exception 
                When Others Then
                        Raise ; 
    End GuardarPapelUsuario;
    Procedure GuardarPrivilegioPapel AS
         loPrivilegioPapel     Clob;
         curPrivPapel   rcCursor;
         lDsPapel       Varchar2(50);
         lDsOwner       Varchar2(50);
         lDsObjeto      Varchar2(50);
         lDsPrivilegio  Varchar2(50);
         lCount         Integer := 0 ;
          Begin 
                    OPEN curPrivPapel FOR 'Select distinct p.NmPapel,d.OWNER,d.TABLE_NAME,d.PRIVILEGE
                                            from DBAINFRA.PapelUsuario p 
                                            inner join dba_tab_privs d on d.GRANTEE = p.NmPapel';
                    loPrivilegioPapel := ''; 
                    Loop
                            FETCH curPrivPapel into lDsPapel, lDsOwner,lDsObjeto,lDsPrivilegio;
                            EXIT WHEN curPrivPapel%NOTFOUND;
                            loPrivilegioPapel := loPrivilegioPapel || lDsPapel || ',' || lDsOwner  || ',' || lDsObjeto || ',' || lDsPrivilegio || CHR(10);
                    End Loop;
                    dbainfra.pckinfra.UPCLOBPARAARQUIVO('PrivilegioPapel.Dat',loPrivilegioPapel,lDsServidor || lDsCaminho);
                    select count(1) into lCount 
                    from all_tables
                    Where table_Name = 'PRIVILEGIOPAPEL'
                    And  Owner = 'DBAINFRA'; 
                   if lCount > 0 then
                         Execute Immediate 'Drop Table DBAINFRA.PrivilegioPapel';
                   End if;
                    Execute Immediate '
                        CREATE TABLE Dbainfra.PrivilegioPapel 
                         (
                            Papel       Varchar2(50),
                            Owner       Varchar2(50),
                            Objeto      Varchar2(50),
                            Privilegio  Varchar2(50)
                          )
                            ORGANIZATION EXTERNAL 
                          (
                            TYPE oracle_loader
                            DEFAULT DIRECTORY USUARIOS_SCA
                            ACCESS PARAMETERS (
                            RECORDS DELIMITED BY NEWLINE
                            FIELDS TERMINATED BY '',''
                            MISSING FIELD VALUES ARE NULL
                            REJECT ROWS WITH ALL NULL FIELDS
                            (Papel,Owner,Objeto,Privilegio)
                           )
                            LOCATION (''PrivilegioPapel.Dat'')
                        )
                         PARALLEL
                         REJECT LIMIT 0';
          Exception 
                When Others Then
                        Raise ; 
      End GuardarPrivilegioPapel;
      Procedure CriarUsuario AS
        UserCur    rcCursor;
        lDsLogin   Varchar2(50);
        ldsSenha   Varchar2(50); 
        lCount      integer:=0;
        Begin
                    select count(1) into lCount 
                    from all_tables
                    Where table_Name = 'USUARIO'
                    And  Owner = 'DBAINFRA'; 
                if lCount = 0 then
                    Execute Immediate '
                                CREATE TABLE DBAINFRA.Usuario 
                                (
                                    Usuario  Varchar2(50),
                                    Senha  Varchar2(50)
                                )
                                ORGANIZATION EXTERNAL 
                                (
                                    TYPE oracle_loader
                                    DEFAULT DIRECTORY USUARIOS_SCA
                                    ACCESS PARAMETERS 
                                    (
                                        RECORDS DELIMITED BY NEWLINE
                                        FIELDS TERMINATED BY '',''
                                        MISSING FIELD VALUES ARE NULL
                                        REJECT ROWS WITH ALL NULL FIELDS
                                        (Usuario,Senha)
                                    )
                                    LOCATION (''Usuario.Dat'')
                                )
                                PARALLEL
                                REJECT LIMIT 0';
                end if;
                OPEN UserCur FOR 'Select e.USUARIO,e.Senha
                                  from Dbainfra.Usuario e' ;
                Loop
                    Fetch UserCur into lDsLogin,ldsSenha;
                    Exit When UserCur%NotFound;
                    dbainfra.pcksas.UPBDCRIARUSUARIO(lDsLogin,lDsLogin);
                    EXECUTE IMMEDIATE 'Alter User "' || lDsLogin || '" IDENTIFIED BY VALUES ''' || ldsSenha || '''' ;
                End Loop;    
      End CriarUsuario;
      Procedure VincularPapelUsuario AS
        UserCur    rcCursor;
        lDsLogin    Varchar2(50);
        lNmPapel    Varchar2(50);
        lCount      integer;
        lStrRetorno varchar(300);
        Begin
                   select count(1) into lCount 
                   from all_tables
                   Where table_Name = 'PAPELUSUARIO'
                   And  Owner = 'DBAINFRA'; 
                   if lCount = 0 then
                         Execute Immediate '
                        CREATE TABLE DBAINFRA.PapelUsuario 
                        (
                            DsLogin  Varchar2(50),
                            NmPapel  Varchar2(50))
                            ORGANIZATION EXTERNAL 
                            (
                                TYPE oracle_loader
                                DEFAULT DIRECTORY USUARIOS_SCA
                                ACCESS PARAMETERS (
                                RECORDS DELIMITED BY NEWLINE
                                FIELDS TERMINATED BY '',''
                                MISSING FIELD VALUES ARE NULL
                                REJECT ROWS WITH ALL NULL FIELDS
                                (DsLogin,NmPapel)
                            )
                            LOCATION (''PapelUsuario.Dat'')
                        )
                            PARALLEL
                            REJECT LIMIT 0';
                   End if;
                OPEN UserCur FOR 'Select pu.DsLogin,pu.NmPapel
                                  from Dbainfra.PapelUsuario pu' ;
                Loop
                     Fetch UserCur into lDsLogin,lNmPapel;
                     Exit When UserCur%NotFound;
                     dbainfra.pcksas.upBDCriarPapel(lNmPapel);
                     dbainfra.pcksas.upVincularPapelUsuario(lDsLogin,lNmPapel,lStrRetorno);
                End Loop;
      End VincularPapelUsuario;
      Procedure CriarPrivilegioPapel AS
        curPrivilegio       rcCursor;
        lNmPapel            Varchar2(50);
        lDsOwner            Varchar2(50);
        lNmObjeto           Varchar2(50);
        lNmPrivilegio       Varchar2(50);
        lCount              integer;
        lStrRetorno         varchar2(300);
        Begin
                select count(1) into lCount 
                    from all_tables
                    Where table_Name = 'PRIVILEGIOPAPEL'
                    And  Owner = 'DBAINFRA'; 
                   if lCount = 0 then
                        Execute Immediate '
                        CREATE TABLE Dbainfra.PrivilegioPapel 
                         (
                            Papel       Varchar2(50),
                            Owner       Varchar2(50),
                            Objeto      Varchar2(50),
                            Privilegio  Varchar2(50)
                          )
                            ORGANIZATION EXTERNAL 
                          (
                            TYPE oracle_loader
                            DEFAULT DIRECTORY USUARIOS_SCA
                            ACCESS PARAMETERS (
                            RECORDS DELIMITED BY NEWLINE
                            FIELDS TERMINATED BY '',''
                            MISSING FIELD VALUES ARE NULL
                            REJECT ROWS WITH ALL NULL FIELDS
                            (Papel,Owner,Objeto,Privilegio)
                           )
                            LOCATION (''PrivilegioPapel.Dat'')
                        )
                         PARALLEL
                         REJECT LIMIT 0';
                   End if;
                OPEN curPrivilegio FOR 'Select pp.Papel,pp.Owner,pp.Objeto,pp.Privilegio
                                        From Dbainfra.PrivilegioPapel pp';
                Loop
                     Fetch curPrivilegio into lNmPapel,lDsOwner,lNmObjeto,lNmPrivilegio;
                     Exit When curPrivilegio%NotFound;
                     dbainfra.pcksas.upObjetoConcederPrivilegio(lNmPrivilegio,lDsOwner||'.'||lNmObjeto,lNmPapel, lStrRetorno);
                End Loop;
        Exception 
                When Others Then
                    dbms_output.PUT_LINE(lNmPrivilegio || ' - ' || lDsOwner || ' - ' || lNmObjeto || ' - ' || lNmPapel );
      End CriarPrivilegioPapel;
      Procedure GuardarMetaDados as
          Begin
                GuardarUsuario;
                GuardarPapelUsuario;
                GuardarPrivilegioPapel;
      End GuardarMetaDados;
      Procedure CriarMetaDados as
            Begin
                CriarUsuario;
                VincularPapelUsuario;
                CriarPrivilegioPapel;
      End CriarMetaDados;
End pckAuxiliarRefreshBD;
/


