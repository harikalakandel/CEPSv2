
  
  use qsort
  
%   implicit none
%   
%   real*8     x(100000000)
%   real*8    ,allocatable::r(:)
%   
%   
%   integer*4     n,i,rmax,j,nexper,posic
%   real*8        pi
%   character*100 kks,fout,fin  
%   integer*4     narg
%   real*8       ,dimension(1000)::distm,sig,distm0,dmean,dstd,pvalue
%   logical       dist_output,shuffle,only_last,acum,NO_SQUARE
%   logical       normalize
%  
%   integer*4     COUNTER 
 
%  !*************************************************
%  !***************** reads parameters **************
%  !gets the number of parameters given to executable file
%  narg=iargc()
 
 
 %!initilializes varibles with default values
 rmax=100
 %%?????
 %% d0 ???
 d0=1
 pi=4.d0*atan(1.d0)
 nexper=1000
 %dist_output=.false.
 dist_output=false
 %shuffle=.false.
 shuffle=false
 %only_last=.false.
 only_last=false
 %acum=.false.
 acum=false
 %NO_SQUARE=.false.
 NO_SQUARE=false
 %normalize=.false.
 normalize=false
 
 %!initializes random number generator
 %call init_random_seed()
 
 %% ?? not sure if we need this...
 %!lopp to read all possible options and change defaults if
 %!necessary
 %%if (narg==0) goto 777 !if no arguments jumps and avoids loop
%  i=1
%  do 
%    call getarg(i,kks)
%    select case (trim(kks))
%    case ('-h','-H','-help')
%       call printhelp()
%       stop
%    case ('-dist')
%      i=i+1
%      call getarg(i,fout)
%      dist_output=.true.   
%    case ('-nexp')
%      i=i+1
%      call getarg(i,kks)
%      read(kks,*) nexper   
%    case ('-m','-M')  
%      i=i+1
%      call getarg(i,kks)
%      read(kks,*) rmax
%    case ('-last')
%      only_last=.true.  
%    case ('-sh')
%      shuffle=.true.  
%    case ('-nosq')
%      NO_SQUARE=.true. 
%    case ('-norm')
%      normalize=.true.      
%    case ('-acum')
%      acum=.true.
%    case default
%      write(0,*)
%      write(0,*) ' Unrecognized parameter  "',trim(kks),'"'
%      write(0,*)
%      stop
%    endselect
%    i=i+1
%    if (i>narg) exit  
%  enddo
%   
%  777 continue 
% !**************************************************
  
  
  
  
  
%   !*********** Data loading *******************
%   i=1
%   do !reads from stdin until EOF or ERROR found
%     read(*,*,end=666,err=666) x(i)
%     i=i+1
%   enddo
%   666 n=i-1
data = load(dataFile);
%   !***************************************
%   ! we truncate the series in order to
%   ! have even number of dataponts (in the
%   ! worst case we loose only one datapoint)
%   !**************************************
%      if (mod(n,2).ne.0) then
%         n=n-1                   
%      end if
%   !*************************************
  
if mod(size(data,1),2)==1
    data = data (1:end-1,:);
end

%% ??????
%   !reserves memory for a copy of array x 
%   !used in calculations
%   allocate(r(n))
 
  
  
  
% ??? not sure how to do this....  
%   !*******************************************
%   !Calls the main routine to compute distances
%   !(our measure of non lineality)
%   !The results are given in the array distm0(1:rmax)
%   call getcorrtot(x,n,rmax,distm0,0,distm0)
  
%   !++++++++++++++++++++++++++
%   write(*,'(5a)') ' =================================================================='
%   write(*,'(5a)') '                        SURROGATED SIGNALS                         ',char(9),' D<Dgauss ',char(9),'  Counts  '
%   write(*,'(5a)') ' ==================================================================',char(9),'==========',char(9),'=========='
%   !++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%   
%  


%   !**** if the option '-acum' is present, i.e. acum==.true.
%   !**** distm0 is converted into its cumulative
%   !**** array
%   !**** i.e. d1'=d1, d2'=d1+d2, d3'=d1+d2+d3, ...
%     if (acum) then
%       do j=2,rmax
%          distm0(j)=distm0(j-1)+distm0(j)
%       enddo
%     endif
%   !*************************************
 
if acum
    for j=2:size(distm0,1)
        distm0(j)=distm0(j-1)+distm0(j);
    end
end
  
%   !****** Calculation of p-value ******************
%   !In order to obtain the p-value we generate
%   !nexper surrogate signals by means of pahse-randomization 
  sig=0
  dmean=0
  dstd=0
  
%   !opens the output file for the full distribution
%   !of distm values in surrogates, if the option -dist
%   !was selected
%   if (dist_output) open(3,file=trim(fout))
  
%   !++++++++++++++++++++++++++++
  COUNTER=0
%   !++++++++++++++++++++++++++++
%   do i=1,nexper
for i=1:nexper
    r(1:n)=x(1:n)
%     !keep safe x(1:n) and put a copy in r(1:n) to
%     !obtain surrogate signal by means of phase-randomization
%???
%    call randomize_phases(r,n,shuffle)
%    !and compute the distances for each of them
%??
%    call getcorrtot(r,n,rmax,distm,i,distm0)
    
%     !**** again if acum=.true. => 
%     !**** computes cumulative
%     if (acum) then
%       do j=2,rmax
%          distm(j)=distm(j-1)+distm(j)
%       enddo
%     endif

if acum
    for j=2:rmax
        distm(j)=distm(j-1)+distm(j)
    end
end
%    !*************************************
    
%     !If the user wants the full distribution of the
%     !distm values for all the experiments (option -dist)
%     !we write them to unit 3 (the given output file)
%     if (dist_output) then
%       do j=1,rmax
%         write(3,'(e12.5,a)',advance='no') distm(j),char(9)
%       enddo
%       write(3,*)
%     endif
    
%     !we compute the mean and standard deviation of distm
%     !sequentialy.For each lag from 1..rmax
%     dmean(1:rmax)=dmean(1:rmax)+distm(1:rmax)
%     dstd(1:rmax)=dstd(1:rmax)+distm(1:rmax)**2

dmean(1:rmax)=dmean(1:rmax)+distm(1:rmax);
dstd(1:rmax)=dstd(1:rmax)+distm(1:rmax)^2;
    
%     !****** IMPORTANT **********
%     !everytime that the distance in the surrogated signal (distm)
%     !is greater than the distance in the real data (distm0)
%     !we increase the counter in order to compute the p-value
%     do j=1,rmax
%       if (distm0(j)<=distm(j)) sig(j)=sig(j)+1
%     enddo
        for j=1:rmax
            if (distm0(j)<=distm(j)) 
                   sig(j)=sig(j)+1
            end
        end

%   enddo
end




%  !*** Ends the loop on surrogate signals
  
%  close(3)
  
  
%   !Obtain the mean value and standard deviation from
%   !the summations done in the loop
%   dmean(1:rmax)=dmean(1:rmax)/nexper
%   dstd(1:rmax)=dsqrt(dstd(1:rmax)/nexper-dmean(1:rmax)**2)
%   !divides by number of experiments to obtain a probability 
%   pvalue(1:rmax)=sig(1:rmax)/nexper
%     
 dmean(1:rmax)=dmean(1:rmax)/nexper
 dstd(1:rmax)=dsqrt(dstd(1:rmax)/nexper-dmean(1:rmax)^2)
 pvalue(1:rmax)=sig(1:rmax)/nexper
  
%   !If the option 'normalize' (-norm) is given the distance
%   !values are normalized as follows:
%   !1.- In the default case, divides by the mean (because expected
%   !    distribution under null hypothesis is an exponential like
%   !2.- If the option NO-SQUARE (-nosq) is selected, substracts mean
%   !    and divides by standard deviation, because in this case, expected
%   !    distribution under null hypothesis is gaussian like
%   if (normalize) then
%     if (NO_SQUARE) then
%       do j=1,rmax
%         distm0(j)=(distm0(j)-dmean(j))/dstd(j)
%       enddo  
%     else
%       do j=1,rmax
%         distm0(j)=distm0(j)/dmean(j)
%       enddo  
%     endif
%   endif
%   
if normalize
    if NO_SQUARE
        for j=1:rmax
            distm0(j)=(distm0(j)-dmean(j))/dstd(j)
        end
    else
        for j=1:rmax
            distm0(j)=distm0(j)/dmean(j)
        end
    end
end
%   !*** DON'T pay attention to this
%   !si se hace sin cuadrado puede ser significativo si es muy pequeño
%   !do j=1,rmax
%   !  if (no_square .and. pvalue(j)>0.5) then
%   !    pvalue(j)=(1-pvalue(j))
%   !  endif 
%   !enddo

for j=1:rmax
    if no_square & pvalue(j)>0.5
        pvalue(j)=(1-pvalue(j));
    end
end
  
  
  
%   !********  Just the output ***********
%   !writes 1+2*rmax tab separated columns: the first one is the length
%   !of the signal (n), the rest distm0(1),pvalue(1),distm0(2),pvalue(2),...
%   !
%   !If the option 'only_last' (-last) is selected the output is only
%   !three tab separated columns: n,distm0(rmax),pvalue(rmax)
%   !   
%   
%   !++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%   write(*,'(5a)') ' ==================================================================',char(9),'==========',char(9),'=========='
%   !++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%   
%   !write(*,'(i7,a)',advance='no') n,char(9)
%   if (only_last) then
%        !---write(*,'(f10.7,a,f9.5,a)',advance='no') &
%        !---                distm0(rmax),char(9),pvalue(rmax),char(9) !sig(rmax)/nexper,char(9)
%        write(*,'(a,f10.7)') 'D = ',distm0(rmax)
%        write(*,'(a,f10.7)') 'p = ',pvalue(rmax)
%        write(*,'(a,i6)') 'count = ',int(sig(rmax))
%        write(*,'(a,i6)') 'nexp. = ',nexper
%   else                     
%     do j=1,rmax
%       write(*,'(f10.7,a,f9.5,a)',advance='no') &
%                        distm0(j),char(9),pvalue(j),char(9) !sig(j)/nexper,char(9)
%     enddo
%   endif
%   write(*,*)  
%   !write(*,'(4(f9.5,a))') (distm0(rmax)-dmean(rmax))/dstd(rmax)
     
%   contains
% !***********************************************************  
% !***********************************************************    
% !***********************************************************  
% !***********************************************************  
% !***********************************************************    
% !***********************************************************  
% 
% !******** SUBROUTINES AND FUNCTIONS ************
% 
% 
% !prints help when program is invoked with -h
% subroutine printhelp()
%       character*100 ss      
%       call getarg(0,ss)
%       write(0,*)  
%       write(0,*) trim(ss),' [options]'
%       write(0,*) 
%       write(0,*) ' Reads 1-column data from stdin and computes'
%       write(0,*) ' (Cmod(l)-Cmod_teor)**2 and its significance'
%       write(0,*) ' for l=1 to Lmax'
%       write(0,*) 
%       write(0,*) ' WARNING: Input data should be gaussian to'
%       write(0,*) ' to obtain a proper significance'
%       write(0,*) 
%       write(0,*) ' Writes output to stdout ????????'
%       write(0,*) 
%       write(0,*) ' -nexp <# of surrogates>'
%       write(0,*) '    number of linear surrogates (def. nexper=1000)'
%       !write(0,*)
%       write(0,*) ' -m <Lmax>'
%       write(0,*) '    maximum value of correlation lag (def. Lmax=100)'
%       !write(0,*)
%       write(0,*) ' -last'
%       write(0,*) '    writes value only for Lmax'
%       !write(0,*)
%       write(0,*) ' -dist <fout>'
%       write(0,*) '    writes to fout Lmax columns with the values'
%       write(0,*) '    obtained for all surrogates'
%       !write(0,*) 
%       write(0,*) ' -sh '
%       write(0,*) '    instead of generating random phases, shuffles'
%       write(0,*) '    actual phases'
%       !write(0,*)
%       write(0,*) ' -acum'
%       write(0,*) '    Acumulates from l=1 to lmax'
%       !write(0,*)
%       write(0,*) ' -nosq'
%       write(0,*) '    only difference not squared diference'
%       !write(0,*)
%       write(0,*) ' -norm'
%       write(0,*) '    * Divides by the mean of the surrogates'
%       write(0,*) '    * Together with -nosq gives a Z-score'
%       write(0,*)
%       !write(0,*)
%       !write(0,*) ' -n <nexper> number of experiments to average (def. nexper=1)'
%       write(0,*) 
%   end subroutine printhelp    
% !*****************************************************************



% !********************************************************************
% !*********  Calculates the correlation of the absolute value  *******
% !*********  and obtains the difference with the gaussian      *******
% !********************************************************************
% !x-> array with data (IN)
% !n-> length of the array (IN)
% !Lmax -> maximum lag to compute correlations (IN)
% !distm -> array with the diferences in the absolute value correlations
% 
% !         and the gaussian for each lag (OUT)
% !**********************************************************************
% subroutine getcorrtot(x,n,Lmax,distm,surrogate,distm0)
%      real*8     x(:)
%      real*8     distm(:),distm0(:)
%      integer*4  Lmax,L
%      integer*4  i,n,j
%      integer*4  surrogate
%      
%      real*8     corr,corrm,norm,normm
%      real*8    ,allocatable::xm(:)
%      real*8     mum,mu 
%      character*10  menor
%   
%      !array for the absolute values of the series
%      allocate(xm(n))
%      xm(1:n)=abs(x(1:n))
%      !means of the series and absolute value series
%      mu=sum(x(1:n))/n
%      mum=sum(xm(1:n))/n
%     
%      !normalization factor needed for the calculation
%      !of the autocorrelation
%      norm=sum(x(1:n)**2)-n*mu**2
%      normm=sum(xm(1:n)**2)-n*mum**2
%      
%      !Loop in the lags
%      do L=1,Lmax
%        corr=0
%        corrm=0
%        !Loop in the values of the series
%        do i=1,n-L
%          j=i+L
%          corr=corr+(x(i)-mu)*(x(j)-mu)
%          corrm=corrm+(xm(i)-mum)*(xm(j)-mum)
%        enddo
%        corr=corr/norm
%        corrm=corrm/normm
%        
%        !Now we obtain the distance as the difference between
%        !the autocorrelation of the absolute value series (corrm)
%        !and the expected value in a gaussian. This expected value
%        !is given by the function cmod() which takes as parameter
%        !the autocorrelation of the series (corr).
%        !
%        !Depending on the the option selected the distance is
%        !obtained as the difference with the gaussian (-nosq)
%        !or as the squared difference (default)
%        if (NO_SQUARE) then
%          distm(L)=corrm-cmod(corr)
%        else  
%          distm(L)=(corrm-cmod(corr))**2
%        endif  
%        !write(0,'(i,3f12.8)') L,corr,corrm,distm(L)
%        
%        
%        !++++++++++++++++++++++++++++++++++++++++++
%        if (L==Lmax) then
%           if (surrogate==0) then
%             write(*,*) 'Series length: ',n
%             write(*,*) 'Lag:           ',Lmax
%             write(*,'(a6,a,10(a10,a))') "      ",char(9),"   Corr.  ",char(9)," Corr.mod ", &
%                                       char(9)," Corr.Gaus",char(9),"    D     "
%             write(*,*) '------------------------------------------------------------------'                          
%             write(*,'(a6,a,10(f10.7,a))') "      ",char(9),corr,char(9),&
%                   corrm,char(9),cmod(corr),char(9),distm(Lmax)
%            else
%              if (distm0(Lmax)<=distm(Lmax)) then
%                 menor = '   yes    '
%                 COUNTER=COUNTER+1
%              else
%                 menor = '    no    '
%              endif          
%              write(*,'(i6,a,4(f10.7,a),a10,a,i6a)') surrogate,char(9),corr,char(9),&
%                   corrm,char(9),cmod(corr),char(9),distm(Lmax),char(9),menor,char(9),COUNTER        
%            endif       
%         endif
%        !++++++++++++++++++++++++++++++++++++++++++ 
%        
%      enddo
%      deallocate(xm)
%   end subroutine getcorrtot
% !************************************************************************
% 
% 
% !************************************************************************
% !*************** PHASE RANDOMIZATION (creates surrogate signals *********
% !
% !Given a signal (r) of length n, calculates its FFT, randomize its phases
% !transform back, thus producing a surrogate linear signal with the same
% !autocorrelation as the original
% !
% ! shuffle is a flag: 
% ! .true.  =>  the randomization is done by shuffling the actual phases
% ! .false. =>  the randomizacion is done by generating random phases
% !             within the interval [-pi,pi]
% !*************************************************************************
% subroutine randomize_phases(r,n,shuffle)
%      implicit none
%      
%      logical      shuffle
%      real*8       r(:)
%      integer*4    n,i,ii
%      integer*4   ,allocatable::ind(:)
%      real*8      ,allocatable::re(:),im(:),s(:),fase(:)
%      real*8       p,sqrt2,pi,pi2,u,inter
%      
%      integer*4      inc,lenr,lensav,lenwrk,ier
%      real*8        ,allocatable::wsave(:),work(:)
%      
%      !******************************************************
%    
%      pi=datan(1.d0)*4
%      pi2=2*pi
%      sqrt2=dsqrt(2.d0)
%     
%      !*****************************************************************  
%      !initialize variables for routine rfft1f
%      lensav=n+int(log(real(n))/log(2.d0))+4 +1 !el último 1 es por si acaso
%      inc=1
%      lenr=n
%      lenwrk=n
%      allocate(wsave(lensav))
%      allocate(work(lenwrk))
%      call rfft1i(n,wsave,lensav,ier)
%     
%      !call to FFT
%      call rfft1f(n,inc,r,lenr,wsave,lensav,work,lenwrk,ier)
%      !*******************************************************************
%      allocate(re(n/2+1))
%      allocate(im(n/2+1))
%      allocate(s(n/2+1))
%      allocate(fase(n/2+1))
%      
%      !obtains the phases and changes them by random numbers or shuffle,
%      !depending on flag 'shuffle'
%      
%      do i=1,n/2-1
%        re(i)=r(2*i)
%        im(i)=r(2*i+1)
%      enddo
%     
%      if (shuffle) then
%        do i=1,n/2-1
%          s(i)=dsqrt(re(i)**2+im(i)**2)  !no se toca
%          fase(i)=dasin(im(i)/s(i))
%          if (re(i)<0) fase(i)=pi-fase(i)
%        enddo
%        do i=n/2-1,1,-1
%          call random_number(u)
%          ii=u*i+1
%          inter=fase(i)
%          fase(i)=fase(ii)
%          fase(ii)=inter
%        enddo
%      else
%        do i=1,n/2-1
%          s(i)=dsqrt(re(i)**2+im(i)**2)
%          call random_number(u)
%          fase(i)=pi2*(u-0.5d0)  
%        enddo
%      endif
% 
%      do i=1,n/2-1
%         r(2*i)=s(i)*dcos(fase(i))
%         r(2*i+1)=s(i)*dsin(fase(i))
%      enddo
%      
%      !call to inverse Fourier Transform
%      call rfft1b(n,inc,r,lenr,wsave,lensav,work,lenwrk,ier)
%      
%      777 continue
%      
%      
%      deallocate(re)
%      deallocate(im)
%      deallocate(s)
%      deallocate(fase)
%      deallocate(work)
%      deallocate(wsave)
% end subroutine randomize_phases
% 
% 
% 
% !***********************************************************************
% !Given the autocorrelation of a series (c) obtains the expected
% !autocorrelation of the absolute value of the series if it WERE GAUSSIAN
% !***********************************************************************
% function cmod(c)
%   real*8  cmod,c
%   cmod=(c+2*(dsqrt(1-c**2)-c*dacos(c))/pi-2/pi)/(1.d0-2.d0/pi)
%   !cmod=(c**2-1)/2
% end function cmod
% !***********************************************************************
% 
% !***** not used ***********
% !**************************
% function csign(c)
%   real*8  csign,c
% 
%   csign=2*dasin(c)/pi
% end function csign
% !**************************
% 
% 
% !**************** initializes random number generator ******************
% !**************** using system clock                  ******************
% subroutine init_random_seed()
%     integer::i,n,clock
%     integer,dimension(:),allocatable::seed
% 
%     call random_seed(size=n)
%     allocate(seed(n))
%     call system_clock(count=clock)
%     seed=clock+37*(/ (i-1, i=1, n) /)
%     call random_seed(put=seed)
%     deallocate(seed)
%     return
%     end subroutine init_random_seed    
% !***********************************************************************
% end
%     
