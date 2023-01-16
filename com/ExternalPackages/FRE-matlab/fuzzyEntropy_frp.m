function E = fuzzyEntropy_frp(x,dim,tau,cluster)

%{
----------------------------------------------------------------------------------------
Computing fuzzy entropy of a fuzzy recurernce plot of time series x 
----------------------------------------------------------------------------------------
%}


% Compute FRP
F = frp(x,dim,tau,cluster);
F = 1-F; % use actual fuzzy membership
S1 = F.*log2(F);
S2 = (1-F).*log2(1-F);
S1(isnan(S1))=0;
S2(isnan(S2))=0;
E  = -sum(S1+S2,'all');








