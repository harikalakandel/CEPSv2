function fd = DistanceFD(data, n)
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
%   n - the length of the segment. If no value is defined, the 'n'  value
%   is equated to the length of the analyzed data sequence.
% 
%---------------------------------------------------------------------------------------
% Ieva K., Gintautas T., VU MIF, 2022

if nargin == 0
    % Rejecting empty argument case
    error('No input arguments.')
elseif nargin == 1
        n = size(data, 1);
end

% Rejecting complicated arrays
if ndims(data) > 2
    error('2D array or vector ir required for calculation.')
end

% FD calculation
[lines, cols] = size(data);
fd = zeros(1,cols);
if lines < n
    error('Nothing to calculate.')
else
    for i = 1:cols
        dataDist = data(:,i) - circshift(data(:,i),1);
        dataDist = sqrt(sum((dataDist(2:end)).^2) + (n-1));
        dataFrames = buffer(data(:,i), n, 0, 'nodelay');
        dataDists = sum(size(dataFrames,2) * sqrt((max(dataFrames) - min(dataFrames)).^2 + 1));
        fd(i) = 1 + dataDist / dataDists;
    end
end

end