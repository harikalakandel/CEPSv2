C
C     PROGRAM GenMes TO GENERATE PREDICTION ERROR FILTER
C     AND PLOT THE SPECTRAL DENSITY FUNCTION BASED ON
C     AUTOREGRESSIVE DECOMPOSITION
C     MSFORTRAN for NT FORTRAN POWERSTATION compiler
C     Updated 2 January 2014
C	This is a generic MESA program for general purpose work.
C	Set bin size below as BPTU= Bins Per Time Unit
      DIMENSION BEST(1000000),X(1000000),B(1000000),A(1000000),
	&F(1000000),TAU(1000000)
      COMMON X,B,A,BEST,F,TAU
      DIMENSION AO(9999)
      CHARACTER*3 FILTYP,ANS, QUIT
      CHARACTER*64 FNAME ,OUTFIL
      CHARACTER*25 TITLE
      REAL NOM,MFPE
C
C      WRITE(*,'(A)') ' Enter bins/time unit'
C      READ(*,*) bptu
	bptu = 1      
C      ANS = 'N'
C     MFL SETS THE MINIMUM FILTER LENGTH FOR NOISY DATA
c	WRITE (*,*) 'INPUT MINIMUM FILTER LENGTH  '
c	READ (*,*) MFL
c      MFL =  30
C	WRITE(*,'(A)') '   DO YOU WANT THE DATA FILTERED? (Y/N)'
C      READ(*,'(A)')  ANS
C      IF(ANS.EQ.'Y') GO TO 385
C      IF(ANS.EQ.'y') GO TO 385
      ANS = 'N'
C
385   WRITE(*,'(A)') '   NAME OF DATA FILE?'
      READ(*,'(A)') FNAME
	WRITE (*,*) FNAME
112   WRITE(*,'(A)') '  INPUT A NAME FOR THE FILE TO CONTAIN SPECTRUM: '
      READ(*,'(A)') OUTFIL
C     OPEN BOTH THE DATA FILE AND A FILE TO CONTAIN THE SPECTRA
      OPEN (8,FILE=FNAME, ACCESS='SEQUENTIAL',STATUS='OLD')
      OPEN (UNIT = 14, FILE = OUTFIL ,STATUS = 'NEW',ERR=357)
      GO TO 111
357   WRITE(*,'(A)') '   OOPS, THAT FILE ALREADY EXISTS! TRY AGAIN...'
      GO TO 112
111   CONTINUE 
c      READ (8,876) TITLE
c      IF (TITLE.EQ.'END') GO TO 999	
411   continue
876   FORMAT (A25)
c      WRITE (*,*) 'Working on ',TITLE
c      WRITE (14,*) TITLE
C     
C	DO 5555 M = 1, IDIS
C	  READ (8,*) DUM
C     5555  CONTINUE	   
      DO 97 J=1,100000
        READ (8,*,END=98) X(J)
		X(J) = X(J)
c		READ (8,*) X(J)
97    CONTINUE
C
98    NSAMPS= j - 1
      WRITE (*,*) 'Number of samples = ',NSAMPS
	MFL = NSAMPS/3 
      CALL DETREN (NSAMPS)
      FILTYP = 'RAW'
      IF (ANS.EQ.'N') GO TO 727
	IF (ANS.EQ.'n') GO TO 727
C      CALL LOPASS (NSAMPS,FILTYP)
727   WRITE (*,*) 'The filter is: ',FILTYP
      NCOEF = NSAMPS/2
C
C
C
C     SUBROUTINE TO GENERATE MAXIMUM ENTROPY PREDICTION
C     ERROR FILTER COEFFICIENTS AND AKAIKE FPE'S.
C     IT RETURNS THE FILTER LENGTH AS NCOEF FOR MINIMUM FPE.
C     X  AREAL ARRAY CONTAINING THE TIME SERIES TO GENERATE
C     THE FILTER FOR.  IT MUST BE AT LEAST NSAMPS ELEMENTS LONG
C     B  A REAL WORK ARRAY  . MUST BE AT LEAST NSAMPS LONG
C     NSAMPS       THE NUMBER OF SAMPLES TO BUILD THE FILTER FROM.
C     A  A REAL ARRAY IN WHICH TO RETURN THE PREDICTION ERROR
C     FILTER COEFFICIENTS.  IT MUST BE AT LEAST NCOEF ELEMENTS
C     LONG
C
C     NCOEF        THE NUMBER OF COEFFICIENTS IN THE PREDICTION ERROR
C     FILTER
C     P  THE OUTPUT POWER OF THE PREDICTION ERROR FILTER
C
C     DETREN FITS A LINEAR MODEL AND SUBTRACTS IT TO REMOVE TREND
C     BASED ON ANDERSON, GEOPHYSICS FEB '74 PP69-72.
C
C
C     INITIALIZE.
C
      P=0.0
      MFPE=0.0 
      DO 100 I=1,NSAMPS
      B(I)=X(I)
      P=P+X(I)*X(I)
100   CONTINUE
      P=P/FLOAT(NSAMPS)
      FPE=FLOAT(NSAMPS+1)/FLOAT(NSAMPS-1)*P
      FTEMP = FPE
      FPE=0.0
      A(1)=-1
      AO(1)=-1
      NN=NCOEF-1
      DO 1000 M=1,NN
      NMM=NSAMPS-M
C
C        UPDATE B,B'
C
      DO 200 I=1,NMM
      X(I)=X(I)-A(M)*B(I)
      B(I)=B(I+1)-A(M)*X(I+1)
200   CONTINUE
C
C     COMPUTE A(M,M)
C
      NOM=0
      DENOM=0
      DO 300 I=1,NMM
      NOM=NOM+X(I)*B(I)
      DENOM=DENOM+X(I)*X(I)+B(I)*B(I)
300   CONTINUE
      A(M+1)=2*NOM/DENOM
      P=P*(1-A(M+1)*A(M+1))
C
C     COMPUTE AKAIKE FPE
C
      NO=NSAMPS/2
      IF(M.EQ.1.OR.M.GE.NO)GO TO 1100
      FPE=FLOAT(NSAMPS+M)/FLOAT(NSAMPS-M)*P
      FPE=FPE/FTEMP
      FPE=ALOG10(FPE)
1100  CONTINUE
C
C     COMPUTE THE REST OF THE COLUMN IN PLACE
C
      IF (M.EQ.1) GO TO 401
      DO 400 I=2,M
      AO(I) = A(I)-A(M+1)*A(M+2-I)
400   CONTINUE
C
      DO 425 I=2,M
      A(I)=AO(I)
425   CONTINUE
      AO(M+1)=A(M+1)
401   CONTINUE
      IF(M.EQ.MFL) GO TO 597
      IF(FPE.GE.MFPE)GO TO 1001
C     THIS NEXT STEP SETS THE MINIMUM FILTER LENGTH
C     IT'S BEST NOT TO ACTIVATE IT UNLESS YOUR DATA ARE
C     IMPOSSIBLY NOISY, AND THE PROGRAM KEEPS BLOWING UP
      IF(M.LT.MFL)GO TO 1001
      CONTINUE
C
C     WRITE OUT SET OF COEFFICIENTS FOR FILTER WITH LOWEST FPE
C
597   CONTINUE
      LFILT=M+1
      MFPE=FPE
      PO = P
      DO 3000 J=1,LFILT
      BEST(J)=AO(J)
3000  CONTINUE
1001  CONTINUE
1000  CONTINUE
C
C     FILL ARRAY WITH COEFF. FOR PROPER LENGTH FILTER
C
42    CONTINUE
C
      NCOEF=LFILT
      A(1) = -1
C     FIX THE SIGNS
C
      DO 500 I=1,NCOEF
      BEST(I)=-BEST(I)
500   CONTINUE
C
C
C
C     THIS PART OF THE PROGRAM COMPUTES THE MESA SPECTRUM AND
C     WRITES THE SPECTRUM ESTIMATES TO DISK
C
C
      FMIN=2.0/FLOAT(NSAMPS)
      FMAX=0.5
871   FORMAT (A10)
      CALL MESA(FMIN,FMAX,NSAMPS,NCOEF,PO,BPTU)
C
c      GO TO 111
C
999   CONTINUE
      QUIT = 'END'
c      WRITE (14,*) QUIT
      CLOSE (14, STATUS = 'KEEP')
      CLOSE (8)
      STOP
      END
C
      SUBROUTINE MESA(FMIN,FMAX,NSAMPS,NCOEF,PO,BPTU)
C
C     SUBROUTINE TO COMPUTE SAMPLES OF A MESA SPECTRUM FROM A
C     PREDICTION ERROR FILTER
C
C     FMIN,FMAX   THE RANGE OF FREQUENCIES TO COMPUTE
C     (CYCLES PER SAMPLE)
C     F  A REAL ARRAY AT LEAST NSAMPS LONG TO CONTAIN
C     THE SAMPLED FREQUENCY VALUES.
C     NSAMPS       THE NUMBER OF FREQUENCY VALUES TO COMPUTE
C     A  A REAL ARRAY OF PREDICITON ERROR FILTER COEFFICIENTS
C     NCOEF        THE NUMBER OF COEFFICIENTS IN THE PREDICTION ERROR
C     FILTER.  THE FIRST COEFFICIENT IS ALWAYS ONE IN A PREDICTION
C     ERROR FILTER.
C     P  THE OUTPUT POWER OF THE PREDICTION ERROR FILTER.
C
      REAL IMAG
      DIMENSION BEST(1000000),X(1000000),B(1000000),A(1000000),
	&F(1000000),TAU(1000000)
      COMMON X,B,A,BEST,F,TAU
      PI2=6.2831830717959
	IHR = 32
      DO 105 I=1,NSAMPS*IHR
        FREQ=FMIN+(I-1)*(FMAX-FMIN)/FLOAT(NSAMPS*IHR-1)
        TAU(I)=1/FREQ
        REAM=0
        IMAG=0
        DO 50 J=1,NCOEF
           OMEGA=(-PI2*FREQ*J)
           REAM=REAM+BEST(J)*COS(OMEGA)
           IMAG=IMAG+BEST(J)*SIN(OMEGA)
50      CONTINUE
        F(I)=PO/(REAM*REAM+IMAG*IMAG)
c        f(i) = f(i)
        TAU(I) = TAU(I)/BPTU
	  IF (TAU(I).LT.0.1) GOTO 105
	  WRITE (14,*) F(I), TAU(I)
c        WRITE (14,543) F(I), TAU(I)
C543     FORMAT (6X,F15.1,6X,F15.6)
105   CONTINUE
c      TAG = -5000
c      WRITE (14,543) TAG,TAG
      RETURN
      END
C
      SUBROUTINE DETREN (NSAMPS)
C
      DIMENSION TI(9999),RES(9999)
      DIMENSION BEST(1000000),X(1000000),B(1000000),A(1000000),
	&F(1000000),TAU(1000000)
      COMMON X,B,A,BEST,F,TAU
C
C     INITIALIZE FOR SUMMATION
      SUMX = 0
      SUMTI = 0
      SUMXT = 0
      SUMTSQ = 0
      EN=FLOAT(NSAMPS)
      DO 10 I = 1,NSAMPS
        TI(I) = FLOAT(I)
        SUMX = SUMX + X(I)
        SUMTI = SUMTI + TI(I)
        SUMTSQ = SUMTSQ + (TI(I)*TI(I))
        SUMXT = SUMXT + (X(I)*TI(I))
10    CONTINUE
      XBAR = SUMX / EN
      TBAR = SUMTI / EN
      Q=(SUMXT-(SUMX*SUMTI)/ EN)/(SUMTSQ-(SUMTI*SUMTI)/ EN)
      XINT = XBAR + (Q*(0-TBAR))
      DO 20 I = 1,NSAMPS
        XHAT = XBAR + Q*(TI(I)-TBAR)
        RES(I) = X(I) - XHAT
        X(I) = RES(I)
20    CONTINUE
      RETURN									   
      END
C
C
      SUBROUTINE LOPASS (NSAMPS,FILTYP)
C
      DIMENSION BEST(1000000),X(1000000),B(1000000),A(1000000),
	&F(1000000),TAU(1000000)
      REAL Y(1000000)
      COMMON X,B,A,BEST,F,TAU
      CHARACTER*3  FILTYP
C     TWO POLE LOW PASS BUTTERWORTH FILTER
C
      FILTYP = '4HC'
      Y(1) = X(1)
      Y(2) = X(2)
C
C	Four hour cutoff, 10 minute bins, from basica program
C	P = 113.391
C	Q = -47.95346
C	C = 69.4375
C    Four hour cutoff, half hour bins
	P = 9.656851
 	Q = -3.414213
	C = 10.24264
c
c	P = 179.0462
c 	Q = -78.06775
c	C = 104.9784
c

C     End filter bank
      DO 5 I = 3,NSAMPS
        Y(I) = (X(I)+2*X(I-1)+X(I-2)+P*Y(I-1)+Q*Y(I-2))/C
5     CONTINUE
C
      DO 10 I = 1,NSAMPS
      X(I) = Y(I)
10    CONTINUE
      RETURN
      END
C