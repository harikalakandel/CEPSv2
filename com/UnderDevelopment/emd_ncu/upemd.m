function [imf, fs0, mfvtr] = upemd(sig, numSift, maxPhase0, ampSin0, varargin)
% Copyright National Central University; November, 2021 
% function version 1.2 (upemd Uniform Phase EMD); 2021-1120; % this function calls emd() function
% This version can input sample rate and masking freqency vector, and can directly input typeSpline and toModifyBC
% Reference:
%Yung-Hung Wang, Kun Hu, and Men-Tzung Lo, "Uniform Phase Empirical Mode Decomposition: An Optimal Hybridization of Masking Signal and Ensemble Approaches",IEEE ACCESS July 2018

% Usage: 
% (A) [imf, fs0, mfvtr] = upemd(sig, numSift, maxPhase0, ampSin0);
% (B) [imf, fs0, mfvtr] = upemd(sig, numSift, maxPhase0, ampSin0, fs0, mfvtr, typeSpline, toModifyBC);
%---------------------------------------------------------------
% Input Parameters:
% (1) sig: signal
% (2) numSift: number of sifting iteration: (use fixed sifting number); default = 10
% (3) maxPhase0: maximum number of phases allowed in each IMF (level); default = 8
% (4) ampSin0: un-normalized amplitude of the assisted sinusoids; suggested value 0.1~1.0 It will be normalized later by the standard deviation of the signal or residual
%
%-------------Additional Input Properties-----------------------------------------
% fs == sample rate; default = 1
% mfvtr == masking frequency vector; default = [1/2 1/4 1/8 ...]
% typeSpline: default=2; 1: clamped spline; 2: not a knot spline; 3: natural cubic spline; default 2
% toModifyBC: default=1; 0: None ; 1: modified linear extrapolation; 2: Mirror Boundary; default 1

% Output: IMF (Intrinsic Mode Function) matrix; imf(1,:) == 1st IMF, imf(2,:) = 2nd IMF, ..
%         fs0
%         mfvtr


% typeSpline = 2; %suggest use 2 (Not-a-Knot) or 3 (natural cubic spline);
ndata = size(sig,2);
defaultMaxImf = floor(log2(ndata));    
numImf = defaultMaxImf;


% check input
[sig, numSift, maxPhase0, ampSin0, fs0, mfvtr, typeSpline, toModifyBC,ok]...
= check_input(sig, numSift, maxPhase0, ampSin0, varargin);

if (ok == 0)
   assert(1==0); % input error 
end

given_mfvtr = ~isempty(mfvtr);
if (given_mfvtr == 1)
   numImf = length(mfvtr) + 1;
   for (i=1:numImf-1)
     Tm(i) = round(fs0/mfvtr(i));
     mfvtr(i) = fs0/Tm(i);
   end
else %  default: dyadic frequency distribution
    mfvtr = zeros(1,numImf-1);
    for (i=1:numImf-1)
       Tm(i) = 2^i;
       mfvtr(i) = fs0/Tm(i);
    end
end

res = sig;
for (mode=1:numImf-1)
    ampSin = ampSin0*std(res);
    
    numPhase =  floor(log2(maxPhase0));
    numPhase = 2^numPhase;
    if (numPhase > Tm(mode)) %  numShift  Tm(mode)
        numPhase = min(numPhase,Tm(mode));
    end

    ds = Tm(mode)/numPhase;
 
    [maskArray]=sinusoidalWave(2*ndata,ampSin,Tm(mode)/2); % oversized media pool; will speedup by this phase  rotation
       
    sumWrk = zeros(1,ndata);

    countShift = 0;
    for (shift=1:ds: Tm(mode)) % phase rotating
        mask =  maskArray(round(shift):round(shift)+ndata-1);
        countShift = countShift + 1;
        y = res + mask;      
        
        %[subImf] = emd(y, toModifyBC, typeSpline, 2, numSift); subImf=subImf';
        [subImf] = emd_ncu(y, toModifyBC, typeSpline, 2, numSift); subImf=subImf';
       %    imf = EMD_NCU(xend, toModifyBC, typeSpline, numImf, maxSift);
        subImf(1,:) = subImf(1,:) - mask;
        sumWrk = sumWrk +subImf(1,:);
    end % shift
   
    imf(mode,:) = sumWrk/countShift;
    fprintf(' mode=%d countShift = %d Tm = %6.3f\n',mode,countShift, Tm(mode));
    res = res - imf(mode,:);
end % mode

imf(mode+1,:) = res;
err = abs(sig - sum(imf,1));
assert(max(err) < 1.0e-8); % check the reconstruction error is on the order of machine error

return;
 
function [y]=sinusoidalWave(ndata,a,hp)
% hp == half period
t=0:2*hp-1;
f = 0.5/hp;
yt = cos(2*pi*f*t);
yt = a*yt;

nyt = size(yt,2);
no = ceil(ndata/nyt);

y = repmat(yt,1,no);
y = y(1:ndata);
return;

function [sig, numSift, maxPhase0, ampSin0, fs0, mfvtr, typeSpline, toModifyBC, ok] = check_input(sig, numSift, maxPhase0, ampSin0, varargin)

typeSpline = 2;
toModifyBC = 1;
ok = 1;
fs0 = 1;
mfvtr = [];

if(~isempty(varargin{1}))
for iArg = 1 : length(varargin{1})
    
if(iArg == 1)
    fs0 = varargin{1}{iArg};
    if (fs0 <= 0)
        fprintf('ERROR : zero or negative sample rate fs0=%6.3f\n',fs0);
        ok = 0;
        return;
    end
end
if(iArg == 2)
   mfvtr = varargin{1}{iArg};
   if (size(mfvtr,1) ~= 1 && size(mfvtr,2) ~= 1)
       fprintf('ERROR : wrong masking frequency vector assignment\n');
       ok = 0;
       return;
   end
   vtr = mfvtr;
   vtr = (vtr(:));
   [nmfv b] = size(vtr);
   if ( mfvtr(1)/fs0 > 0.5 + 1.0e-6)
       fprintf('ERROR : 1st masking frequency vector violates Nyquist Limit\n');
       ok = 0;
       return;
   end
   if (nmfv > floor(log2(length(sig))))
       fprintf('ERROR : masking frequency vector element is too much !\n');
       ok = 0;
       return;
   end
   if mfvtr ~= sort(mfvtr,'descend')
       fprintf('ERROR : masking frequency vector is not descending order\n');
       ok = 0;
       return;
   end
   for (i=1:nmfv-1)
        if (mfvtr(i+1) > 0.7*mfvtr(i) || vtr(i) < 0)
            fprintf('ERROR : masking frequency vector element is too close i=%d vtr(i)=%d vtr(i+1) = %d\n',i,mfvtr(i),mfvtr(i+1));
           ok = 0;
           return;
       end
   end
end
if(iArg == 3)
   typeSpline = varargin{1}{iArg};
   if(typeSpline ~= 1 && typeSpline ~= 2 && typeSpline ~= 3)
    fprintf('ERROR : typeSpline must be 1 (clamped spline) or 2 (not a knot spline) or 3 (natural cubic spline).\n');
    ok = 0;
    return;
   end
end
if(iArg == 4)
   toModifyBC = varargin{1}{iArg};
   if(toModifyBC ~= 0 && toModifyBC ~= 1 && toModifyBC ~= 2)
    fprintf('ERROR : runCEEMD must be 0 (None) or 1 (modified linear extrapolation) or 2 (Mirror Boundary).\n');
    ok = 0;
    return;
   end
end

end
end

if (length(sig) < 10)
  fprintf('ERROR : length of signal is less than 10 !!\n');
  ok = 0;
end
if (length(sig) > 10^6)
  fprintf('ERROR : length of signal is greater than 10^6 !!\n');
  ok = 0;
end

if (maxPhase0 < 1)
  fprintf('ERROR : maximum number of phases allowed in each IMF maxPhase0<1\n');
  ok = 0;
end

if (ampSin0 < 0)
  fprintf('ERROR : negative amplitude ampSin0=%6.3f\n',ampSin0);
  ok = 0;
end


return; % check_input

