
% % !********************************************************************
% % !*********  Calculates the correlation of the absolute value  *******
% % !*********  and obtains the difference with the gaussian      *******
% % !********************************************************************
% % !x-> array with data (IN)
% % !n-> length of the array (IN)
% % !Lmax -> maximum lag to compute correlations (IN)
% % !distm -> array with the diferences in the absolute value correlations
% %
% % !         and the gaussian for each lag (OUT)
% % !**********************************************************************
% subroutine getcorrtot(x,n,Lmax,distm,surrogate,distm0)
function []=getcorrtot(x,n,Lmax,distm,surrogate,distm0)
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

%      !array for the absolute values of the series
%      allocate(xm(n))
xm(1:n)=abs(x(1:n))
%      !means of the series and absolute value series
mu=sum(x(1:n))/n
mum=sum(xm(1:n))/n

%      !normalization factor needed for the calculation
%      !of the autocorrelation
%      norm=sum(x(1:n)**2)-n*mu**2
norm=sum(x(1:n)^2)-n*mu^2
%      normm=sum(xm(1:n)**2)-n*mum**2
normm=sum(xm(1:n)^2)-n*mum^2

%      !Loop in the lags
%      do L=1,Lmax
for L=1:max
    corr=0
    corrm=0
    %       !Loop in the values of the series
    %        do i=1,n-L
    %          j=i+L
    %          corr=corr+(x(i)-mu)*(x(j)-mu)
    %          corrm=corrm+(xm(i)-mum)*(xm(j)-mum)
    %        enddo
    %        corr=corr/norm
    %        corrm=corrm/normm
    for i=1:n-L
        j=i+L
        corr=corr+(x(i)-mu)*(x(j)-mu)
        corrm=corrm+(xm(i)-mum)*(xm(j)-mum)
    end
    corr=corr/norm
    corrm=corrm/normm
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
    if NO_SQUARE
        distm(L)=corrm-cmod(corr)
    else
        distm(L)=(corrm-cmod(corr))^2
    end
    
    
    %        !write(0,'(i,3f12.8)') L,corr,corrm,distm(L)
    
    
    %        !++++++++++++++++++++++++++++++++++++++++++
    %        if (L==Lmax) then
    if L==Lmax
        %          if (surrogate==0) then
        if (surrogate==0)
            %             write(*,*) 'Series length: ',n
            %             write(*,*) 'Lag:           ',Lmax
            %             write(*,'(a6,a,10(a10,a))') "      ",char(9),"   Corr.  ",char(9)," Corr.mod ", &
            %                                       char(9)," Corr.Gaus",char(9),"    D     "
            %             write(*,*) '------------------------------------------------------------------'
            %             write(*,'(a6,a,10(f10.7,a))') "      ",char(9),corr,char(9),&
            %                   corrm,char(9),cmod(corr),char(9),distm(Lmax)
        else
            %              if (distm0(Lmax)<=distm(Lmax)) then
            %                 menor = '   yes    '
            %                 COUNTER=COUNTER+1
            %              else
            %                 menor = '    no    '
            %              endif
            if distm0(Lmax)<=distm(Lmax)
                menor = '   yes    '
                COUNTER=COUNTER+1
            else
                menor = '    no    '
                
            end
            % write(*,'(i6,a,4(f10.7,a),a10,a,i6a)') surrogate,char(9),corr,char(9),&
            %      corrm,char(9),cmod(corr),char(9),distm(Lmax),char(9),menor,char(9),COUNTER
            %            endif
            %         endif
        end
    end
    %       !++++++++++++++++++++++++++++++++++++++++++
    
    %     enddo
end
%???????
%     deallocate(xm)
%  end subroutine getcorrtot
end
%!************************************************************************

