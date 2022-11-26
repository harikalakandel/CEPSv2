function PME=perm_min_entropy(ts,wl,lag)

% ------------------------------------------------------------------------
% Input:
%        ts:  time series
%        wl:  embedding dimension
%        lag: embedding delay
% Output:
%        PME: permutation min-entropy
% Example:%        PME_randn=perm_min_entropy(randn(1000,1),3,1)
% ------------------------------------------------------------------------
% Reference:
% If you use this algorithm please cite the following article:
% 
% Permutation min-entropy: an improved quantifier for unveiling subtle
% temporal correlations, Luciano Zunino, Felipe Olivares and Osvaldo A.
% Rosso, Europhys. Lett. (2015)
%
% Luciano Zunino
% E-mail: lucianoz@ciop.unlp.edu.ar, luciano.zunino@gmail.com
% ------------------------------------------------------------------------

PME=-log(max(prob_indices(ts,wl,lag)))./log(factorial(wl));

function prob_indcs=prob_indices(ts,wl,lag)
m=length(ts)-(wl-1)*lag;
prob_indcs=hist_indices(ts,wl,lag)/m;

function hist_indcs=hist_indices(ts,wl,lag)
indcs=perm_indices(ts,wl,lag);
hist_indcs=hist(indcs,1:1:factorial(wl));

function indcs=perm_indices(ts,wl,lag)
m=length(ts)-(wl-1)*lag;
indcs=zeros(m,1);
for i=1:wl-1;
st=ts(1+(i-1)*lag :m+(i-1)*lag);
for j=i:wl-1;
indcs=indcs+(st>ts(1+j*lag:m+j*lag));
end
indcs=indcs*(wl-i);
end
indcs=indcs + 1;

