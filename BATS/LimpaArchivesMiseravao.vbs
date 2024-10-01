Option Explicit
on error resume next
	Dim oFSO
	Dim sDirectoryPath
	Dim oFolder
	Dim oFileCollection
	Dim oFile
	Dim iDaysOld

'Customize values here to fit your needs
	iDaysOld = 21
	Set oFSO = CreateObject("Scripting.FileSystemObject")
	sDirectoryPath = "FolderName here. Can be UNC path like \\MyServer\MyFolder"
	set oFolder = oFSO.GetFolder(sDirectoryPath)
	set oFileCollection = oFolder.Files

'Walk through each file in this folder collection. 
'If it is older than 3 weeks (21) days, then delete it.
	For each oFile in oFileCollection
		If oFile.DateLastModified < (Date() - iDaysOld) Then
			oFile.Delete(True)
		End If
	Next

'Clean up
	Set oFSO = Nothing
	Set oFolder = Nothing
	Set oFileCollection = Nothing
	Set oFile = Nothing
