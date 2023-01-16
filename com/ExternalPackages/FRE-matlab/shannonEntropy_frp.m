function E = shannonEntropy_frp(x,dim,tau,cluster)

%{
----------------------------------------------------------------------------------------
Computing Shannon entropy of a fuzzy recurernce plot of time series x 
----------------------------------------------------------------------------------------
%}


% Compute FRP
F = frp(x,dim,tau,cluster);
F = 1-F; % use actual fuzzy membership
% Compute Shannon entropy
S = F.*log2(F);
S(isnan(S))=0;
E  = -sum(S,'all');








