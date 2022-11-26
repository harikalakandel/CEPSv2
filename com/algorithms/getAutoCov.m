%% based on https://www.mathstat.dal.ca/~stat5390/Section_3_ACF.pdf
%% autoCov(x) = cov(Xn+k,Xn)
%% consider k = 1
%%autoCov(x) = cov(Xn+1,Xn) ???
function [ autoCov ] = getAutoCov( data,lagK )

    %% by default k, 
    if(nargin==1)
        lagK=1;
    end
    
    %% lagK can not be greate than the data size
    if lagK >= size(data,1)
         error('Lag parameter cannot be greate than or equal to the datasize itself.');
    end
    
    autoCov  = cov(data(lagK+1:end,1),data(1:end-lagK,1));
    autoCov = autoCov(1,1);
end

