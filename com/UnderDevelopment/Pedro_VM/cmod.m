% !***********************************************************************
% !Given the autocorrelation of a series (c) obtains the expected
% !autocorrelation of the absolute value of the series if it WERE GAUSSIAN
% !***********************************************************************
%function cmod(c)
function[retVal]= cmod(c)
  %real*8  cmod,c
  %cmod=(c+2*(dsqrt(1-c**2)-c*dacos(c))/pi-2/pi)/(1.d0-2.d0/pi)
  retVal=(c+2*(sqrt(1-c^2)-c*acos(c))/pi-2/pi)/(1.d0-2.d0/pi)
  %!cmod=(c**2-1)/2
  %% ???? not sure 
  %~retVal = (c^2-1)/2;
%end function cmod
end
