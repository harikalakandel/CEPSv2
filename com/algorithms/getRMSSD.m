function [rmssd] = getRMSSD(RR)
    N = size(RR,1);
    diff =  RR(2:end,:)-RR(1:end-1,:);  %% x_n+1 - xn
    diffSqr = diff.^2; 
    rmssd = (sum(diffSqr,1)/(N-1)).^(0.5)
end

