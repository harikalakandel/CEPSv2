%function [fractdim] = boxcount1d(series)
%Linder
function [boxsize,count,fractdim] = boxcount_Gwendolyn(series)
%boxcount1d  Box-counting of a 1D signal.
%  [boxsize,count,fractdim] = boxcount1d(series)
%
% Counts the number of boxes necessary to cover the signal, as a function
% of box size.  The signal is assumed to be continuous and linear in
% between samples.  Box boundaries are rounded to the closest sample.
%
%  Arguments:
%  - series:   vector with sampled time signal
% 
%  Returns:
%  - boxsize:  average number of samples per box
%  - count:    number of boxes filled for this boxsize
%  - fractdim: fractal dimension as determined from box-count slope
%FD_Linden_Box
%FD_Moisy_Box

% (c) 2010 Gwendolyn van der Linden
% Inspired by Esther Meerwijk

n = length(series);
m = floor(log(n)/log(2))-1;

series_min = min(series);
series_range = max(series) - series_min;

boxsize = zeros(m,1);
count = zeros(m,1);

for i = 1:m
  k = 2^(i-1);
  boxsize(i) = n/k;
  y = (series-series_min)*k/series_range;
  for j=1:k
    idx1 = round((j-1)*n/k)+1;
    idx2 = round(j*n/k);
    yj = y(idx1:idx2);
    count(i) = count(i) + ceil(max(yj)) - floor(min(yj));
  end
end
p=polyfit(log(boxsize), log(count), 1);
fractdim=-p(1);
