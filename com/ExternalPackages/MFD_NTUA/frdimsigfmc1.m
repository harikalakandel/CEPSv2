function	[d,a] = frdimsigfmc1(x,varargin) 
%FRDIMSIGFMC1 Fractal dimension of 1D  signal  via flat morph. covers.
% D=FRDIMSIGFMC1(X,'maxscale',M) computes the fractal dimension of the 1D 
% real signal array X by computing multiscale flat dilations and erosions
% of X over scales r=1,...M, measuring the area  of the difference
% among these dilations and erosions, and fitting a straight line over
% these multiscale area  data over a log-log plot. 
% D is the slope of this least-squares line fit.
% Str. Element for dilation/erosion= symmetric 3-sample flat line segment. 
% Required length of signal for reliable results:	 length(X) >> 2*M+1.
%
% [D,A]=FRDIMSIGFMC1(X,'maxscale',M) also provides as output the array A[r],
% r=1,...,M, of multiscale area mesurements.
% 
% D=FRDIMSIGFMC1(X,'maxscale',M,'window',W) computes a "multiscale fractal 
% dimension" of X by locally computing the slope of the log-log plot over 
% sequentially advancing scale windows of length W <= M.
% D[r] is the array of multiscale fractal dimensions for r=1,...,(M-W+1).
% In general, 2 <= W <= M. If M and W are not given, M=W=5 is assumed.
% If M or W is given but with wrong value(s), a correct default pair (W,M) is chosen.
%
% READING to understand the theory behind this algorithm:
% P. Maragos, "Fractal Signal Analysis Using Mathematical Morphology'', in 
% Advances in Electronics and Electron Physics, vol.88, edited by P. Hawkes & B. Kazan,
% Academic Press, 1994, pp.199--246.

% Author: P. Maragos
% v.	1.1:	12 Mar 1998 
%		1.2: 	25 May 2001, Add checks for values of M,W. Separate it from its 2D version.
%-------------------------------------------------------------------------------------
%	Check Values & Dimensions of Signal X
if nargin < 1, error('not enough input arguments'), end
if mod(length(varargin),2) ~= 0
   error('arguments in varargin must come in pairs')
end                    
if isempty(x), d=0;, a=[];, return, end
if ~isnumeric(x) | ~isreal(x), error('signal is not numeric or not real'), end
if length(size(x)) > 2, error('M-dim signal, M>2'), end
[xr,xc] = size(x); if min(xr,xc) > 1, error('Signal is 2D'), end
if length(x) < 3, error('Length of 1D signal < 3'), end
if any(~isfinite(x)), error('1D signal is not finite-valued'), end

%  Find the maxscale (M) and window (W) parameter.
specwindow = 0; specmaxsc = 0;
if length(varargin) > 1 	% if either M or W is specified
   % Find & check value of scale window length W
   for k=1:length(varargin)-1 % check if 'window' is set in varargin
       if strcmp(varargin{k},'window')
          W=varargin{k+1};
          if length(W) ~= 1, error('window_length must be scalar'), end
          if ~isnumeric(W) | ~isreal(W) | ~isfinite(W)
             error('window_length is not numeric or not real or infinite')
          end
          W = floor(W);  specwindow = 1;
          break
       end
   end
   % Find value of maxscale M
   for k=1:length(varargin)-1 % check if 'maxscale' is set in varargin
       if strcmp(varargin{k},'maxscale')
          M=varargin{k+1};
          if length(M) ~= 1, error('maxscale must be scalar'), end
          if ~isnumeric(M) | ~isreal(M) | ~isfinite(M)
             error('maxscale is not numeric or not real or infinite')
          end
          M = floor(M);  specmaxsc = 1;
          break
       end
    end
 end
 %	Check & Correct values of M and W
 if specmaxsc==0 & specwindow==0	% if neither M nor W are speficied
    M = 5; W = 5; % default choice
 elseif specmaxsc==1 & specwindow==0	% if M is specified, but W is not
    if M < 2, warning('Specified Maxscale<2. Set M=W=5'), M=5; W=5;, end
    W = min(5,M);
 elseif specmaxsc==0 & specwindow==1	% if W is specified, but M is not
    if W < 2, warning('Specified Window<2. Set W=M=2'), W=5;, end
    M = W;
 else											% if both M and W are specified
    if W > M | W < 2		% wrong combination
       warning('scale_window_length must be <= maxscale & >= 2')
       if W < 2 & M >= W, disp('Set W=M'), W=M;, end
       if W >= 2 & M < W, disp('Set M=W'), M=W;, end
       if W < 2 & M < W, disp('Set M=W=5'), M=5;, W=5;, end
    end
 end
 
% Check whether signal is constant
if all(all(x == x(1)))
   disp('constant signal')
   d = ones(M-W+1,1);
   a = zeros(M,1);
   return
end

%	Compute Areas at multiple scales
a = zeros(M,1);
g = zeros(1,3);
gcen = [1,2];
x = (x(:))';   % make it a row signal
dl = x; er = x;
% figure;
for r = 1 : M
   dl = dilation1(dl,g,gcen,-Inf);  
   er = erosion1(er,g,gcen,+Inf);   
   a(r) = sum(dl - er);             
end   

% Least-Squares Fit of Line(s) to Estimate Slope(s)=T+1-D
%      of Log[AreaVol(scale)] vs Log(scale),  where
% T=topological dimension of signal (T=1,2) and D=fr.dim.
d = zeros(M-W+1,1);
scale = (1:M)';	% column vector
logscale = log(scale);
logarea = log(a);
A = ones(W,2);
b = zeros(W,1);

for r = 1 : M-W+1
   A(1:W,2) = logscale(r:r+W-1);
   b = logarea(r:r+W-1);
   y = A\b;
   d(r) = y(2);	% y(2)=slope
end

d = 2 - d;


% ************** Supporting M-functions **********************

function y = dilation1(x,g,gcen,bval)
%DILATION1 1D fixed-support dilation of signal vector by SE vector.
% Y=DILATION1(X,G,GCEN,BVAL) is the fixed-support dilation
% of 1D signal vector X by the SE vector G. Size(Y)=Size(X).
% GCEN is 2-pt vector with indexes of desired center of G.
% BVAL is the desired value for all needed signal boundaries.
% No checking of validity of values/dimensions of X or G.
% The supports of X and G are assumed non-empty.

% P. Maragos -- 22 Jan. 1997 (Rename it "Dilation": 9 dec 1999)
%------------------------------------------------------
if nargin ~= 4, error('Needs 4 input arguments'), end
z = find(~isnan(g));
gcard = length(z);
gcen1 = max(gcen);
if all(g == 0 | isnan(g))		% Flat SE
   for n=1:gcard
      rs = z(n)-gcen1;	% right shift
      if n == 1
         y = shift1(x,rs,bval);
      else
         y = max(y,shift1(x,rs,bval));
	  end
   end
else				% Non-Flat SE
   for n=1:gcard
      rs = z(n)-gcen1;	% right shift
      if n == 1
         y = shift1(x,rs,bval) + g(z(n));
      else
         y = max(y , shift1(x,rs,bval)+g(z(n)));
      end
   end
end

%***********************************************************

function y = erosion1(x,g,gcen,bval)
%EROSION1 1D fixed-support erosion of signal vector by SE vector.
% Y=EROSION1(X,G,GCEN,BVAL) is the fixed-support erosion
% of 1D signal vector X by the SE vector G. Size(Y)=Size(X).
% GCEN is 2-pt vector with indexes of desired center of G.
% BVAL is the desired value for all needed signal boundaries.
% No checking of validity of values/dimensions of X or G.
% The supports of X and G are assumed non-empty.

% P. Maragos -- 22 Jan. 1997 (rename it "erosion": 9 dec 1999)
%------------------------------------------------------
if nargin ~= 4, error('Needs 4 input arguments'), end
z = find(~isnan(g));
gcard = length(z);
gcen1 = max(gcen);
if all(g == 0 | isnan(g))		% Flat SE
   for n=1:gcard
      ls = gcen1-z(n);	% left shift
      if n == 1
         y = shift1(x,ls,bval);
      else
         y = min(y,shift1(x,ls,bval));
      end
   end
else				% Non-Flat SE
   for n=1:gcard
      ls = gcen1-z(n);	% left shift
      if n == 1
         y = shift1(x,ls,bval) - g(z(n));
      else
         y = min(y , shift1(x,ls,bval)-g(z(n)));
      end
   end
end

%*********************************************************

function y = shift1(x,k,bval)
%SHIFT1 Shifts a 1D signal vector right or left.
% Y=SHIFT1(X,K,BVAL) is the shifted version of the
% 1D vector X by abs(K) samples.
% Shift right if K > 0, left if K < 0. 
% Y(n) = X(n-K).
% BVAL is boundary value replacing the shifted-out samples.

%	P. Maragos -- 22 Jan. 1997
%------------------------------------------------
%
if k == 0		% No shift
	y = x;
	return
end
%
[xr,L] = size(x);
if k > 0		% Right shift
	y = [ones(1,k)*bval x(1:L-k)];
	return
end
if k < 0		% Left shift
	y = [x(1-k:L) ones(1,-k)*bval];
	return
end

%********************************************************
