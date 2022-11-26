function [count,boxsize,fractdim] = getBoxCount_FMoisy(data)
    % get nubmer of box and size of box from F Moisy boxCount function
    [count,boxsize,s]=boxcount(data,'slope');
    % use polyfit method to calculate fractal Dimension.. (using Gwendolyn
    % method of calculating FD using polyfit
   
    p=polyfit(log(boxsize), log(count), 1);
    fractdim=-p(1);
end

