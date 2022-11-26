%% implementation of fractal Dimension from
%% An algorimth for computing the fractal dimension of waveforms
%% P.Paramanathan, R. Uthayakurma

%r is described in shelberg method, so no roll in our algorithm
function [ L ] = getPP_FD( x,m,r)

    %% length of the data sequence x
    N = size(x,1);
    %% step 2
    %% half of the average distance between the points 
     %%(you must use floor)
    k = floor(mean(abs(x(1:m,1)-x(2:m+1,1))));
    kMin = floor(k/2);
    
    %% we define NrC to be the maximum number of points x0,x1,.....xm on the curve C, in 
    %% that order, such that abs(x_k-x_k-1) = r.
    NkC = sum(abs(x(1:k,1)-x(2:k+1,1))==0);
    kMax = (NkC-1)*k*0.5;
    
    
    L = nan(k,1)
    
    for kk=1:k
        upperLim = floor((N-m)/k);
        
        %% from equation 9
        %4) Since r is the distance between the two datapoints, I am confuse, why  abs(x[k]-x[k-1]) = r 
        %is set to calculate NrC (max. number of points ..). I suspect this should be

         %   abs(x[k]-x[k-1]) >= r.(distance quantity should be taken as positive, so you must use abs)
        LmK = (sum(abs(x(m:kk:upperLim,1) - x(m-1:kk:upperLim-1)))*(N-1))/(upperLim*k);
        %% equation 10
        if kk ==1 
            L(kk,1)=LmK;
        else
            L(kk,1)=L(kk-1,1)+LmK;
        end
    end
    

end

