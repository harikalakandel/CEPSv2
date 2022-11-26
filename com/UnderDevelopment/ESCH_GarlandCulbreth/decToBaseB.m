%#Takes a decimal number and converts it to base b.

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



%dec.2.base_b <- function(x, b = 2) 
%%%{
function [Baseb] = decToBaseB(x,varargin)
if isempty(varargin)
    b = 2;
else
    b=varargin{1};
end
disp('B is :::::::::::')
disp(b)
  %xi <- as.integer(x)
  xi=floor(x)
%   if (any(is.na(xi) | ((x - xi) != 0))) 
%     print(list(ERROR = "x not integer", x = x))
if (sum(isnan(xi)) + sum((x-xi)~=0))>0
    disp('x not integer');
end
  %N <- length(x)
  N = length(x);
  %xMax <- max(x)
  xMax = max(x);
  %ndigits <- (floor(logb(xMax, base = 2)) + 1)
  ndigits = floor(log2(xMax))+1;
  %Base.b <- array(NA, dim = c(N, ndigits))
  Baseb = nan(N,ndigits);
%   for (i in 1:ndigits) {
%     Base.b[, ndigits - i + 1] <- (x%%b)
%     x <- (x%/%b)
%   }
for i=1:ndigits
    Baseb(:,ndigits-i+1)= mod(x,2);
    x = floor(x/2);
end

%  if (N == 1) 
%     Base.b[1, ]
%   else Base.b
%%}
end


