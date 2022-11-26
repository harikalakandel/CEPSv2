function RPE=Renyi_perm_entropy(ts,wl,lag,q)

% ------------------------------------------------------------------------
% Input:
%         ts: time series
%         wl: embedding dimension
%        lag: embedding delay
%          q: Renyi order
% Output:
%        RPE: Renyi permutation entropy
% Example:
%        RPE_randn=Renyi_perm_entropy(randn(1000,1),3,1,1/2)
% ------------------------------------------------------------------------
% Reference:
% If you use this algorithm please cite the following article:
% 
% Characterization of time series via Rényi complexity–entropy curves, 
% Physica A 498, 74-85, 2018
% https://doi.org/10.1016/j.physa.2018.01.026
%
% Luciano Zunino
% E-mail: lucianoz@ciop.unlp.edu.ar, luciano.zunino@gmail.com
% ------------------------------------------------------------------------

m=length(ts)-(wl-1)*lag;
pk=hist_indices(ts,wl,lag)/m;
pk=pk(pk~=0);
if q~=1
RPE=((1/(1-q))*log(sum(pk.^q)))/log(factorial(wl));
else
RPE=(1./(log(factorial(wl))))*sum(pk.*log(1./pk));   
end
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