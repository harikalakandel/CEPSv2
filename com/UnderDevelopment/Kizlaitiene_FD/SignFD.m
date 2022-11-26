function fd = SignFD(data)
% Number of minimal and maximal data values based fractal dimension.
%
% fd = SignFD(data)
% Output:
%   fd - the calculated fractal dimension value.
% Input:
%   data - input data. If 'data' is a column vector, the function returns the
%   calculated fractal dimension value. If 'data' is a matrix, the columns are
%   treated as column vectors and the function returns fractal dimension
%   value for each column.
% 
%---------------------------------------------------------------------------------------
% Ieva K., Gintautas T., VU MIF, 2022

if nargin == 0
    % Rejecting empty argument case
    error('No input arguments.')
else
    % Rejecting complicated arrays
    if ndims(data) > 2
        error('2D array or vector ir required for calculation.')
    end
    [lines, cols] = size(data);
    if (lines == 1) || (lines == 2)
        error('Nothing to calculate.')
    else
        % FD calculation
        maxExtr = lines - 2;
        fd = zeros(1,cols);
        for j = 1:cols
            numExtr = sum(islocalmax(data(:,j))) + sum(islocalmin(data(:,j)));
            fd(j) = 1 + numExtr / maxExtr;
        end
    end
end

end