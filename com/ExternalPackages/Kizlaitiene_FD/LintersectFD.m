function fd = LintersectFD(data)
% Data sequence and its linear approximation intersection-based fractal
% dimension.
%
% fd = LintersectFD(data)
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
fd = zeros(1,cols);
if lines < 3
    error('Nothing to calculate.')
else
    for i = 1:cols
        datax = (0:lines-1)';
        la = polyfit(datax, data(:,i), 1);
        data2 = la(1).*datax + la(2);
        inters = sum(abs(diff(sign(data(:,i)-data2)))>0);
        fd(i) = 1 + inters / (lines - 1);
    end

end
