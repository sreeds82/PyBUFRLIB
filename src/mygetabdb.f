      SUBROUTINE MYGETABDB(LUNIT,TABDB)

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    GETABDB
C   PRGMMR: ATOR             ORG: NP12       DATE: 2005-11-29
C
C ABSTRACT: THIS SUBROUTINE RETURNS INTERNAL TABLE B AND TABLE D
C   INFORMATION FOR LOGICAL UNIT LUNIT IN A PRE-DEFINED ASCII FORMAT.
C
C PROGRAM HISTORY LOG:
C 2005-11-29  J. ATOR    -- ADDED TO BUFR ARCHIVE LIBRARY (WAS IN-LINED
C                           IN PROGRAM NAMSND)
C
C USAGE:    CALL GETABDB( LUNIT, TABDB, ITAB, JTAB )
C   INPUT ARGUMENT LIST:
C     LUNIT    - INTEGER: FORTRAN LOGICAL UNIT NUMBER FOR BUFR FILE
C
C   OUTPUT ARGUMENT LIST:
C     TABDB    - CHARACTER*128: (JTAB)-WORD ARRAY OF INTERNAL TABLE B
C                AND TABLE D INFORMATION
C
C REMARKS:
C    THIS ROUTINE CALLS:        NEMTBD   STATUS
C    THIS ROUTINE IS CALLED BY: None
C                               Normally called only by application
C                               programs.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$



      INCLUDE 'bufrlib.prm'

      COMMON /TABABD/ NTBA(0:NFILES),NTBB(0:NFILES),NTBD(0:NFILES),
     .                MTAB(MAXTBA,NFILES),IDNA(MAXTBA,NFILES,2),
     .                IDNB(MAXTBB,NFILES),IDND(MAXTBD,NFILES),
     .                TABA(MAXTBA,NFILES),TABB(MAXTBB,NFILES),
     .                TABD(MAXTBD,NFILES)

      CHARACTER*600 TABD,AFMT,BFMT,DFMT
      CHARACTER*128 TABB
      CHARACTER*128 TABA
      CHARACTER*600 TEMP, ELEMS
      INTEGER       ENTRIES
      PARAMETER     (ENTRIES=900)
      CHARACTER*600 TABDB(ENTRIES)
      CHARACTER*600 TABANEMS,TABBNEMS,TABDNEMS
      CHARACTER*8   NEMO,NEMS(MAXCD)
      CHARACTER*80  DESC,UNITS,FXY
      INTEGER       NSEQ
      DIMENSION     IRPS(MAXCD),KNTS(MAXCD)

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

      JTAB = 0

C  MAKE SURE THE FILE IS OPEN
C  --------------------------

      CALL STATUS(LUNIT,LUN,IL,IM)
      IF(IL.EQ.0) RETURN
      
      DO I=1,NTBA(LUN)
      NEMO = TABA(I,LUN)(4:11)
      CALL NEMTBD(LUN,I+4,NSEQ,NEMS,IRPS,KNTS)
      JTAB = JTAB+1
      IF(JTAB.LE.ENTRIES) THEN
         if (NSEQ .gt. 0) then
         write(AFMT,'(A,I4,A)') '(''A::'',A8,',NSEQ,'('','',A10))'
C         write(*,*) 'ATTEMPT...', DFMT
         write(*,AFMT) NEMO,(NEMS(J),J=1,NSEQ)
         WRITE(TABDB(JTAB),AFMT) NEMO,(NEMS(J),J=1,NSEQ)
         endif
      ENDIF
      ENDDO


      DO I=1,NTBD(LUN)
      NEMO = TABD(I,LUN)(7:14)
      CALL NEMTBD(LUN,I,NSEQ,NEMS,IRPS,KNTS)
      JTAB = JTAB+1
      IF(JTAB.LE.ENTRIES) THEN
         if (NSEQ .gt. 0) then

C THIS WORKS! (sans comma)
C         write(myfmt,'(A,I4,A)') '(',NSEQ,'(1X,A10))'
C         write(*,*) 'ATTEMPT...'
C         write(*,fmt=myfmt) (NEMS(J),J=1,NSEQ)

         write(DFMT,'(A,I4,A)') '(''D::'',A8,',NSEQ,'('','',A10))'
C         write(*,*) 'ATTEMPT...', DFMT
         write(*,DFMT) NEMO,(NEMS(J),J=1,NSEQ)

         WRITE(TABDB(JTAB),DFMT) NEMO,(NEMS(J),J=1,NSEQ)
         endif
      ENDIF
      ENDDO

      DO I=1,NTBB(LUN)
      NEMO = TABB(I,LUN)(7:14)
      DESC = TABB(I,LUN)(16:70)
      UNITS = TABB(I,LUN)(71:94)
      FXY = TABB(I,LUN)(1:6)
      JTAB = JTAB+1
      IF(JTAB.LE.ENTRIES) THEN
         WRITE(TABDB(JTAB),3) NEMO,DESC,UNITS,FXY
      ENDIF
      ENDDO

C1        FORMAT('A::',A8,<NSEQ>(',',A10))
C2        FORMAT('D::',A8,<NSEQ>(',',A10))
3        FORMAT('B::',A8,',',A75,',',A25,',',A6)


      RETURN
      END
