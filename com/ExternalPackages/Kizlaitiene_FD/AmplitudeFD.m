function fd = AmplitudeFD(data, mind, maxd)
% Amplitude variation-based fractal dimension.
%
% fd = AmplitudeFD(data, mind, maxd)
% Output:
%   fd - the calculated fractal dimension value.
% Input:
%   data - input data. If 'data' is a column vector, the function returns the
%   calculated fractal dimension value. If 'data' is a matrix, the columns are
%   treated as column vectors and the function returns fractal dimension
%   value for each column.
%   mind - minimum possible data value. If no value provided, the actual
%   minimum data value is used.
%   maxd - maximum possible data value. If no value provided, the actual
%   maximum data value is used.
% 
%---------------------------------------------------------------------------------------
% Ieva K., Gintautas T., VU MIF, 2022

if nargin == 0
    % Rejecting empty argument case
    error('No input arguments.')
else
    % Defining all missing arguments
    if nargin == 1
        mind = min(min(data));
        maxd = max(max(data));
    elseif nargin == 2
        maxd = max(max(data));
    end
    
    % Rejecting complicated arrays
    if ndims(data) > 2
        error('2D array or vector ir required for calculation.')
    end
    
    % FD calculation
    [lines, cols] = size(data);
    if lines == 1
        error('Nothing to calculate.')
    else
        sumMaxDiff = (lines - 1) * (maxd - mind);
        fd = zeros(1,cols);
        for j = 1:cols
            sumDiff = data(:,j) - circshift(data(:,j),1);
            sumDiff = sum(abs(sumDiff(2:end))); 
            fd(j) = 1 + sumDiff/sumMaxDiff;
        end
    end
end

end

