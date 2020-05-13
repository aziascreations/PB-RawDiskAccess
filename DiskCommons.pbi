
;- Compiler directives

;EnableExplicit


;- Structures

; https://docs.microsoft.com/en-us/windows/win32/api/winioctl/ns-winioctl-disk_geometry
; https://docs.microsoft.com/en-us/windows/win32/winprog/windows-data-types
; https://docs.microsoft.com/en-us/windows/win32/api/winioctl/ne-winioctl-media_type
; https://docs.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-large_integer~r1
; L_> LARGE_INTEGER == PB.q

; typedef struct _DISK_GEOMETRY {
;   LARGE_INTEGER Cylinders;
;   MEDIA_TYPE    MediaType;
;   DWORD         TracksPerCylinder;
;   DWORD         SectorsPerTrack;
;   DWORD         BytesPerSector;
; } DISK_GEOMETRY, *PDISK_GEOMETRY;

Structure DISK_GEOMETRY
	Cylinders.q
	MediaType.l ; The type was derived from "std::cout << sizeof(DISK_GEOMETRY);"
	            ; The documentation wasn't clear about that. (Nor its possible value for that matter)
	TracksPerCylinder.l ; Should be unsigned
	SectorsPerTrack.l   ; Should be unsigned
	BytesPerSector.l    ; Should be unsigned
EndStructure



;- IOCTL stuff
; Source: http://forums.purebasic.com/english/viewtopic.php?f=13&t=67490

#IOCTL_DISK_GET_DRIVE_GEOMETRY = $70000
#IOCTL_DISK_GET_LENGTH_INFO = $7405C
;#IOCTL_DISK_DELETE_DRIVE_LAYOUT = $7C100



;- Tests

CompilerIf #PB_Compiler_IsMainFile
	Debug "DiskCommons tests..."+#CRLF$
	
	Debug "> SizeOf(DISK_GEOMETRY) ?= 24"
	Debug SizeOf(DISK_GEOMETRY)
	
CompilerEndIf
