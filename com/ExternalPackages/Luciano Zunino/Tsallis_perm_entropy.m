function TPE=Tsallis_perm_entropy(ts,wl,lag,q)

% ------------------------------------------------------------------------
% Input:
%         ts: time series
%         wl: embedding dimension
%        lag: embedding delay
%          q: Tsallis order
% Output:
%        TPE: Tsallis permutation entropy
% Example:
%        TPE_randn=Tsallis_perm_entropy(randn(1000,1),3,1,1/2)
% ------------------------------------------------------------------------
% Reference:
% If you use this algorithm please cite the following article:
% 
% Fractional Brownian motion, fractional Gaussian noise, and Tsallis 
% permutation entropy, Physica A 387 (24), 6057-6068, 2008
% https://doi.org/10.1016/j.physa.2008.07.004
%
% Luciano Zunino
% E-mail: lucianoz@ciop.unlp.edu.ar, luciano.zunino@gmail.com
% ------------------------------------------------------------------------

m=length(ts)-(wl-1)*lag;
pk=hist_indices(ts,wl,lag)/m;
pk=pk(pk~=0);
if q~=1
TPE=(1./(Tsallis_log(factorial(wl),q)))*sum(pk.*Tsallis_log(1./pk,q));
else
TPE=(1./(log(factorial(wl))))*sum(pk.*log(1./pk));   
end
end

function output = Tsallis_log(x,q)
output=(x.^(1-q)-1)./(1-q);
end

function hist_indcs=hist_indices(ts,wl,lag)
indcs=perm_indices(ts,wl,lag);
hist_indcs=hist(indcs,1:1:factorial(wl));
end

function indcs=perm_indices(ts,wl,lag)
m=length(ts)-(wl-1)*lag;
indcs=zeros(m,1);
for i=1:wl-1
st=ts(1+(i-1)*lag :m+(i-1)*lag);
for j=i:wl-1
indcs=indcs+(st>ts(1+j*lag:m+j*lag));
end
indcs=indcs*(wl-i);
end
indcs=indcs + 1;
end