function [p,a0,ak] = mesa(x,m,nfreq)
% MESA - Maximum Entropy Spectral Analysis
% SYNTAX: p = mesa(x,m,nfreq);
% For a vector x, this function calculates a maximum-entropy spectrum
% of order m. The spectral estimate is returned in the vector p, which
% has nfreq points linearly spaced in the Nyquist frequency interval 0-.5.
% The psd is normalized such that the mean square value of x equals the
% sum of p. Mesa is based on the Burg algorithm, as described in Numerical
% Recipes and implemented in their memcof and evlmem subroutines.
%
% Written by Eric Breitenberger        Version 1/1/96 
% Please send comments and suggestions to eric@gi.alaska.edu 

%%(C)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C)Jeffrey Hall Lab, Brandeis University.             %%
% Use and distribution of this software is free for academic      %%
% purposes only, provided this copyright notice is not removed.   %%
% Not for commercial use.                                         %%
% Unless by explicit permission from the copyright holder.        %%
% Mailing address:                                                %%
% Jeff Hall Lab, Kalman Bldg, Brandeis Univ, Waltham MA 02454 USA %%
% Email: hall@brandeis.edu                                        %%
%%(C)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if min(size(x))>1, error('Row or column vectors only!'), end
[n,c]=size(x);
if c>n, x=x'; n=c; end  % x is now a column vector of size n
x=x-mean(x);  % center the series

% set up workspace column vectors and initialize:
wkm=zeros(m,1);
ak=zeros(m,1);
a0=sum(x.^2)/n;
wk1=x(1:n-1);
wk2=x(2:n);

% Now calculate a0 and ak via recursion.
% Ugly, ugly code - could be improved.
for k=1:m
  ind=1:n-k;
  ind2=1:n-k-1;
  indk=1:k;
  indk2=(1:k-1)';
  pneum=wk1.*wk2;
  denom=wk1.^2+wk2.^2;
  ak(k)=2.*sum(pneum(ind))/sum(denom(ind));
  a0=a0*(1.-ak(k).^2);
  if k>1 
    ak(indk2)=wkm(indk2)-ak(k)*wkm(k-1:-1:1);
  end
  if k==m, break, end
  wkm(indk)=ak(indk);
  wk3=wk1;
  wk1(ind2)=wk1(ind2)-wkm(k)*wk2(ind2);
  wk2(ind2)=wk2(ind2+1)-wkm(k)*wk3(ind2+1);
end

% The coefficients a0 and ak have been calculated, now use these
% to evaluate the psd at nfreq frequencies (eqn. 12.8.4 Num. Rec.).
% By changing how p is initialized, the spacing in f can be changed.
% For example, one could use logspace instead of linspace.

p=2*pi*linspace(0,.5,nfreq);
fc=cos(p);
fs=sin(p);
lc=ones(1,nfreq);     % initialize 'last' cosine and sine
ls=zeros(1,nfreq);
temp=zeros(1,nfreq);
sc=ones(1,nfreq);     % initialize sum of cosine and sine terms
ss=zeros(1,nfreq);

% This next loop can be vectorized but memory use goes way up for only 
% a small improvement in speed.
for k=1:m
  temp=lc;
  lc=lc.*fc - ls.*fs;
  ls=ls.*fc + temp.*fs;
  sc=sc-ak(k).*lc;
  ss=ss-ak(k).*ls;
end
p=a0./(sc.^2 + ss.^2);
% ----------------------- end mesa.m ----------------------------------

