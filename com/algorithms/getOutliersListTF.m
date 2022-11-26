%%remove any outliers as suggested by Tukey fences
%% input x: time series of length Nx1
function [ OutlierList ] = getOutliersListTF( x )

%     %% first quantiles
%     q1 = quantile(x,0.25);
%     %% third quantiles
%     q3 = quantile(x,0.75);
%     k=1.5;
%     
%     lowerR = q1 - k *(q3-q1);
%     upperR = q3 + k *(q3-q1);
%     
    % Tukey's upper fence
    %tuf = q3 - q1;
    
    % Tukey's lower fence
    %tlf = q1 - q3;
    % removing outliers using Tukey's fence
    %OutlierList = find((x>=repmat(tlf,size(x,1),1) &  x<= repmat(tuf,size(x,1),1) )==0);
    
    
    % compute the median
    medianx = median(x);

    % STEP 1 - rank the data
    y = sort(x);

    % compute 25th percentile (first quartile)
    q1 = median(y(find(y<median(y))));

   

    % compute 75th percentile (third quartile)
    q3 = median(y(find(y>median(y))));



     k=1.5;
     
     lowerR = q1 - k *(q3-q1);
     upperR = q3 + k *(q3-q1);



    OutlierList = find(x< lowerR |  x> upperR);

end



%%%



%     Lower inner fence: Q1 – (1.5 * IQR)
%     Upper inner fence: Q3 + (1.5 * IQR)
%     Lower outer fence: Q1 – (3 * IQR)
%     upper outer fence: Q3 + (3 * IQR)