function PE=perm_entropy(ts,wl,lag)

% -------------------------------------------------------------------------
% Input:
%         ts: time series
%         wl: embedding dimension
%        lag: embedding delay
% Output:
%         PE: permutation entropy
% Example:
%         PE_randn=perm_entropy(randn(1000,1),3,1)
% ------------------------------------------------------------------------
% Reference:
% If you use this algorithm please cite the following article:
% 
% Distinguishing chaotic and stochastic dynamics from time series by using 
% a multiscale symbolic approach, Phys. Rev. E 86 (4), 046210, 2012
% https://doi.org/10.1103/PhysRevE.86.046210
%
% Luciano Zunino
% E-mail: lucianoz@ciop.unlp.edu.ar, luciano.zunino@gmail.com
% ------------------------------------------------------------------------

m=length(ts)-(wl-1)*lag;
pk=hist_indices(ts,wl,lag)/m;
pk=pk(pk~=0);
PE=-dot(pk,log(pk))/log(factorial(wl));
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