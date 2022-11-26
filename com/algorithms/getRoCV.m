%    Robust CV (RCoV) = median absolute deviation from the median (MADM) / median
%    MADM = median (|xi- median(x)|) 
function [ rcov ] = getRoCV( data )
    medianX = median(data);
    rcov = (median(abs(data - ones(size(data,1),1)*medianX))*1.4826)./median(data);
end