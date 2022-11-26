function fd = DistanceFD(data)
% Distance-based fractal dimension. The data sequence is framed into n
% length segments and fractal dimension calculation is performed on the
% basis of these segments.
%
% fd = DistanceFD(data, n)
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
end

% Rejecting complicated arrays
if ndims(data) > 2
    error('2D array or vector ir required for calculation.')
end

% FD calculation
[lines, cols] = size(data);
delta = 1 / (lines-1);
fd = zeros(1,cols);
if lines < 10
    error('Nothing to calculate.')
else
    for i = 1:cols
        dataMaxDist = 0;
        maxValue = data(1,i);
        minValue = data(1,i);
        for j = 1:length(data(:, i))
            if mod(j, 10) == 0
                dataMaxDist = dataMaxDist + 10*sqrt((maxValue - minValue)^2 + delta^2);
                maxValue = data(j,i);
                minValue = data(j,i);
            end
            if data(j,i) > maxValue
                maxValue = data(j,i);
            elseif data(j,i) < minValue
                minValue = data(j,i);
            end
        end
        dataDist = data(:,i) - circshift(data(:,i),1);
        dataDist = sqrt(sum((dataDist(2:end)).^2) + (lines-1)*delta^2);
        fd(i) = 1 + dataDist / dataMaxDist;
    end
end

end