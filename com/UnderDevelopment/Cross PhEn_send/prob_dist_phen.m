function [ P ] = prob_dist_phen( data, k, tau )
% This function is being used inside the function calculating cross PhEn.
%   Detailed explanation goes here
%%
if size(data,1) >1
    error('input data must be a row vector');
end

if nargin<3
    tau = 1;
end

%%

N=size(data,1);
data = (data-mean(data))/std(data);
    
x0 = data(1:end-tau);
x1 = data(tau+1:end);

    X = diff(x0);
    Y = diff(x1);

    slope = atan2(Y,X);

    temp = zeros(size(slope));
    temp(slope<0) = 2*pi;
    theta = slope + temp;
    
    
S_theta = nan(k,1);

angleSpan  = (2*pi)/k;
startAngle  = 0;

for i=1:k
        
        S_theta(i)=sum(theta(theta>=startAngle & theta<startAngle + angleSpan));
        startAngle=startAngle+angleSpan;
    %end
    
end
P = S_theta/sum(S_theta);
P = P(P~=0);

end

