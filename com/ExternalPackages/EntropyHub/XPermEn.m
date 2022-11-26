function [XPerm] = XPermEn(Sig, varargin) 
% XPermEn  estimates the cross-permutation entropy between two univariate data sequences.
%
%   [XPerm] = XPermEn(Sig) 
% 
%   Returns the cross-permuation entropy estimates (``XPerm``) estimated betweeen
%   the data sequences contained in ``Sig`` using the default parameters:
%   embedding dimension = 3, time delay = 1, logarithm = base 2, 
%
%   [XPerm] = XPermEn(Sig, name, value, ...)
% 
%   Returns the permutation entropy estimates (``XPerm``) for the data sequences
%   contained in ``Sig`` using the specified name/value pair arguments:
% 
%       * ``m``     - Embedding Dimension, an integer > 2   [default: 3]
%         **Note: ``XPerm`` is undefined for embedding dimensions < 3.
%       * ``tau``   - Time Delay, a positive integer        [default: 1]
%       * ``Logx``  - Logarithm base, a positive scalar     [default: 2]
%         (enter 0 for natural log).    
%
%   See also:
%       PermEn, XApEn, XSampEn, XFuzzEn, XMSEn
%   
%   References:
%     [1] Wenbin Shi, Pengjian Shang, and Aijing Lin,
%           "The coupling analysis of stock market indices based on 
%           cross-permutation entropy."
%           Nonlinear Dynamics
%           79.4 (2015): 2439-2447.


narginchk(1,7)
Sig = squeeze(Sig);
if size(Sig,1) == 2
    Sig = Sig';
end
p = inputParser;
Chk1 = @(x) isnumeric(x) && ismatrix(x) && (min(size(x))==2) && numel(x)>20;
Chk2 = @(x) isnumeric(x) && isscalar(x) && (x > 2) && (mod(x,1)==0);
Chk = @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x,1)==0);
addRequired(p,'Sig',Chk1);
addOptional(p,'m',3,Chk2);
addParameter(p,'tau',1,Chk);
addParameter(p,'Logx',exp(1),@(x) isscalar(x) && (x >= 0));
parse(p,Sig,varargin{:})
m = p.Results.m; tau = p.Results.tau; Logx = p.Results.Logx; 

if Logx == 0
    Logx = exp(1);
end
S1 = Sig(:,1); S2 = Sig(:,2);
N = length(S1)-(m-1)*tau;
Sx1 = zeros(N,m);
Sx2 = zeros(N,m);
for k = 1:m    
    Sx1(:,k) = S1(1+(k-1)*tau:N+(k-1)*tau);
    Sx2(:,k) = S2(1+(k-1)*tau:N+(k-1)*tau);
end
[~, Temp] = sort(Sx1,2,'ascend');
Gx = zeros(N,m);
for k = 1:N
    Gx(k,:) = Sx2(k,Temp(k,:));   
end

Kt = zeros(m-2,m-2,N);
for k = 1:m-2           
    for j = k+1:m-1           
        G1 = Gx(:,j+1) - Gx(:,k);
        G2 = Gx(:,k) - Gx(:,j);        
        Kt(k,j-1,:) = (G1.*G2 > 0);        
    end      
end

Di = squeeze(sum(sum(Kt,2),1));
Ppi = histcounts(Di,[-.5:((m-2)*(m-1) + 1)/2])/N;
Ppi(Ppi==0) = [];
XPerm = -sum(Ppi.*(log(Ppi)/log(Logx)));
if round(sum(Ppi),6)~=1
    warning('Potential error with probability calculation')
end
clear Temp Ppi Di Kt G1 G2
end

% 
%   Copyright 2021 Matthew W. Flood, EntropyHub
% 
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
%
%        http://www.apache.org/licenses/LICENSE-2.0
%
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
%
%   For Terms of Use see https://github.com/MattWillFlood/EntropyHub