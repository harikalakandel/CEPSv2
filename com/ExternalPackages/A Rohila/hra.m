function [ cUP, cDN ] = hra( data )

    x = data(:);
    
    x0 = x(1:end-1);
    x1 = x(2:end); 
    
    L = length(x1);
        
    SD1I = sqrt((1/L)*(sum((x1-x0).^2)/2));
        
    xy = (x1-x0)/sqrt(2); 
        
    SD1UP = sqrt(sum(xy(xy > 0).^2)/L); 
    SD1DN = sqrt(sum(xy(xy < 0).^2)/L); 
        
    cUP = SD1UP^2/SD1I^2;
    cDN = SD1DN^2/SD1I^2;

end

