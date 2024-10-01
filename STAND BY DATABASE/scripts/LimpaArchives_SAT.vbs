'Script responsavel por limpar automaticamente os ARCHIVES com mais de 
'1 dia de antiguidade (Já estarão na FITA). 
'Ultima atualização: 12/06/2008

Option Explicit
on error resume next
	Dim oFSO
	Dim sDirectoryPath
	Dim oFolder
	Dim oFileCollection
	Dim oFile
	Dim iDaysOld

'Entra com a pasta a ser pesquisada
	iDaysOld = 1
	Set oFSO = CreateObject("Scripting.FileSystemObject")
	sDirectoryPath = "G:\ARCHIVE_STD\SAT"
	set oFolder = oFSO.GetFolder(sDirectoryPath)
	set oFileCollection = oFolder.Files

'Pesquisa em todos os arquivos da pasta.Se for mais antigo do que 1 dia, apaga.
	For each oFile in oFileCollection
		If oFile.DateLastModified < (Date() - iDaysOld) Then
			oFile.Delete(True)
		End If
	Next

'Limpa tudo
	Set oFSO = Nothing
	Set oFolder = Nothing
	Set oFileCollection = Nothing
	Set oFile = Nothing
