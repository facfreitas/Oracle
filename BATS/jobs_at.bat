REM ##########################################################################
REM ##########################################################################
REM ##############          PROGRAMACAO DE JOBS VIA AT          ##############
REM ##############					 	##############
REM ############## 	    ANDERSON MELO 07/01/04		##############
REM ##########################################################################
REM ##########################################################################

REM ######################## COMPRESSAO DE ARCHIVES ##########################

REM #########################        SGAM	    ##########################

AT 18:00 /EVERY:M,T,W,TH,F "D:\Oracle\Sgam\archive\ZIP_ARCH.BAT" 

REM #########################        CSND	    ##########################

AT 18:05 /EVERY:M,T,W,TH,F "D:\Oracle\CSND\archive\ZIP_ARCH.BAT" 

REM #########################        CLPD	    ##########################

AT 18:10 /EVERY:M,T,W,TH,F "D:\Oracle\CLPD\archive\ZIP_ARCH.BAT" 

REM #########################        CLBD	    ##########################

AT 18:15 /EVERY:M,T,W,TH,F "D:\Oracle\CLBD\archive\ZIP_ARCH.BAT" 

REM #########################   DUMPS DOS BANCOS    ##########################


REM #########################        SGAM	    ##########################

AT 18:30 /EVERY:M,W,F "D:\Oracle\Sgam\export\F_Export.bat"

REM #########################        CLPD	    ##########################

AT 19:00 /EVERY:M,W,F "D:\Oracle\CLPD\export\F_Export.bat"

REM #########################        CSND	    ##########################

AT 20:00 /EVERY:M,W,F "D:\Oracle\CSND\export\F_Export.bat"

REM #########################        CLBD	    ##########################

AT 21:40 /EVERY:M,W,F "D:\Oracle\CLBD\export\F_Export.bat"

REM ######################### GESPLAN MANHA E TARDE ##########################

AT 12:20 /EVERY:M,T,W,TH,F "D:\Oracle\Clbd\export\gesplan01.bat"
AT 18:40 /EVERY:M,T,W,TH,F "D:\Oracle\Clbd\export\gesplan02.bat"

REM ############################# FIM DO ARQUIVO #############################
REM ##########################################################################
