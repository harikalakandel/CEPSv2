function [S_m] = getBSwapCount(x,m)
% return the series of number of bubble swap count for a dataseries x in respect to embedding dimension m

NN = size(x,2)-m+1;
S_m = nan(1,NN);
for i=1:NN
    S_m(1,i) = countBubbleSwap(x(1,i:i+m-1));
end

end

