function [r,P, SD1, SD2] = extpoinc(A,k) 
% MATLAB function for calculating the extended Poincaré plot indices.
%Inputs: A (a time-series) and 
%k (maximum steps/lags in theextended Poincare’ plot). 
%Outputs: 
%Pearson’s r (r), 
%Pvalue for the correlation coefficient (P), 
%SD1 and 
%SD2.
    n = size (A);
    r = NaN(k,1);
    P = NaN(k,1);
    SD1 = NaN(k,1);
    SD2 = NaN(k,1);
    for i=1:k
        X = A(1:n-i);
        Y = A(i+1:n);
        [cc,p] = corrcoef(X,Y);
        r (i,1) = cc(1,2);
        P (i,1) = p(1,2);
        SD1 (i,1)= std((X - Y)./sqrt(2));
        SD2 (i,1)= std((X + Y)./sqrt(2));
    end
