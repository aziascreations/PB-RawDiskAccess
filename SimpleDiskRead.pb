
;- Compiler directives

EnableExplicit

CompilerIf Not #PB_Compiler_IsMainFile
	CompilerError "This file should not be included !"
CompilerEndIf


;- Constants

#DrivePath$ = "\\.\PhysicalDrive6" ; Change the number at the end to select a drive (Check diskpart or diskmgmt.msc)
#MaxDumpPageCount = 8              ; Set to -1 to ignore limit


;- Code

Define CurrentFilePointer.q = 0

If Not IsUserAdmin_()
	Debug "ERROR: The program is not running with administrator rights !"
	End 1
EndIf


Debug "Attempting to access: "+#DrivePath$

; Normally you should only read chunks of data from a disk in multiple of the sector size of the drive, 
;  but PB seems to handle that part on its own so we will ignore this in this example.

If ReadFile(0, #DrivePath$, #PB_File_SharedRead | #PB_File_SharedWrite)
	Define CurrentLine$
	
	While (Not Eof(0)) And ((CurrentFilePointer>>8) <> #MaxDumpPageCount)
		CurrentLine$ = CurrentLine$ + RSet(Hex(ReadByte(0), #PB_Byte), 2, "0") + Space(1)
		
		; Printing the page number every 256 bytes.
		If Mod(CurrentFilePointer, 256) = 0
			Debug #CRLF$ + "Page "+Str(CurrentFilePointer>>8)+":"
		EndIf
		
		; Printing the line every 16 bytes.
		If Mod(CurrentFilePointer, 16) = 15
			Debug CurrentLine$
			CurrentLine$ = ""
		EndIf
		
		CurrentFilePointer = CurrentFilePointer + 1
    Wend
	
	CloseFile(0)
Else
	Debug "ERROR: Unable to open the drive ("+Str(GetLastError_())+")"
	End 2
EndIf

Debug #CRLF$ + "Done !"
