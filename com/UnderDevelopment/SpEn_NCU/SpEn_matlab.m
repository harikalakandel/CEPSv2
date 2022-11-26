function SpEn_matlab()
clear all; clc
input = 1;
if (input == 1)
    n = 1000; rand('seed',123);x= rand(1,n);% input signal
elseif (input == 2)
    t=1:0.13:10; n = length(t); x = cos(2*pi*t/1);
elseif (input == 3)
    t = [0:9999];
    t = t/10000;
    for i = 1:10000
        x(i) = sin(100*t(i));
    end
    n = length(t);
end
m = 2; % pattern length (emplate length)
r = 0.35; % normalized distance threshold

r2 = r*std(x);
[fCount entropy] =  BruteForce_SpEn_matlab(1, n, m, r2, x);
[1];
return;

function [fCount entropy] =  BruteForce_SpEn_matlab(i1, i2, m, r, y) 
% m == match; based on adaptive algorithm in 2011 paper
% but we dont need the if compare, instead we use index upper(iUB) & lower
% (iLB) insted to compute abs(x(i+m) - x(j+m)) <= r
cont = zeros(1,m+1); fCount = zeros(1,m+1);

imax = -100000; % DEBUG ONLY 
n = i2 - i1 + 1;
NS = i2  - m + 1;
%NS = i2  - m ;
 
%//  NS = i2; 
imax = 0;
for (i = i1: NS-1) 
  for (j = i+1: NS-1) % // take symmetric property
    for (k = 0:m)
        if (abs(y(i + k) - y(j + k)) <= r)
            imax = max(i+k,imax);   imax=max(imax,j+k); % DEBUG ONLY
            cont(k+1) = cont(k+1) + 1;
        else
            break;
        end
    end % k
  end % j
  for (k = 0:m)
    fCount(k+1) = fCount(k+1) + cont(k+1) ;
    cont(k+1) = 0;
  end
end % i
entropy = -log(fCount(m+1)/fCount(m));

return; % BruteCalcEntropy_2018_0502