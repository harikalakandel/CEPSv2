function [blockmax] = blockmaxima(x,blocklength)
    if length(x)<blocklength;
        blockmax=NaN;
        warning('Series shorter than block sizes')
    else
       nblock=fix(length(x)/blocklength);
       blockmax=ones(nblock,1);
        for k=1:nblock
            blockmax(k)=max( x(((k-1)*blocklength+1):(k*blocklength)));
        end
    end
end