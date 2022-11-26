function fd = PintersectFD(data, order)
% Data sequence and its polynomial approximation intersection-based fractal
% dimension.
%
% fd = PintersectFD(data)
% Output:
%   fd - the calculated fractal dimension value.
% Input:
%   data - input data. If 'data' is a column vector, the function returns the
%   calculated fractal dimension value. If 'data' is a matrix, the columns are
%   treated as column vectors and the function returns fractal dimension
%   value for each column.
%   order - maximal polynomial order for approximation. If not specified, 
%   the 18th order approximation is used (as defined by the author).
%
%---------------------------------------------------------------------------------------
% Ieva K., Gintautas T., VU MIF, 2022

if nargin == 0
    % Rejecting empty argument case
    error('No input arguments.')
elseif nargin == 1
        order = 18;
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
elseif lines < order
    warning('The results will not be unique - number of data points is less than approximation order');
else
    for i = 1:cols
        datax = (0:lines-1)';
        [pa, ~, mju] = polyfit(datax, data(:,i), order);
        data2 = polyval(pa, datax, [], mju);
        inters = sum(abs(diff(sign(data(:,i)-data2)))>0);
        fd(i) = 1 + log10(inters) / log10(lines - 1);
    end

end