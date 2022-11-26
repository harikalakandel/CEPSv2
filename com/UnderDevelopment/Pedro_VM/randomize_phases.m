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
%subroutine randomize_phases(r,n,shuffle)
function[a]=randomize_phases(r,n,shuffle)
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
     
     !******************************************************
   
     pi=datan(1.d0)*4
     pi2=2*pi
     sqrt2=dsqrt(2.d0)
    
%      !*****************************************************************  
%      !initialize variables for routine rfft1f
     lensav=n+int(log(real(n))/log(2.d0))+4 +1 %!el último 1 es por si acaso
     inc=1
     lenr=n
     lenwrk=n
     %% ?????????????
     allocate(wsave(lensav))
     allocate(work(lenwrk))
     %% ?????????
     %%call rfft1i(n,wsave,lensav,ier)
    
     %?????
     %!call to FFT
     %?????????
     %call rfft1f(n,inc,r,lenr,wsave,lensav,work,lenwrk,ier)
     %!*******************************************************************
     %????????????????
%      allocate(re(n/2+1))
%      allocate(im(n/2+1))
%      allocate(s(n/2+1))
%      allocate(fase(n/2+1))
     
%      !obtains the phases and changes them by random numbers or shuffle,
%      !depending on flag 'shuffle'
     
%      do i=1,n/2-1
%        re(i)=r(2*i)
%        im(i)=r(2*i+1)
%      enddo
    for i=1:n/2-1
         re(i)=r(2*i)
        im(i)=r(2*i+1
    end
    
    if (shuffle) then
  
%        do i=1,n/2-1
%          s(i)=dsqrt(re(i)**2+im(i)**2)  !no se toca
%          fase(i)=dasin(im(i)/s(i))
%          if (re(i)<0) fase(i)=pi-fase(i)
%        enddo
        for i=1:n/2-1
            s(i)=dsqrt(re(i)^2+im(i)^2)
            fase(i)=dasin(im(i)/s(i))
            if (re(i)<0) 
                fase(i)=pi-fase(i)
            end
        end
%        do i=n/2-1,1,-1
%          call random_number(u)
%          ii=u*i+1
%          inter=fase(i)
%          fase(i)=fase(ii)
%          fase(ii)=inter
%        enddo
        for i=n/2-1:-1:1
           % ?????
           %  call random_number(u) 
           ii=u*i+1
           inter=fase(i)
           fase(i)=fase(ii)
           fase(ii)=inter
        end
     else
%        do i=1,n/2-1
%          s(i)=dsqrt(re(i)**2+im(i)**2)
%          call random_number(u)
%          fase(i)=pi2*(u-0.5d0)  
%        enddo
        for i=1:n/2-1
            s(i)=dsqrt(re(i)^2+im(i)^2)
            %% ????
            %% call random_number(u)
            fase(i)=pi2*(u-0.5d0)
            
        end
    %% endif
    end

%      do i=1,n/2-1
%         r(2*i)=s(i)*dcos(fase(i))
%         r(2*i+1)=s(i)*dsin(fase(i))
%      enddo
     for i=1:n/2-1
          r(2*i)=s(i)*dcos(fase(i))
          r(2*i+1)=s(i)*dsin(fase(i))
     end
     %!call to inverse Fourier Transform
     %%???
     %call rfft1b(n,inc,r,lenr,wsave,lensav,work,lenwrk,ier)
     
     %%????
     %%777 continue
     
%      ????????????     
%      deallocate(re)
%      deallocate(im)
%      deallocate(s)
%      deallocate(fase)
%      deallocate(work)
%      deallocate(wsave)
%%end subroutine randomize_phases
end

