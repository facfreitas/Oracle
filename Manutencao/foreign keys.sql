SELECT OWNER, TABLE_NAME,CONSTRAINT_NAME,R_constraint_name
FROM dba_constraints
WHERE constraint_type = 'R'
AND R_constraint_name IN (SELECT constraint_name FROM dba_constraints
					  	 		 				 	    WHERE constraint_type = 'P'
														AND OWNER = 'STAB'
														AND table_name IN ('ATENDE_SETORES' ,'CODIGO_SETORES','COORDENACAO','DAD_TECN_PROJ','EMPREGADOS',
                                                        			   	  						  'FOLH_MED_SERV','HISTORICO_SETORES','ITEM_FMSV','ITEM_PSV','MAT_FNED','MAT_RSV','MOV_MTRS', 
														                                          'PLAJ_PROJ','PROJ_ASSO','PROJ_OBRA','RESERVA ','TOTZ_INFO_ETGC'))
ORDER BY 1,2,3																								  



														
