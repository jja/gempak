	SUBROUTINE HGSAVE  ( filnam, iframe, nframe, iret )
C************************************************************************
C* HGSAVE - XW								*
C*									*
C* This subroutine exports the current X window into an output file	*
C* specified by the file extension in filnam. If the window does not	*
C*  exist, an error is returned.					
C*									*
C* HGSAVE  ( FILNAM, IFRAME, NFRAME, IRET )				*
C*									*
C* Input parameters:							*
C*	FILNAM		CHAR*		Gif File name			*
C*	IFRAME		INT		Frame index number		*
C*	NFRAME		INT		Number of frames		*
C*									*
C* Output parameters:							*
C*	IRET		INTEGER		Return code			*
C**									*
C* Log:									*
C* C. Bailey/HPC	 1/05						*
C************************************************************************
        INCLUDE         'ERROR.PRM'
C*
	CHARACTER*(*) 	filnam
	INTEGER		iframe, nframe
C------------------------------------------------------------------------
	iret = NORMAL
C
C*	Export the current window to a file.
C
        CALL ST_LSTR ( filnam, lenw, ier )
C
	CALL XGSAVE ( filnam, lenw, iframe, nframe, iret )
C	
	RETURN
	END
