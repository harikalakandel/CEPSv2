function example_mse_cluster()
clear all; clc
%     Input :
%	  algorithmType : 1 = se_brute_force_real
%	                  2 = se_sort_real
%					  3 = sample_entropy_cluster_1d
%     m             : Macth points
%     r             : Match Tolerance (Threshold)
%     n             : Data Length
%     x             : Input data
%     std           : 0 = r
%                     1 = r * std
%     Output :
%     entropy       : output results
input = 1; n = 1000;
if (input == 1)
%     n = 2000; 
    rand('seed',123);x= rand(1,n);% input signal
elseif (input == 2)
    t=1:0.13:10; n = length(t); x = cos(2*pi*t/1);
elseif (input == 3)
    t = [0:n-1];
    t = t/n;
    for i = 1:n
        x(i) = sin(100*t(i));
    end
    n = length(t);
end

method = 1;
m = 2;
r = 0.35;
std = 1;
for (i = 1 : 1000)
tic;
entropy = SpEn_NCU(method, m, r, n, std, x);
time(i) = toc;
end
time_avr = mean(time)
return





