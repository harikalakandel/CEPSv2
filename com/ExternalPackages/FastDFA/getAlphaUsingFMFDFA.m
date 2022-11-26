function [aq1,aq2] = getAlphaUsingFMFDFA(signal, q, MinBox, BoxSizeDensity, sliding, LogScaleBoxSize)


if nargin < 1 || isempty(signal)
    error('Need nonempty signal')
end

if nargin < 2 || isempty(q)
    q = 2;
    warning('q set to 2');
end

if nargin < 3 || isempty(MinBox)
    MinBox = 6;
    warning('MinBox set to 6');
end

if nargin < 4 || isempty(BoxSizeDensity)
    BoxSizeDensity = 4;
    warning('BoxSizeDensity set to 4');
elseif  BoxSizeDensity < 1
    BoxSizeDensity = 4;
    warning('BoxSizeDensity set to 4');
end

if nargin < 5 || isempty(sliding)
    sliding = 0;
    warning('sliding set to 0: no overlapping');
elseif  sliding < 0
    sliding = 0;
    warning('sliding set to 0: no overlapping');
end

if nargin < 6 || isempty(LogScaleBoxSize)
    LogScaleBoxSize = 1;
    warning('LogScaleBoxSize set to 1');
end

%DFA1 and DFA2 calculation
%[bs, Fq1, Fq2] = FMFDFA(signal, -5:1:5, 6, 4, 0)
 [bs, Fq1, Fq2] = FMFDFA(signal,q, MinBox, BoxSizeDensity, sliding, LogScaleBoxSize);

%Local slope for DFA1
[aq1, bse1, Fqe1] = slpMFMSDFA(bs, Fq1);

%Local slope for DFA2
[aq2, bse2, Fqe2] = slpMFMSDFA(bs, Fq2);


end

