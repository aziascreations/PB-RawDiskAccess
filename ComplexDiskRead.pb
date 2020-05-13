
; Lunasole's post on the PureBasic forum
; > http://forums.purebasic.com/english/viewtopic.php?f=13&t=67490


;- Compiler directives

EnableExplicit

XIncludeFile "./DiskCommons.pbi"

CompilerIf Not #PB_Compiler_IsMainFile
	CompilerError "This file should not be included !"
CompilerEndIf


;- Constants

#DrivePath$ = "\\.\PhysicalDrive6" ; Change the number at the end to select a drive (Check diskpart or diskmgmt.msc)
#MaxDumpPageCount = 8              ; Set to -1 to ignore limit


;- Code

; Handle to the physical drive file
Define hDisk.i ; HANDLE


Debug "Attempting to access: "+#DrivePath$

hDisk = CreateFile_(#DrivePath$, #GENERIC_ALL, #FILE_SHARE_READ | #FILE_SHARE_WRITE, 0, #OPEN_EXISTING, #FILE_ATTRIBUTE_NORMAL, 0)

If hDisk <>#INVALID_HANDLE_VALUE
	Debug "Success !"+#CRLF$
	
	; ###########################################################################
	;  All of the IOCTL related code is copied and adapted from Lunasole's code.
	;  A link to his/her post is available at the top of this file.
	; ###########################################################################
	
	; This part is not nescessary since you can technically derive it from the drive geometry,
	;  but it doesn't hurt to include it here.
	Define DiskSize.q
	
	DeviceIoControl_(hDisk, #IOCTL_DISK_GET_LENGTH_INFO, 0, 0, @DiskSize, SizeOf(Quad), #Null, 0)
	
	Debug "Disk size:"
	Debug "> "+ StrF(DiskSize / 1024, 2) + " KiB"
	Debug "> "+ StrF(DiskSize / 1024 / 1024, 2) + " MiB"
	Debug "> "+ StrF(DiskSize / 1024 / 1024 / 1024, 2) + " GiB"
	Debug ""
	
	
	; This is the important part, first we get the drive geometry which we then use to know how much data we can read
	;  from the drive, since according the online documentation provided by MS, we need to read an amount of bytes that
	;  is a multiple of the number of bytes per sector.
	; See: https://support.microsoft.com/en-us/help/100027/info-direct-drive-access-under-win32
	Define DiskGeometry.DISK_GEOMETRY
	
	DeviceIoControl_(hDisk, #IOCTL_DISK_GET_DRIVE_GEOMETRY, 0, 0, DiskGeometry, SizeOf(DISK_GEOMETRY), #Null, 0)
	
	Debug "Drive geometry:"
	Debug "> Tracks per cylinder: " + Str(DiskGeometry\TracksPerCylinder)
	Debug "> Sectors per track: " + Str(DiskGeometry\SectorsPerTrack)
	Debug "> Bytes per track: " + Str(DiskGeometry\BytesPerSector)
	Debug ""
	
	
	; The results were off by as much as 45% in my tests for some reason
	;Debug "Disk size derived from geometry: "
	;Debug "> "+ StrF((DiskGeometry\BytesPerSector * DiskGeometry\SectorsPerTrack * DiskGeometry\TracksPerCylinder) / 1024, 2) + " KiB"
	;Debug "> "+ StrF((DiskGeometry\BytesPerSector * DiskGeometry\SectorsPerTrack * DiskGeometry\TracksPerCylinder) / 1024 / 1024, 2) + " MiB"
	;Debug "> "+ StrF((DiskGeometry\BytesPerSector * DiskGeometry\SectorsPerTrack * DiskGeometry\TracksPerCylinder) / 1024 / 1024 / 1024, 2) + " GiB"
	;Debug ""
	
	
	; Buffer that will hold the data (1 sector) that is read from the disk.
	Define *Buffer = AllocateMemory(DiskGeometry\BytesPerSector)
	
	; See the doc of ReadFile_ for more info about this variable.
	Define BytesReadCount.q
	
	If *Buffer
		If ReadFile_(hDisk, *Buffer, DiskGeometry\BytesPerSector, @BytesReadCount, #Null)
			Debug "Data read successfully !"
			
			; Debugging the content of the buffer
			
			; This is a bad way of doing this, but the loop should be more or les the same as the one in SimpleDiskRead.pb.
			ShowMemoryViewer(*Buffer, MemorySize(*Buffer))
			DebuggerError("Pausing...")
		Else
			Debug "ERROR: Failed to read from disk. ("+Str(GetLastError_())+")"
		EndIf
		
		FreeMemory(*Buffer)
	Else
		Debug "ERROR: Failed to allocate memory."
	EndIf
	
	
	CloseHandle_(hDisk)
Else
	Debug "ERROR: Unable to open the drive ("+Str(GetLastError_())+")"
	End 2
EndIf

Debug #CRLF$ + "Done !"
