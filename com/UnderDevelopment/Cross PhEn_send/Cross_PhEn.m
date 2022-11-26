%Cross_PhEn( data1, data2, k,'tau',1 )
function [ cPhEn12, cPhEn21 ] = Cross_PhEn( data1, data2, k,varargin )
% This is a test function prepared to compute cross phase entropy
%   Detailed explanation goes here
%%

if size(data1,1)> 1 && size(data1,2)>1 
    error('Data1 must be a vector')
end    
if size(data2,1)>1 && size(data2,2)>1
      error('Data must be a vector')
end

data1 = data1(:)';
data2 = data2(:)';

%pnames = { 'tau'  'scale'};
pnames = {'tau'};
%dflts =  {1 2};
dflts =  {1};
[tau] = internal.stats.parseArgs(pnames, dflts, varargin{:});




p1 = prob_dist_phen(data1, k, tau);
p2 = prob_dist_phen(data2, k, tau);
 
p1 = p1(:)';
p2 = p2(:)';
 
cPhEn12 = -(1/(log(k)))*p1*log(p2)'; 
cPhEn21 = -(1/(log(k)))*p2*log(p1)'; 
end

