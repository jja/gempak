	SUBROUTINE DM_GTIM  ( iflno, maxtim, ntime, timlst, iret )
C************************************************************************
C* DM_GTIM								*
C*									*
C* This subroutine returns a list of the GEMPAK date/times found in	*
C* the file.  The times are sorted from earliest to latest.		*
C*									*
C* DM_GTIM  ( IFLNO, MAXTIM, NTIME, TIMLST, IRET )			*
C*									*
C* Input parameters:							*
C*	IFLNO		INTEGER		File number			*
C*	MAXTIM		INTEGER		Max number of times to return	*
C*									*
C* Output parameters:							*
C*	NTIME		INTEGER		Number of times returned	*
C*	TIMLST (NTIME)	CHAR*		List of times			*
C*	IRET		INTEGER		Return code			*
C*					  0 = normal return		*
C*					 -4 = file not open		*
C*					-27 = invalid time keywords	*
C*					-28 = too many times		*
C**									*
C* Log:									*
C* M. desJardins/GSFC	 5/87						*
C* M. desJardins/GSFC	 2/88	Fixed to work with single dim files	*
C* J. Whistler/SSAI	 7/91	Fixed ilast for dttype = col		*
C* D. Kidwell/NCEP	 2/99	Added check for new century             *
C* m. gamazaychikov/CWS 04/11   Add code for A2DB connectivity          *
C************************************************************************
	INCLUDE		'GEMPRM.PRM'
	INCLUDE		'dmcmn.cmn'
C
	CHARACTER*(*)	timlst (*)
	CHARACTER	dttype*4, dt*20
C-----------------------------------------------------------------------
	ntime = 0
C
C*	Check that the file is open.
C
	CALL DM_CHKF  ( iflno, iret )
	IF  ( iret .ne. 0 )  RETURN
C
C*	Check that keys are in file.
C
	CALL DM_LTIM  ( iflno, dttype, ildate, iltime, iret )
	IF  ( iret .ne. 0 )  RETURN
C
C*	Check which headers to use.
C
	IF  ( dttype .eq. 'ROW' )  THEN
	    istart = 1
	    ilast  = klstrw ( iflno )
	  ELSE
	    istart = krow ( iflno ) + 1
	    ilast  = krow ( iflno ) + klstcl ( iflno )
	END IF
C
C*	Loop through all the headers.
C
	DO  ih = istart, ilast
C
C*	    Check that header is defined.
C
	    IF  ( kheadr ( 0, ih, iflno ) .ne. IMISSD )  THEN
C
C*		Convert to GEMPAK date/time.
C
		idate = kheadr ( ildate, ih, iflno )
		itime = kheadr ( iltime, ih, iflno )
		CALL TI_CDTM   ( idate, itime, dt, iret )
C
C*		Loop through times already found checking for this time.
C
		IF  ( iret .eq. 0 )  THEN
		    is = 1
		    DO WHILE  ( ( is .le. ntime ) .and.
     +				( dt .gt. timlst ( is ) ) )
			is = is + 1
		    END DO
C
C*		    Check that this is a new time.
C
		    IF  ( ( is .gt. ntime ) .or. 
     +			  ( dt .ne. timlst ( is ) ) )  THEN
C
C*			Return error if new time cannot be added.
C
			IF  ( ntime .lt. maxtim )  THEN
			    ntime = ntime + 1
C
C*			    Move old times and insert new time.
C
			    DO  it = ntime, is+1, -1
				timlst ( it ) = timlst ( it - 1 )
			    END DO
			    timlst ( is ) = dt
			  ELSE
			    iret = -28
			    RETURN
			END IF
		    END IF
		END IF
	    END IF
	END DO
C
C*	Check for new century.
C
      	CALL TI_YYYY ( ntime, timlst, timlst, iret )
C*
	RETURN
	END
