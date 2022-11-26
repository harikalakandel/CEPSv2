%% matlab implementation of Phase entropy
%% Phase entropy: a new complexity measure for heart rate variability
%% Rohila, A. and Sharma, A., 2019. Phase entropy: a new complexity measure for heart rate variability. Physiological Measurement, 40(10), p.105006.
function [PhEn] = getMS_PhEntropy_CGData(data,noSector,scale)

%%Parameters
%% data is N by 1 matrix
%% noSector is an integer



%% number of data points
%N=500;
%%number of sector(k)
k = noSector;

%% 500 random data points are generated......
%g=rand(N,1);
g=data;
N=size(data,1);
%g = ones(N,1);

%% coarse grained in initial data.......

%%dataCS=nan(N/scale,1);
dataCS=nan(floor(N/scale),1);
startIndex=1;
%chkList=[];
%for j=1:N/scale
for j=1:floor(N/scale)    
    endIndex=j*scale;
    startIndex=(j-1)*scale+1;
    dataCS(j,1)=nanmean(data(startIndex:endIndex,1));
    %chkList=[chkList;startIndex endIndex];
end
%chkList

g=dataCS;

N=size(g,1);

%%step 1
% Step 1: From a given time series g[n], we compute Y[n] and X[n] according to (12) and (13), respectively, and
% construct a scatter plot of Y[n] against X[n]:
% Y[n] = g[n + 2] ? g[n + 1] (12)
% X[n] = g[n + 1] ? g[n].

y=g(3:end,1)-g(2:end-1,1);
x=g(2:end-1,1)-g(1:end-2,1);

%%step 2

%{
2. In step 2, please note the function "atan" computes two quadrant inverse tan operation. 
The angle span of slope angles is 0 to 2pi  in an anticlockwise direction from the positive side of the x-axis. 
(Try using "atan2" function with some additional steps.)
%}


% Theta[n] = tan?1 (Y[n]/X[n])
 
theta = atan2(y,x); %%1) abs....(y/x)  y/abs(x)  %% leave like this  %% gives angle between -pi to pi

%%adjustment ???
%% get the span of slope angle between 0 to 2pi
    temp = zeros(size(theta));
    temp(theta<0) = 2*pi;
    theta = theta + temp;
    

% Step 3: We divide the plane into k sectors and obtain the cumulative slope (S) within each sector.

%{
 Step 3, there must be an error in the Matlab translation of the phase entropy algorithm as 
my results are different from these codes. 
(The histogram of slope angles may be utilized for these steps.) 
%}
% S[i] = sum( j from 1 to  M_i Theata[j])
% where i = 1, 2, . . . k, Mi is the number of points in the ith sector.

%%% ??? do we need to sort the 



S_theta = nan(k,1);

angleSpan  = (2*pi)/k;
startAngle  = 0;

for i=1:k
        
        S_theta(i,1)=sum(theta(theta(:,1)>=startAngle & theta(:,1)<startAngle + angleSpan,1));
        startAngle=startAngle+angleSpan;
    %end
    
end

%step 4
%We divide the cumulative sum within each sector (S[i]) by the cumulative slope of the entire plane
%sum(i from 1 to k S_theta[i]), to obtain the probability distribution p(i).
P = S_theta/sum(S_theta);
P = P(P~=0);
%%step 5
%The Shannon entropy computed from p(i) gives the phase entropy as
%% PhEn = ?1/log k sum(i from 1 to k p(i) * log(p(i)))

PhEn = -1/log(k)*sum(P .*log(P));






end
%%

