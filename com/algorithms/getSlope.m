% https://uk.mathworks.com/help/stats/robustfit.html
%% bls = regress(y,[ones(10,1) x])
function [ robustSlope,robustIntercept,regSlope,regIntercept ] = getSlope( data )
    N = size(data,1);
    x = (1:N)';
    bls = regress(data,[ones(N,1),x]);
    regSlope = bls(2);
    regIntercept = bls(1);
    %slope = bls(1,1)+bls(2,1);
    brob = robustfit(x,data);
    %robustSlope = brob(1,1)+brob(2,1);
    robustSlope = brob(2);
    robustIntercept = brob(1);
end

