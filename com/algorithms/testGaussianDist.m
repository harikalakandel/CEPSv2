% kstest 
% 
% Single sample Kolmogorov-Smirnov goodness-of-fit hypothesis test.
%     H = kstest(X) performs a Kolmogorov-Smirnov (K-S) test to determine if  a random sample X could have come from a standard normal distribution, N(0,1). 
% H indicates the result of the hypothesis test:
%        H = 0 => Do not reject the null hypothesis at the 5% significance  level. 
%        H = 1 => Reject the null hypothesis at the 5% significance level.
% 
% Therefore, X should be normalized to z-score.
function [ h ] = testGaussianDist( data )
    %data = zscore(data);
    h = kstest(data);
end

